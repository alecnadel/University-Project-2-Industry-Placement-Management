from models.db import get_cursor
from models.services import StudentProjectSemester,HostCurrentSemester, StudentSemester
from flask import request, session
from datetime import date



def semeter_selector(date):
   
    if date.month <= 6:
        semeter = 1
    else:
        semeter = 2
    return semeter

# get company details by company id
def get_company_by_id(id):
    cur = get_cursor()
    cur.execute ("SELECT industry_host_id,organization_name,contact_name,contact_phone, contact_email from industry_host where industry_host_id=%s;",(id,))
    rows = cur.fetchall()
    return rows[0] if len(rows) else None


#update company details
def update_company_by_id(form,id):
    cur = get_cursor()
    companyname = form.get('companyName')
    contactname = form.get("contactName")
    contactnumber = form.get("contactNumber")
    contactemail = form.get("contactEmail")
    cur.execute ("UPDATE industry_host set organization_name=%s,contact_name=%s,contact_phone=%s,contact_email=%s where industry_host_id=%s;",(companyname,contactname,contactnumber,contactemail,id))
    return cur.fetchall()


def host_id_creator():
    cursor = get_cursor()
    cursor.execute("SELECT max(Industry_host_id) FROM industry_host;")
    host_id = int(cursor.fetchone()[0])+1
    return host_id

def project_id_creator():
    cursor = get_cursor()
    cursor.execute("SELECT max(Projects_id) FROM projects;")
    project_id = int(cursor.fetchone()[0])+1
    return project_id

def student_id_creator():
    cursor = get_cursor()
    cursor.execute("SELECT max(student_id) FROM students;")
    student_id = int(cursor.fetchone()[0])+1
    return student_id

def show_host_project(student_id):
    cursor = get_cursor()
    year,semester = StudentProjectSemester(student_id)
    cursor.execute("SELECT industry_host.Industry_host_id,industry_host.organization_name,projects.project_description,industry_host.contact_name,tech_person.tech_name from industry_host \
                   join projects on industry_host.Industry_host_id=projects.Industry_host_id \
                   join tech_person on industry_host.Industry_host_id=tech_person.Industry_host_id \
                   join host_attendance on industry_host.Industry_host_id=host_attendance.Industry_host_id \
                   where projects.year=%s and projects.semester=%s;",(year,semester,))
    return cursor.fetchall()    

# def Selection_status(student_id):

#     cur = get_cursor()
#     todays_date = date.today()
#     year = todays_date.year
#     semester = semeter_selector(todays_date)

#     cur.execute("SELECT Students_id  \
#                         FROM student_selections SS \
#                             INNER JOIN students \
#                                 ON SS.Students_id = S.student_id\
#                             WHERE Students_id=%s AND ",(student_id,))
#     if cur.rowcount > 0:
#         form_complete = True
#     else:
#         form_complete = False

#     cur.execute("SELECT Students_id  \
#                      FROM students \
#                      WHERE Students_id=%s AND year=%s \
#                          AND semester=%s AND attendance=0",(student_id,year,semester,))
#     if cur.rowcount > 0:
#         Not_attending = True
#     else:
#         Not_attending = True
#     return form_complete,Not_attending



#Get the matched companies for student to view.
def show_matching(Students_id):
    cursor = get_cursor()
    year, semester = StudentProjectSemester(Students_id)
    Students_id = session['user_id']
    cursor.execute("SELECT CS.Industry_host_id, CS.Students_id, IH.organization_name, P.project_description, T.tech_name \
                    FROM company_selections CS \
                    JOIN industry_host IH ON CS.Industry_host_id = IH.Industry_host_id \
                    JOIN projects P ON P.Industry_host_id = IH.Industry_host_id \
                    JOIN tech_person T ON P.Tech_id = T.Tech_id \
                    WHERE P.year=%s AND P.semester=%s AND CS.Students_id=%s and CS.match_confirmation = 1;",(year,semester,Students_id))
    return cursor.fetchall()


def get_project_host_attending(student_id):
    cursor = get_cursor()
    year,semester = StudentSemester(student_id)
    cursor.execute("SELECT Industry_host_id FROM host_attendance WHERE Year=%s AND Semester=%s;", (year,semester))
    return cursor.fetchall() 


def industry_student_selection(company_id,form):
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
            continue
        else:
            cursor.execute("INSERT INTO company_selections(Industry_host_id,Students_id, responses,additional_note) VALUES (%s, %s, %s, %s); ",(company_id,id[0],response,notes,))

    cursor.execute("UPDATE host_attendance \
                    SET selection_status=1 \
                    WHERE Industry_host_id=%s and year=%s and semester=%s; ",(company_id,year,semester,))
    return None

def selection_form_completion_check(company_id):
    result = False
    cursor = get_cursor()
    
    year, semester = HostCurrentSemester(company_id)
    cursor.execute("SELECT selection_status FROM host_attendance \
                        WHERE Industry_host_id=%s and year=%s and semester=%s; ",(company_id,year,semester,))
    status = cursor.fetchone()
    if status != None:
        if status[0] == 1:
            result = True
    return result 


def Selection_status(student_id):

    cur = get_cursor()
    # todays_date = date.today()
    # year = todays_date.year
    # semester = semeter_selector(todays_date)
    cur.execute("SELECT Students_id  \
                        FROM student_selections  \
                           WHERE Students_id=%s",(student_id,))
    result=cur.fetchall()                       
    if len(result)> 0:
        form_complete = True
    else:
        form_complete = False

    cur = get_cursor()
    cur.execute("SELECT student_id  \
                     FROM students \
                     WHERE student_id=%s \
                        AND attendance=0",(student_id,))
    row=cur.fetchall()
    if len(row) > 0:
        Not_attending = True
    else:
        Not_attending = False
    return form_complete,Not_attending    