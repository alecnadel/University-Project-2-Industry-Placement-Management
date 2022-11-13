import os
from datetime import date
from werkzeug.utils import secure_filename
from werkzeug.datastructures import FileStorage
from models.db import get_cursor
from flask import request,Flask
from models.company_model import host_id_creator,project_id_creator,student_id_creator
from models.users import User_id_creator
from models.services import AdminCurrentSemester, PrjectForNextSemester, StudentProjectSemester #,semester_selector
import uuid

def semester_selector(date):
   
    if date.month <= 6:
        semeter = 1
    else:
        semeter = 2
    return semeter

app = Flask(__name__)
app.config["UPLOAD_FOLDER"]= "static/img"
app.config["UPLOAD_CV"]="static/CV"

# get student_profile
def get_student_profile(id):
    cur = get_cursor()
    cur.execute ("select first_name,last_name,phone_number,email,Photo from students where student_id =%s",(id,))
    profile = cur.fetchone()
    return profile

# update student profile and photo(save photo to img folder)
def update_student_profile(id):
    cur = get_cursor()
    phone_number = request.form.get('phone_number')
    email = request.form.get('email')
    f = request.files['photo']
    # if user upload a new photo,filename is not empty string
    if f.filename !="":
        filename = secure_filename(f.filename)
        f.save(os.path.join(app.config["UPLOAD_FOLDER"],filename))
        # get relative filepath of the uploaded photo, including filename
        photo = "../../"+ app.config["UPLOAD_FOLDER"]+"/"+ filename 
        cur.execute("update students SET phone_number=%s, email =%s, Photo=%s where student_id=%s",(phone_number,email,photo,id))
    # if user did not upload a new photo    
    else:
        cur.execute("update students SET phone_number=%s, email =%s where student_id=%s",(phone_number,email,id))
    return cur.fetchall()

#Display a list of students in the table.
def show_students_by_id(id):
    cur = get_cursor()
    cur.execute("select first_name,last_name,placement_status,photo,phone_number,email,interests,CV,project_city,attendance,semester from students where student_id=%s",(id,))
    rows = cur.fetchall()
    return rows[0] if len(rows) else None

#Admin can edit student information from the form.
def update_student_by_ID(form,id):
    cur = get_cursor()
    fname = form.get('firstName')
    lname = form.get('lastName')
    status = form.get('placementStatus')
    phone = form.get('phoneNumber')
    email = form.get('Email')
    interest = form.get('Interests')
    pcity = form.get('projectCity')
    attendance = form.get('Attendance')
    cur.execute("""update students set
                first_name=%s, last_name=%s, placement_status=%s, phone_number=%s, email=%s, 
                interests=%s, project_city=%s, attendance=%s where student_id=%s;""",
    (fname,lname,status,phone,email,interest,pcity,attendance,id))
    return cur.fetchall()

def show_response(id):
    cur = get_cursor()

    Year, Semester = PrjectForNextSemester()

    cur.execute("""SELECT i.organization_name, p.project_description FROM projects p
                    JOIN industry_host i 
                        ON p.Industry_host_id = i.Industry_host_id 
                        WHERE year=%s AND semester=%s ;""",(Year,Semester,))
    rows = cur.fetchall()
    return rows[0] if len(rows) else None

#Student able to add their response yes/no in the table form, response here act as a variable to loop over the form and get industry hostID.
def add_response(student_id,company_ids,form):
    cur = get_cursor()
    for id in company_ids: #loop over the ids (company ids as host ids who attending the event.)
        if form.get('response_{}'.format(id[0])) == "1": #here if the form get a valid reponse 'yes' then the company ids insert to the student selection table?
            
            cur.execute("insert into student_selections set Students_id=%s, Industry_host_id=%s;",(student_id,id[0],))
    
    return cur.fetchall()

def get_host_id(organization_name):
    cur = get_cursor()
    cur.execute("""SELECT Industry_host_id FROM industry_host WHERE organization_name=%s;""",(organization_name,))
    return cur.fetchall()


#This table is for student to add a response to indicate their interest in the companies after networking event.
def student_interest_report(student_id):
    cur = get_cursor()
    Year, Semester = StudentProjectSemester(student_id)
    cur.execute("""SELECT i.organization_name as Company, p.project_description AS Project 
                        FROM projects p
                        JOIN industry_host i 
                            ON p.Industry_host_id = i.Industry_host_id 
                        WHERE year=%s AND semester=%s;""",(Year,Semester,))
    return cur.fetchall()

# to check if student has complete the survey or not, if has completeed, return is not None, if not,the return value is none.
def survey_status(id):
    cur = get_cursor()
    cur.execute("SELECT first_name from students where student_id=%s;",(id,))
    rows = cur.fetchone()
    return rows
      

#get student survey data and insert into database
def student_init_survey(form,id):
    cur = get_cursor()
    fname = form.get("first_name")
    lname = form.get("last_name")
    phone = form.get("phone_number")
    email = form.get("email")
    place_status= form.get("potential_project")
    interest = form.get("interest")
    iproject = form.get("ideal_project")
    sbackground = form.get("prior_background")
    psgoal = form.get("post_goal")
    p = form.get("location")
    if p =="on":
        pcity="Christchurch"
    else:
        pcity=form.get("locationtext")
    attendance= form.get('attendance')
    year = '2022'
    semester = '1'
    cur.execute("INSERT INTO students set student_id=%s,first_name=%s, last_name=%s,placement_status=%s,phone_number=%s, email=%s, interests=%s, ideal_Project=%s, Student_background=%s, \
                post_study_goal=%s, project_city=%s, attendance=%s, year=%s, semester=%s ;",
                (id,fname,lname,place_status,phone,email,interest,iproject,sbackground,psgoal,pcity,attendance,year,semester))
    return cur.fetchall()


# if student already has a project arranged, get data and insert into database
def student_project(form,student_id):
    cur = get_cursor()
    project_descrip = form.get("project_descrip")
    project_id = project_id_creator()
    orga_name = form.get("orga_name")
    contact_person =form.get("contact_person")
    contact_number =form.get("contact_number")
    contact_email =form.get("contact_email")
    year, semester = StudentProjectSemester(student_id)
    host_id = User_id_creator(2) # 2 for new company user_id
    password = uuid.uuid4().fields[0]
    cur.execute("INSERT INTO users \
                SET Users_id=%s,user_name=%s,password=%s,role=%s;",(host_id,orga_name,password,2))# update users table
    cur.execute ("INSERT INTO industry_host \
                    SET Industry_host_id=%s,organization_name=%s,contact_name=%s,contact_phone=%s,contact_email=%s;",
                    (host_id,orga_name,contact_person,contact_number,contact_email))#update industry_host table
    cur.execute("INSERT INTO projects \
                SET Projects_id=%s,Industry_host_id=%s,project_description=%s,year=%s,semester=%s;",
                    (project_id,host_id,project_descrip,year,semester)) #update project table
    return cur.fetchall()

#Get the data from industry host table join company selection table to confirm a student had interview with the company before update the form
def get_hostid_interview(student_id):
    cur = get_cursor()
    cur.execute("select c.Students_id, i.Industry_host_id, i.organization_name as Company, t.tech_name as Mentor, p.project_description as Project, p.Projects_id \
                from industry_host i \
                join company_selections c on i.Industry_host_id = c.Industry_host_id \
                join projects p on i.Industry_host_id = p.Industry_host_id \
                join tech_person t on p.Tech_id = t.Tech_id \
                WHERE c.Students_id=%s and match_confirmation=1;",(student_id,))
    return cur.fetchall()

#Add interview outcome form for student
def add_interview(Students_id,company_ids,form):
    cur = get_cursor()
    interviewid = uuid.uuid4().fields[0]
    interviewdate = form.get("date")
    studentid = form.get("student_id")
    host_data = tuple(map(int,form.get("hostid").split(', ')))
    hostid = host_data[0]
    projectid = host_data[1]
    comment = form.get("comments")
    rating = form.get("rating")
    cur.execute("insert into interviews (Interviews_id,Students_id,Industry_host_id,comments,rating,date) values (%s,%s,%s,%s,%s,%s);",(interviewid,Students_id,hostid,comment,rating,interviewdate))
    Confirmed_Placement = form.get("Confirmed_Placement")
    if Confirmed_Placement == '1':
        cur.execute("UPDATE students SET placement_status=1  WHERE student_id=%s",(Students_id,))
        cur.execute("INSERT INTO placement (Students_id, Projects_id) VALUES (%s,%s)",(Students_id,projectid,))
    return cur.fetchall()


# get student electives info, if not checked, then value is None, only update database when value is Not None.
def student_elective(form,id):
    cur = get_cursor()
    elec1 = form.get('cbox1')
    elec2 = form.get('cbox2')
    elec3 = form.get('cbox3')
    elec4 = form.get('cbox4')
    elec5 = form.get('cbox5')
    elec6 = form.get('cbox6')
    elec7 = form.get('cbox7')
    if elec1 is not None:
        cur.execute("INSERT INTO student_electives (Students_id,Elective_id) VALUES (%s,%s);",(id,elec1))
    if elec2 is not None:    
        cur.execute("INSERT INTO student_electives (Students_id,Elective_id) VALUES (%s,%s);",(id,elec2))
    if elec3 is not None:
        cur.execute("INSERT INTO student_electives (Students_id,Elective_id) VALUES (%s,%s);",(id,elec3))
    if elec4 is not None:
        cur.execute("INSERT INTO student_electives (Students_id,Elective_id) VALUES (%s,%s);",(id,elec4))
    if elec5 is not None:
        cur.execute("INSERT INTO student_electives (Students_id,Elective_id) VALUES (%s,%s);",(id,elec5))
    if elec6 is not None:
        cur.execute("INSERT INTO student_electives (Students_id,Elective_id) VALUES (%s,%s);",(id,elec6))
    if elec7 is not None:
        cur.execute("INSERT INTO student_electives (Students_id,Elective_id) VALUES (%s,%s);",(id,elec7))
    
    return cur.fetchall()


# get student 5 tech rank data, as 4 and 5 are optional,if user does not select those two, default value is 0,
#  so only update those 2 to database when tech4 and tech5 value is not 0.
def stu_tech_rank(form,id):
    cur = get_cursor()
    tech1 = form.get("tech1")
    tech2 = form.get("tech2")  
    tech3 = form.get("tech3")  
    tech4 = form.get("tech4")  
    tech5 = form.get("tech5")
    cur.execute("INSERT INTO student_tech_rank (Students_id,Technologies_id,rank_number) VALUE(%s,%s,%s);",(id,tech1,1))
    cur.execute("INSERT INTO student_tech_rank (Students_id,Technologies_id,rank_number) VALUE(%s,%s,%s);",(id,tech2,2))
    cur.execute("INSERT INTO student_tech_rank (Students_id,Technologies_id,rank_number) VALUE(%s,%s,%s);",(id,tech3,3))
    if tech4 !="":
        cur.execute("INSERT INTO student_tech_rank (Students_id,Technologies_id,rank_number) VALUE(%s,%s,%s);",(id,tech4,4))
    if tech5 !="":
        cur.execute("INSERT INTO student_tech_rank (Students_id,Technologies_id,rank_number) VALUE(%s,%s,%s);",(id,tech5,5))
    return cur.fetchall()    



#students who will attend the event for this semester
def attending_students():
    cur = get_cursor()
    year, semester = AdminCurrentSemester()
    
    cur.execute("""SELECT student_id, first_name, last_name, email, phone_number 
                    FROM students 
                        WHERE attendance=1 and year=%s and semester=%s
                            ORDER BY last_name,first_name;""",(year,semester))
    return cur.fetchall()
    


def IndustryHost_select_form(company):
    cur = get_cursor()
    
    year, semester = AdminCurrentSemester()
    cur.execute("""SELECT student_id,Photo,first_name, last_name, Students_id, responses, additional_note
	                    FROM students S
		                    LEFT JOIN company_selections CS
			                    ON S.student_id = CS.Students_id
			                WHERE attendance=1 and S.year=%s and S.semester=%s and CS.Industry_host_id=%s
				                ORDER BY last_name,first_name;""",(year,semester,company))
    student = cur.fetchall()
    if student:
        return student
    else:
        cur.execute("""SELECT student_id,Photo,first_name, last_name
	                    FROM students 
			                WHERE attendance=1 and year=%s and semester=%s  
				                ORDER BY last_name,first_name;""",(year,semester))
        student = cur.fetchall()
        return student

def IndustryHost_select_Insert(row,form):
    cur = get_cursor()
    cur.execute("""INSERT INTO company_selections (Industry_host_id, Students_id, responses, additional_note)
            VALUES (%s,%s,%s,%s);""",(row[0],row[1],row[2],row[3],))





# get student name and background info from db for background report
def stu_bg():
    cur = get_cursor()
    cur.execute("SELECT student_id,first_name, last_name,Student_background from students where attendance=1") 
    return cur.fetchall()                  



#update CV to database and save the relative path
def uploadcv(id):
    cur = get_cursor()
    f = request.files['CV']
    filename = secure_filename(f.filename)
    if filename!="":
        f.save(os.path.join(app.config["UPLOAD_CV"],filename))
        # get relative filepath of the uploaded CV, including filename
        CV = "../../"+ app.config["UPLOAD_CV"]+"/"+ filename  
        cur.execute("update students SET CV=%s where student_id=%s",(CV,id))   
        return filename
    else:
        return None    
  



def placement_report():
    """function returns info on the students that have been placed for project for 
        the upcoming semester."""
    cur = get_cursor()
    Year, Semester = PrjectForNextSemester()
    cur.execute("SELECT S.student_id,S.first_name,S.last_name,IH.organization_name,PR.project_description \
                    FROM students S \
                        JOIN placement P \
                            ON P.students_id=S.student_id \
                        JOIN projects PR \
                            ON P.Projects_id=PR.Projects_id\
                        JOIN industry_host IH \
                            ON IH.Industry_host_id=PR.Industry_host_id \
                    WHERE S.placement_status=1 AND PR.year=%s AND PR.semester=%s ;""",(Year,Semester,))
    return cur.fetchall()


    