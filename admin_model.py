import os
from cv2 import CAP_PROP_INTELPERC_DEPTH_SATURATION_VALUE

import flask
from models.db import get_cursor
from models.services import StudentProjectSemester,HostCurrentSemester, PrjectForNextSemester,\
                            AdminCurrentSemester
from models.users import User_id_creator
from werkzeug.utils import secure_filename
from flask import flash, request, session, Flask
from datetime import date
from pandas import read_excel, DataFrame,concat
from numpy import nan

app = Flask(__name__)
app.config["UPLOAD_CV"]="static/CV"

def industry_student_selection_update(company_id,form):
    cursor = get_cursor()
    year, semester = HostCurrentSemester(company_id)
    cursor.execute("""SELECT student_id
                        FROM students 
                            WHERE attendance=1 and year=%s and semester=%s
                                ORDER BY last_name,first_name;""",(year,semester))
    student_ids = cursor.fetchall()  
    
    for id in student_ids:
        
        response = form.get("response_{}".format(id[0]))
        notes = form.get("notes_{}".format(id[0]))
        if notes.strip() == "" and response == "3":
            cursor.execute("DELETE FROM company_selections \
                                WHERE Industry_host_id=%s AND Students_id=%s;",(company_id,id[0],))
        else:
            cursor.execute("DELETE FROM company_selections \
                                WHERE Industry_host_id=%s AND Students_id=%s;",(company_id,id[0],))
            cursor.execute("INSERT INTO company_selections(Industry_host_id,Students_id, responses,additional_note) \
                                        VALUES (%s, %s, %s, %s); ",(company_id,id[0],response,notes,))

    cursor.execute("UPDATE host_attendance \
                    SET selection_status=1 \
                    WHERE Industry_host_id=%s and year=%s and semester=%s; ",(company_id,year,semester,))
    return None

def admin_student_profile_report(hostid):
    cur = get_cursor()
    
    Year, Semester = HostCurrentSemester(hostid)
    cur.execute("""SELECT S.student_id,S.Photo,S.first_name, S.last_name, 
		(CASE
			WHEN S.student_id IN (SELECT C.students_id 
										FROM company_selections C WHERE C.Industry_host_id=%s) 
				THEN (SELECT responses FROM company_selections C WHERE C.Students_id=S.student_id AND C.Industry_host_id=%s)
			ELSE 3
		END) AS responce,
        (CASE
			WHEN S.student_id IN (SELECT C.students_id 
										FROM company_selections C WHERE C.Industry_host_id=%s) 
				THEN (SELECT additional_note FROM company_selections C WHERE C.Students_id=S.student_id AND C.Industry_host_id=%s)
			ELSE NULL
		END) AS additional_note
		FROM students S
		WHERE  attendance=1 AND year=%s AND semester=%s 
		ORDER BY last_name,first_name;""",(hostid,hostid,hostid,hostid,Year,Semester))
    return cur.fetchall()


def admin_add_response(student_id,company_ids,form):
    cur = get_cursor()
    for id in company_ids: #loop over the ids (company ids as host ids who attending the event.)
        if form.get('response_{}'.format(id[0])) == "1": #here if the form get a valid reponse 'yes' then the company ids insert to the student selection table?
            cur.execute("DELETE FROM student_selections \
                                WHERE Industry_host_id=%s AND Students_id=%s;",(id[0],student_id,))
            cur.execute("insert into student_selections set Students_id=%s, Industry_host_id=%s;",(student_id,id[0],))
        else:
            cur.execute("DELETE FROM student_selections \
                                WHERE Industry_host_id=%s AND Students_id=%s;",(id[0],student_id,))
    
    return cur.fetchall()

def admin_show_host_project(student_id):
    cursor = get_cursor()
    year,semester = StudentProjectSemester(student_id)
    cursor.execute("SELECT I.Industry_host_id,I.organization_name,P.project_description,\
                           I.contact_name,T.tech_name, \
                        (CASE \
                            WHEN I.Industry_host_id IN (SELECT S.Industry_host_id \
                                                        FROM student_selections S WHERE S.Students_id=%s) \
                                THEN 1 \
                            ELSE 0 \
                        END) AS responce \
                        FROM industry_host I \
                            JOIN projects P \
                                ON I.Industry_host_id=P.Industry_host_id \
                            join tech_person T \
                                ON I.Industry_host_id=T.Industry_host_id \
                            join host_attendance H \
                                ON I.Industry_host_id=H.Industry_host_id \
                        where P.year=%s and P.semester=%s;",(student_id,year,semester,))
    return cursor.fetchall()   


def CreateNewSemester():
    """Inserts the new Year and Semester for the upcoming selection period"""
    Year, Semester = PrjectForNextSemester()
    cur = get_cursor()
    cur.execute("INSERT adminsemester VALUES (%s,%s)",(Year, Semester,))
    return None

def Currenthostprojects(host_id):
    """function Selects the list of current projects for an industry host"""
    Year, Semester = PrjectForNextSemester()
    cur = get_cursor()

    cur.execute("SELECT organization_name FROM industry_host WHERE Industry_host_id=%s",(host_id,))
    HostNameraw = cur.fetchone()[0].lower().split(" ")
    HostName = ""
    for i,word in enumerate(HostNameraw):
        if not word in ["the","of","if","this"] and i != 0:
            HostName += word.capitalize() + " "
        elif word in ["the","of","if","this"] and i == 0:
            HostName += word.capitalize() + " "
        elif  not word in ["the","of","if","this"] and i == 0:
            HostName += word.capitalize() + " "
        else:
            HostName += word + " "
            
    HostName = HostName.strip(" ")
    
    cur.execute("SELECT P.Projects_id, P.Industry_host_id, P.Tech_id, \
		P.project_description, P.potential_placements, P.year, P.semester,\
        (CASE \
			WHEN P.Tech_id IN (SELECT T.Tech_id \
												FROM tech_person T WHERE T.Tech_id=P.Tech_id) \
				THEN (SELECT T.tech_name \
										FROM tech_person T WHERE T.Tech_id=P.Tech_id) \
			ELSE (SELECT I.contact_name \
									   FROM industry_host I WHERE I.Industry_host_id=P.Industry_host_id) \
		END) AS tech_name, \
        (CASE \
			WHEN P.Tech_id IN (SELECT T.Tech_id \
										FROM tech_person T WHERE T.Tech_id=P.Tech_id) \
				THEN (SELECT T.tech_phone \
										FROM tech_person T WHERE T.Tech_id=P.Tech_id) \
			ELSE (SELECT I.contact_phone \
									   FROM industry_host I WHERE I.Industry_host_id=P.Industry_host_id)  \
		END) AS tech_phone, \
        (CASE \
			WHEN P.Tech_id IN (SELECT T.Tech_id \
										FROM tech_person T WHERE T.Tech_id=P.Tech_id) \
				THEN (SELECT T.tech_email \
										FROM tech_person T WHERE T.Tech_id=P.Tech_id) \
			ELSE (SELECT I.contact_email \
									   FROM industry_host I WHERE I.Industry_host_id=P.Industry_host_id) \
		END) AS tech_email, \
        (CASE \
			WHEN P.Tech_id IN (SELECT T.Tech_id \
										FROM tech_person T WHERE T.Industry_host_id=P.Industry_host_id) \
				THEN (SELECT T.Tech_id \
										FROM tech_person T WHERE T.Tech_id=P.Tech_id) \
			ELSE -1 \
		END) AS Tech_id \
        FROM projects P \
		WHERE P.Industry_host_id =%s AND P.year=%s AND P.semester=%s;",(host_id,Year, Semester,))
    projects = cur.fetchall()

    cur.execute("SELECT organization_name,contact_name,contact_phone,contact_email \
                        FROM industry_host \
                            WHERE Industry_host_id=%s;",(host_id,))
    contactPerson = cur.fetchone()
    return projects, contactPerson, HostName, host_id

def TechPersonAdd(HostId,i,form):
    """function Add new techinical person to tech_person table"""
    tech_id  = int(form.get("techId_{}".format(i)))
    if tech_id == -1:
        
        Host_ID = form.get("Host_ID")
        tech_name = form.get("tech_name_{}".format(i))
        tech_phone = form.get("tech_phone_{}".format(i))
        tech_email = form.get("tech_email_{}".format(i))
        cur = get_cursor()
        print("1 tech_id")
        cur.execute("INSERT tech_person (Industry_host_id, tech_name, tech_phone, tech_email) \
                                        VALUES (%s,%s,%s,%s)",(Host_ID,tech_name,tech_phone,tech_email,))
        tech_id = cur.lastrowid
        print("tech_id",tech_id)
        return tech_id, HostId 
    else:
        
        tech_id = int(form.get("techId_{}".format(i)))
        return tech_id, HostId



def ProjectVariables(i,form):
    """function gets the project variables from the project update form."""
    # Tech_id = form.get("techId_{}".format(i))
    Host_ID = form.get("Host_ID")
    ProjectDescription= form.get("ProjectDescription_{}".format(i))
    potential_placements = form.get("potential_placements_{}".format(i))
    year = form.get("year_{}".format(i))
    semester = form.get("semester_{}".format(i))
    return Host_ID, \
           ProjectDescription, \
           potential_placements, \
           year, \
           semester

def HostProjectUpdates(HostId,form):
    """function update the prejects table for the selected industry host"""

    cur = get_cursor()
    ProjectCount = int(form.get("projectCount"))

    for i in range(1,ProjectCount+1):
        Tech_id,HostId = TechPersonAdd(HostId,i,form)

        if form.get("Projects_id_{}".format(i)) != None:
            Projects_id = form.get("Projects_id_{}".format(i))
            Host_ID, \
            ProjectDescription, \
            potential_placements, \
            year, \
            semester = ProjectVariables(i,form)
            cur.execute("UPDATE projects SET  Tech_id=%s, project_description=%s, \
                                            potential_placements=%s, year=%s, semester=%s \
				                WHERE Projects_id=%s;",
                                (Tech_id,ProjectDescription,potential_placements,year,semester,Projects_id,)) 
            
        else:
            Host_ID, \
            ProjectDescription, \
            potential_placements, \
            year, \
            semester = ProjectVariables(i,form)
            cur.execute("INSERT projects (Industry_host_id, Tech_id, project_description, \
                                          potential_placements, year, semester) \
                                        VALUES (%s,%s,%s,%s,%s,%s)",
                            (Host_ID,Tech_id,ProjectDescription,potential_placements,year,semester,))
    return HostId

def CurrentHostTechPersons(HostId):
    """functions return all techinical people for an industry host current in the
        tech_person table."""

    cur = get_cursor()

    cur.execute("SELECT Tech_id, tech_name, tech_phone, tech_email \
                        FROM tech_person \
                            WHERE Industry_host_id=%s",(HostId,))
    TechPersonsRaw = cur.fetchall()
    
    TechPersons = []
    names = []
    for TechPerson in TechPersonsRaw:
        if TechPerson[1] in names:
            TechPersons.append((TechPerson[0],"{}({})".format(TechPerson[1],names.count(TechPerson[1])),TechPerson[2],TechPerson[3],))
            names.append(TechPerson[1])
        else:
            TechPersons.append(TechPerson)
            names.append(TechPerson[1])

    return TechPersons, HostId

def EditProjectDescription(form):
    """This function process the updates project description using submitted form data."""

    projectIds = form.getlist("projectId")
    ProjectDescriptions = form.getlist("ProjectDescription")
    cur = get_cursor()

    for i,projectId in enumerate(projectIds):
        ProjectDescription = ProjectDescriptions[i]
        cur.execute("UPDATE projects SET project_description=%s WHERE Projects_id=%s",
                                                                            (ProjectDescription,projectId,))

    return None


def surveyData(survey,i,columnheadings,requiredInputs):
    """this function extracts survey values and check of they are null returns these values and checks
        if the set of required output values are not null."""
    outputs = []
    valueInputs = True
    for name in columnheadings:
        value = survey[name].values[i]
        value = ProcessNullInputs(value)
        if name in requiredInputs and value == None:
            outputs.append(value)
            valueInputs = False
        else: #name in requiredInputs:
            outputs.append(value)
        # elif not name in requiredInputs and value == None:
        #     outputs.append(value)
        
    return outputs, valueInputs


def InsertOrder(Survey):
    """the function contrals the order of insertions for the Main, Incomplete, Duplicates dataframes 
     in the Industry survey excel file."""

    InsertHostInfo(Survey)
    networkingAttendance(Survey)
    InsertTechPerson(Survey)
    InsertHostPrjoct(Survey)
    insertTechRanking(Survey)   
    return None


#update CV to database and save the relative path
def ReadExcelHostSurvey():
    cur = get_cursor()
    f = request.files['HostResponces']
    filename = secure_filename(f.filename)
    if filename!="":

        Survey = read_excel(f)
        # divides the main section from the Incomplete and Duplicates sections
        Survey = Survey.dropna(how='all')

        sections = {0:"Main",1:"Incomplete",2:"Duplicates"}
        Survey["group_no"] = Survey['Q1_OrgName'].isin(["Incomplete", "Duplicates"]).cumsum()
        Survey = Survey[~Survey['Q1_OrgName'].isin(['Incomplete', 'Duplicates'])]
        Survey = {sections[n]: Survey.loc[rows] for n, rows in Survey.groupby('group_no').groups.items()}

        InsertOrder(Survey["Main"])
        InsertOrder(Survey["Incomplete"])

        Survey2 = concat([Survey["Main"], Survey["Incomplete"]])
        # Survey2 = Survey["Main"].concat(Survey["Incomplete"], ignore_index=True)
        DuplicateInsert(Survey["Duplicates"],Survey2)  
        return filename
    else:
        return None   




def DuplicateInsert(SurveyDuplicates,SurveyOriginal):
    """"This function updated new inputs insert/update queries for Duplicates responses to the
        industry host survey (in excel Industry survey file)."""
    cur = get_cursor()
    RowCount = SurveyDuplicates.shape[0]
    cyear,csemester = AdminCurrentSemester()
    pyear,psemester = PrjectForNextSemester()
    for i in range(RowCount):
        organizationName = SurveyDuplicates["Q1_OrgName"].values[i]
        currentData = SurveyOriginal.loc[SurveyOriginal['Q1_OrgName'] == organizationName]
        if not currentData.empty:
            contactName = currentData["Q2_AdminName"].values[0]
            contactEmail = currentData["Q2_AdminEmail"].values[0]
            cur.execute("SELECT * FROM industry_host WHERE organization_name=%s AND contact_name=%s AND contact_email=%s",(organizationName,contactName,contactEmail,))
        else:
            continue
        
        host = cur.fetchall()
        # update organization info
        if cur.rowcount == 1:
            hostId = host[0][0]
            outputs, valueInputs = surveyData(SurveyDuplicates,i,["Q2_AdminName","Q2_AdminEmail","Q2_AdminPhone"],
                                              ["Q2_AdminName","Q2_AdminEmail"])
            
            if valueInputs:
                newName = outputs[0].strip().lower().title()
                newEmail = outputs[1].strip().lower()
                newPhone = outputs[2]
                if newPhone != None:
                    newPhone.strip()
                cur.execute("UPDATE industry_host SET contact_name=%s, contact_email=%s, contact_phone=%s \
                                                  WHERE Industry_host_id=%s",(newName,newEmail,newPhone,hostId))
        elif cur.rowcount == 0 :
            outputs, valueInputs = surveyData(SurveyDuplicates,i,["Q2_AdminName","Q2_AdminEmail","Q2_AdminPhone"],
                                              ["Q2_AdminName","Q2_AdminEmail"])
            if valueInputs:
                newName = outputs[0].strip().lower().title()
                newEmail = outputs[1].strip().lower()
                newPhone = outputs[2]
                if newPhone != None:
                    newPhone.strip()
                cur.execute("INSERT industry_host (Industry_host_id,contact_name,contact_phone,contact_email) \
                                                  VALUES (%s,%s,%s,%s)",(hostId,newName,newPhone,newEmail,))
        
        # insert/update host attendence record
        attendence, valueInputs = surveyData(SurveyDuplicates,i,["Q4_SpeedNetw"],["Q4_SpeedNetw"])
        if valueInputs:
            attendence = attendence[0].lower()
        cur.execute("SELECT * FROM host_attendance WHERE Industry_host_id=%s AND Year=%s AND Semester=%s",(hostId,cyear,csemester,))
        cur.fetchall()
        if valueInputs:
            if attendence[0] != "no" and valueInputs:
                
                if cur.rowcount == 1:
                    continue
                elif cur.rowcount == 0:
                    cur.execute("INSERT host_attendance (Industry_host_id, Year, Semester)\
                                                        VALUES (%s,%s,%s)",(hostId,cyear,csemester,))
            elif attendence[0] == "no" and valueInputs:
                if cur.rowcount == 1:
                    cur.execut("DELETE FROM host_attendance WHERE Industry_host_id=%s AND Year=%s AND Semester=%s",(hostId,cyear,csemester,))

        # InsertTechPerson(Survey)
        
        projects,pcount = GetTablePrimaryKey("SELECT * FROM projects WHERE Industry_host_id=%s AND year=%s AND semester=%s",
                                            hostId,[hostId,pyear,psemester])
        if pcount > 0:
            ProjectsId = projects[0][0] 

            cur.execute("SELECT * FROM tech_person T \
                                JOIN projects P \
                                    ON P.Industry_host_id = T.Industry_host_id \
                                WHERE T.Industry_host_id=%s AND P.Projects_id=%s AND P.year=%s AND P.semester=%s",
                                        (hostId,ProjectsId,pyear,psemester,))
            tech = cur.fetchall()
            techPerson, valueInputs = surveyData(SurveyDuplicates,i,["Q3_MentorName","Q3_MentorEmail","Q3_MentorPhone"],
                                                                    ["Q3_MentorName","Q3_MentorEmail"])
            tech_name = techPerson[0]
            tech_email = techPerson[1]
            tech_phone = techPerson[2]
            if (cur.rowcount == 1) and valueInputs:
                TechId = tech[0][0]

                cur.execute("UPDATE tech_person SET tech_name=%s ,tech_phone=%s ,tech_email=%s  \
                                                WHERE Industry_host_id=%s \
                                                    AND Tech_id = (SELECT Tech_id FROM projects \
                                                                    WHERE Industry_host_id=%s AND year=%s AND semester=%s)",
                                                (tech_name, tech_phone, tech_email, hostId, hostId, pyear, psemester))
            
            elif (cur.rowcount == 0) and valueInputs:
                
                cur.execute("INSERT tech_person (Industry_host_id,tech_name,tech_phone,tech_email) VALUES \
                                                (%s,%s,%s,%s)",(hostId,tech_name,tech_phone,tech_email,))


        # InsertHostPrjoct(Survey)
        
        project, valueInputs = surveyData(SurveyDuplicates,i,["Q6_ProjDesc"],["Q6_ProjDesc"])

        # cur.execute("SELECT * FROM projects WHERE Industry_host_id=%s AND year=%s AND semester=%s",(hostId,pyear,psemester,))
        # prjects =  cur.fetchall()
        if pcount >= 1 and valueInputs:
            prject = projects[0]
            ProjectsId = prject[0]
            project_description = project[0].strip()
            cur.execute("UPDATE projects SET Tech_id=%s, project_description=%s WHERE Projects_id=%s AND Industry_host_id=%s",(TechId,project_description,pyear,psemester,))
        elif pcount == 0 and valueInputs:
            prject = projects[0]
            ProjectsId = prject[0]
            project_description = project[0].strip()

            cur.execute("INSERT projects(Industry_host_id,Tech_id,project_description,potential_placements,year,semester) \
                                    VALUES (%s,%s,%s,%s,%s,%s)",(hostId,TechId,project_description,1,pyear,psemester,))
        
        
        # insertTechRanking(Survey) 
        Skills, valueInputs = surveyData(SurveyDuplicates,i,["Q5_Skills_All"],["Q5_Skills_All"])
        
        if pcount >= 1 and valueInputs:
            Skills = Skills.split(',')
            projectId = project[0][0]
            cur.execute("DELETE FROM project_tech_rank WHERE Projects_id=%s;",(projectId,))
            technology_names = (SurveyDuplicates["Q5_Skills_All"].values[i]).split(",")
            i = 1
            for name in technology_names:
                name = name.strip()
                compare = name.lower()
                cur.execute("SELECT Technologies_id FROM technology WHERE LOWER(name)=%s;",(compare,))
                techId = cur.fetchone()
                if techId != None:
                    techId = techId[0]
                    cur.execute("""INSERT INTO project_tech_rank VALUES (%s, %s, %s);""",(projectId,techId,i,))
                else:
                    cur.execute("INSERT technology (name) VALUES (%s)",(name,))
                    techId = cur.lastrowid
                    cur.execute("""INSERT INTO project_tech_rank VALUES (%s, %s, %s);""",(projectId,techId,i,))
                i+=1

    return None




def insertTechRanking(dataframe):
    """function inserts/updates tech rankings from industry host excel survey form."""

    cur = get_cursor()
    Year, Semester = PrjectForNextSemester()
    RowCount = dataframe.shape[0]
    for i in range(RowCount):
        organization_name = dataframe["Q1_OrgName"].values[i]

        hostId = GetHostId(dataframe,i)
        inputs = [hostId, Year, Semester]
        # row,count = GetTablePrimaryKey("SELECT * FROM host_attendance \
        #                                 WHERE Industry_host_id=%s AND Year=%s AND Semester=%s;",
        #                                 hostId,inputs)
        
        tech_name = dataframe["Q3_MentorName"].values[i]
        tech_name = ProcessNullInputs(tech_name)
        if tech_name != None:
            tech_name = tech_name.strip().lower().title()
        tech_email = dataframe["Q3_MentorEmail"].values[i]
        tech_email = ProcessNullInputs(tech_email)
        if tech_email != None:
            tech_email = tech_email.strip().lower()
        tech_inputs = [hostId, tech_name, tech_email]
        Tech,techCount = GetTablePrimaryKey("SELECT * FROM tech_person \
                                        WHERE Industry_host_id=%s AND tech_name=%s AND tech_email=%s;",
                                        hostId,tech_inputs)
        if techCount == 1:
            techId = Tech[0][0]
        else:
            techId = None

        project_description = ProcessNullInputs(dataframe["Q6_ProjDesc"].values[i])
        if project_description != None:
            project_description.strip()
            projectsInputs = [hostId,techId,project_description,Year,Semester]
            
            project,projectCount = GetTablePrimaryKey("SELECT * FROM projects \
                                            WHERE Industry_host_id=%s AND Tech_id=%s \
                                                AND project_description=%s AND year=%s\
                                                AND semester=%s;",
                                            hostId,projectsInputs)
            
            if projectCount == 1:
                projectId = project[0][0]
                cur.execute("DELETE FROM project_tech_rank WHERE Projects_id=%s",(projectId,))
                technology_names = (dataframe["Q5_Skills_All"].values[i]).split(",")
                i = 1
                for name in technology_names:
                    name = name.strip()
                    compare = name.lower()
                    cur.execute("SELECT Technologies_id FROM technology WHERE LOWER(name)=%s;",(compare,))
                    techId = cur.fetchone()
                    if techId != None:
                        techId = techId[0]
                        cur.execute("""INSERT INTO project_tech_rank VALUES (%s, %s, %s);""",(projectId,techId,i,))
                    else:
                        cur.execute("INSERT technology (name) VALUES (%s)",(name,))
                        techId = cur.lastrowid
                        cur.execute("""INSERT INTO project_tech_rank VALUES (%s, %s, %s);""",(projectId,techId,i,))
                    i+=1
    return None




def ProcessNullInputs(value):
    """this function sets null input to "" (empty string) so that they can be inserted into the 
        database."""
    
    if "nan" == str(value):
        value = None

    return value

def NullRowCheck(value):
    """this function sets null input to "" (empty string) so that they can be inserted into the 
        database."""

    return "nan" != str(value) and not str(value) in ["Incomplete","Duplicates"] 


# def InsertUpdateControl(organization_name,command1,command2,*inputs):
#     """function controls the insert or update control if statement"""

#     cur = get_cursor()
#     if NullRowCheck(organization_name):
#         cur.execute("SELECT industry_host_id FROM industry_host \
#                                     WHERE organization_name=%s",(organization_name,))
#         hostId = cur.fetchall()[0]
#         if cur.rowcount == 1:
#             hostId = hostId[0]
#             cur.execute(command1,inputs)
#         elif cur.rowcount == 0:
#             cur.execute(command2,inputs)
#         else:
#             flash("Ambiguous organisation name 2 identical organisation name \
#                     entries in industry_host table",category="error")
#     return None

def GetHostId(dataframe,i):
    """this function gets the host ID is aviable."""

    cur = get_cursor()
    organization_name = dataframe["Q1_OrgName"].values[i]
    cur.execute("SELECT industry_host_id FROM industry_host \
                                    WHERE organization_name=%s",(organization_name,))
    hostId = cur.fetchall()

    if cur.rowcount == 1:
        hostId = hostId[0][0]
        return hostId
    elif cur.rowcount == 0:
        return None
    else:
        return None


def NotNullColumnCheck(columnValues):
    """The function checks the column values given are not None if so returns true else false."""
    if None in columnValues:
        return False
    else:
        return True


def InsertHostInfo(dataframe):
    """The function inserts/updates the industry host data from excel survey."""

    
    RowCount = dataframe.shape[0]
    for i in range(RowCount):
        organization_name = ProcessNullInputs(dataframe["Q1_OrgName"].values[i])
        if organization_name != None:
            organization_name = organization_name.strip().upper()
        contact_name = ProcessNullInputs(dataframe["Q2_AdminName"].values[i])
        if contact_name != None: 
            contact_name = contact_name.strip().lower().title()
        contact_phone = ProcessNullInputs(dataframe["Q2_AdminPhone"].values[i])
        if contact_phone != None: 
            contact_phone = contact_phone.strip()
        contact_email = ProcessNullInputs(dataframe["Q2_AdminEmail"].values[i]).strip().lower()
       
        cur = get_cursor()
        if NullRowCheck(organization_name):


            cur.execute("SELECT industry_host_id FROM industry_host \
                                     WHERE organization_name=%s",(organization_name,))
            hostId = cur.fetchall()
            if cur.rowcount == 1:
                
                hostId = hostId[0][0]
                cur.execute("""UPDATE industry_host set organization_name=%s,contact_name=%s,
                                                        contact_phone=%s,contact_email=%s 
                                        where industry_host_id=%s;""",
                                    (organization_name,contact_name,contact_phone,contact_email,hostId,))
            elif cur.rowcount == 0:
                if NotNullColumnCheck([organization_name,contact_name,contact_email]):
                    results = cur.fetchall()
                    username = organization_name.strip().replace(" ","_").lower()
                    Industry_host_id = User_id_creator(2)
                    cur.execute("INSERT users (Users_id, user_name, password, role) VALUES (%s,%s,SHA2(%s,256),%s)",
                                                                                        (Industry_host_id,username,"Password1",2,))

                    cur.execute("""INSERT industry_host 
                                            (Industry_host_id,organization_name,contact_name,contact_phone,contact_email) 
                                            VALUES (%s,%s,%s,%s,%s)""",
                                            (Industry_host_id,organization_name,contact_name,contact_phone,contact_email,))
            else:
                flash("Ambiguous at least one organisation name is repeated identical\
                        entries in industry_host table",category="error")

def GetTablePrimaryKey(command,HostId,inputs):
    """this funtion get the first primary key for the command query given."""
    
    cur = get_cursor()
    if HostId != None:
        cur.execute(command,(*inputs,))
        ID = cur.fetchall()
        if ID == []:
            ID=None
        count = cur.rowcount
        return ID,count

    return None, 0

def NewEntryCheck(commandstr,*inputs):
    """function check if and input is present then false it is not present and true if 
        present the database table"""
    cur = get_cursor()
    cur.execute(commandstr,(*inputs,))

    if cur.rowcount > 0:
        return False
    return True

def networkingAttendance(dataframe):
    """The function inserts/updates the host network attendance data from excel survey."""

    

    
    cur = get_cursor()
    Year, Semester = PrjectForNextSemester()
    RowCount = dataframe.shape[0]
    for i in range(RowCount): 
        
        Attendance = ProcessNullInputs(dataframe["Q4_SpeedNetw"].values[i])
        if Attendance != None:
            Attendance.strip()
        # print(Attendance)
        # print('dataframe.loc[dataframe["Q4_SpeedNetw"] == Attendance,dataframe["Q4_SpeedNetw"] ]',dataframe.loc[dataframe["Q4_SpeedNetw"] == Attendance,dataframe["Q4_SpeedNetw"] ])
        Year, Semester = AdminCurrentSemester()
        hostId = GetHostId(dataframe,i)
        if hostId != None:
            inputs = [hostId, Year, Semester]
            row,count = GetTablePrimaryKey("SELECT * FROM host_attendance \
                                            WHERE Industry_host_id=%s AND Year=%s AND Semester=%s;",
                                            hostId,inputs)

            if count == 1:
                
                if Attendance == "Yes" or Attendance == "Maybe":

                    cur.execute("""UPDATE host_attendance SET Year=%s ,Semester=%s 
                                        WHERE Industry_host_id=%s;""",(Year, Semester,hostId,))
                    
                else:
                    cur.execute("DELETE FROM host_attendance WHERE \
                                    Industry_host_id=%s AND Year=%s AND Semester=%s",(*inputs,))
            elif count == 0:
                
                if Attendance == "Yes" or Attendance == "Maybe":
                    cur.execute("""INSERT INTO host_attendance(Industry_host_id,Year,Semester) 
                                VALUES (%s, %s, %s);""",(*inputs,))

    return None

        






def InsertTechPerson(dataframe):
    """The function inserts/updates the host techinical person info from excel survey."""

    cur = get_cursor()
    Year, Semester = PrjectForNextSemester()
    RowCount = dataframe.shape[0]
    for i in range(RowCount): 
        hostId = GetHostId(dataframe,i)
        inputs = [hostId, Year, Semester]
        tech_name = dataframe["Q3_MentorName"].values[i]
        tech_name = ProcessNullInputs(tech_name)
        if tech_name != None: 
            tech_name = tech_name.strip().lower().title()
        tech_email = dataframe["Q3_MentorEmail"].values[i]
        tech_email = ProcessNullInputs(tech_email)
        if tech_email != None: 
            tech_email = tech_email.strip().lower()
        tech_phone = dataframe["Q3_MentorPhone"].values[i]
        tech_phone = ProcessNullInputs(tech_phone)
        if tech_phone != None: 
            tech_phone = tech_phone.strip()
        tech_inputs = [hostId, tech_name, tech_email]
        Tech,count = GetTablePrimaryKey("SELECT * FROM tech_person \
                                        WHERE Industry_host_id=%s AND tech_name=%s AND tech_email=%s;",
                                        hostId,tech_inputs)
        
        if hostId != None and NotNullColumnCheck([hostId,tech_name,tech_email]):
            
            if count >= 1:
                techId = Tech[0][0]
                cur.execute("UPDATE tech_person SET Industry_host_id=%s, tech_name=%s,\
                                        tech_phone=%s, tech_email=%s \
                                        WHERE Tech_id=%s",(hostId,tech_name,tech_phone,tech_email,techId,))
            else:
                cur.execute("INSERT tech_person \
                                    (Industry_host_id,tech_name,tech_phone, tech_email) \
                                        VALUES (%s,%s,%s,%s)",
                                        (hostId,tech_name,tech_phone,tech_email,))

    return None


def InsertHostPrjoct(dataframe):
    """The function inserts/updates the host project data from excel survey."""



    cur = get_cursor()
    Year, Semester = PrjectForNextSemester()
    RowCount = dataframe.shape[0]
    for i in range(RowCount): 
        hostId = GetHostId(dataframe,i)
        inputs = [hostId, Year, Semester]
        project,projectCount = GetTablePrimaryKey("SELECT * FROM projects \
                                        WHERE Industry_host_id=%s AND Year=%s AND Semester=%s;",
                                        hostId,inputs)

        
        if project != None:
            projectId = project[0][0]
        else:
            projectId = None
        tech_name = dataframe["Q3_MentorName"].values[i]
        tech_name = ProcessNullInputs(tech_name)
        if tech_name != None:
            tech_name = tech_name.strip().lower().title()
        tech_email = dataframe["Q3_MentorEmail"].values[i]
        tech_email = ProcessNullInputs(tech_email)
        if tech_email != None:
            tech_email = tech_email.strip().lower()
        
        tech_inputs = (hostId, tech_name, tech_email,)
        if NotNullColumnCheck(tech_inputs):
            Tech,TechCount = GetTablePrimaryKey("SELECT * FROM tech_person \
                                            WHERE Industry_host_id=%s AND tech_name=%s AND tech_email=%s;",
                                            hostId,tech_inputs)
            TechId = Tech[0][0]
        else:
            Tech=None
            TechCount=0

        # if count >= 1:
        #     TechId = Tech[0][0]  
        # else:
        #     TechId = None                     
        project_description = dataframe["Q6_ProjDesc"].values[i]
        project_description = ProcessNullInputs(project_description)
        if project_description != None:
            project_description = project_description.strip()
            potential_placements = 1

            projectUpdates = [hostId,TechId,project_description,potential_placements,Year,Semester,projectId]
            
            if projectCount == 1:
                cur.execute("UPDATE projects SET Industry_host_id=%s, Tech_id=%s, project_description=%s, \
                                            potential_placements=%s, year=%s, semester=%s \
                                            WHERE Projects_id=%s",(*projectUpdates,))
            elif projectCount == 0:
                cur.execute("INSERT INTO projects \
                        (Industry_host_id, Tech_id, project_description, potential_placements, year, semester) \
                        VALUES (%s, %s, %s, %s, %s, %s);",
                        (hostId,TechId,project_description,potential_placements,Year,Semester,))
            else:
                cur.execute("UPDATE projects SET Industry_host_id=%s, Tech_id=%s, project_description=%s, \
                                            potential_placements=1, year=%s, semester=%s \
                                            WHERE Projects_id=%s;",(*projectUpdates,))
        



def AttendingManualUpdate(Host):
    """this function updates the host attendance table for speed networking event"""
    
    year, semester = AdminCurrentSemester()
    cur = get_cursor()
    cur.execute("SELECT * FROM host_attendance \
                            WHERE Industry_host_id=%s AND Year=%s AND Semester=%s",
                                  (Host, year, semester,))
    cur.fetchone()
    if cur.rowcount == 1:
        cur.execute("DELETE FROM host_attendance \
                            WHERE Industry_host_id=%s AND Year=%s AND Semester=%s",
                            (Host, year, semester,))
    else:
        cur.execute("INSERT host_attendance (Industry_host_id,Year,Semester) \
                            VALUES (%s, %s, %s)",
                            (Host, year, semester,))


def MatchingTable():
    """this function extract the data need to visualize the current state of student matching process."""

    cur = get_cursor()
    cYear, cSemester = AdminCurrentSemester()
    pYear, pSemester = PrjectForNextSemester()
    input = [cYear, cSemester, pYear, pSemester]
    cur.execute("""SELECT Industry_host_id,organization_name,student_id, first_name,last_name,
			(CASE 
		WHEN (student_id, Industry_host_id) IN (SELECT student_id, Industry_host_id FROM placement P
								INNER JOIN projects PR
									ON P.Projects_id = PR.Projects_id
								INNER JOIN students S
									ON S.student_id = P.Students_id) 
		THEN 3
        WHEN (Industry_host_id,student_id) IN 
        (SELECT C.Industry_host_id,S.Students_id FROM company_selections C
        INNER JOIN student_selections S
            ON S.Students_id=C.Students_id 
                WHERE C.Industry_host_id=S.Industry_host_id 
                    AND C.responses < 3 AND C.match_confirmation=1) 
        THEN 2
        WHEN (Industry_host_id,student_id) IN 
        (SELECT C.Industry_host_id,S.Students_id FROM company_selections C
        INNER JOIN student_selections S
            ON S.Students_id=C.Students_id 
                WHERE C.Industry_host_id=S.Industry_host_id 
                    AND C.responses < 3 AND C.match_confirmation=0) 
		THEN 1
		ELSE 0
		END) as MatchStatus
		FROM students CROSS JOIN industry_host WHERE year=%s  AND semester=%s 
			AND Industry_host_id in (SELECT Industry_host_id FROM projects WHERE year=%s AND semester=%s)
		ORDER BY organization_name, first_name, last_name;""",(*input,))
    
    MatchingResults = cur.fetchall()
    return MatchingResults