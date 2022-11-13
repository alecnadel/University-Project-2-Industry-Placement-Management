from tokenize import Name
from unicodedata import name

from flask import request
from models.db import get_cursor
from models.users import User_id_creator
# from models.student_model import student_profile_report
from datetime import datetime
import uuid
import os
from os.path import isfile
from datetime import date
from flask import render_template

STUDENT = 1
COMPANY = 2
ADMIN = 3

def AdminCurrentSemester():
    """function returns the current year and semester the admin is 
        currently matching from database."""
    cur = get_cursor()
    cur.execute("SELECT * FROM adminsemester ORDER BY Year DESC, Semester DESC LIMIT 1")
    data = cur.fetchone()
    Year = data[0]
    Semester = data[1]
    return Year, Semester

def HostCurrentSemester(hostid):
    """function returns the current year and semester for Hostid for the lastest semester
    which they have attanded the networking event or placed a student"""

    cur = get_cursor()
    cur.execute("SELECT Year, Semester \
                    FROM host_attendance \
                    WHERE Industry_host_id=%s \
                    ORDER BY Year DESC, Semester DESC LIMIT 1",(hostid,))
    data = cur.fetchone()
    Year = data[0]
    Semester = data[1]
    return Year, Semester


def student_profile_report(hostid):
    cur = get_cursor()
    
    Year, Semester = HostCurrentSemester(hostid)
    cur.execute("""SELECT student_id,Photo,first_name, last_name
                    FROM students 
                        WHERE attendance=1 and year=%s and semester=%s
                            ORDER BY last_name,first_name;""",(Year,Semester))
    return cur.fetchall()


def show_companies():
    cur = get_cursor()
    Year, Semester = AdminCurrentSemester()
    cur.execute(""" SELECT I.Industry_host_id, I.organization_name, I.contact_name, 
	   I.contact_phone, I.contact_email,
       (CASE
		WHEN I.Industry_host_id in (SELECT Industry_host_id FROM host_attendance
											WHERE Year=%s AND Semester=%s)
		THEN 1
		ELSE 0
		END) as Attendance
		FROM industry_host I;""",(Year, Semester,))
    return cur.fetchall()



def CurrentlyAttendingHost():
    cur = get_cursor()
    Year,Semester = AdminCurrentSemester()
    cur.execute(""" SELECT I.Industry_host_id, I.organization_name, I.contact_name, 
                           I.contact_phone, I.contact_email
                    FROM industry_host I
                        JOIN host_attendance H
                            ON I.Industry_host_id = H.Industry_host_id
                    WHERE Year=%s AND Semester=%s;""",(Year,Semester,))
    return cur.fetchall()



def add_attend_record(hostId):
    """the function add the host attending speed networking record to host_attendance table"""
    Year,Semester = AdminCurrentSemester() 
    cur = get_cursor()
    cur.execute("SELECT * FROM host_attendance \
                    WHERE Industry_host_id=%s AND Year=%s AND Semester=%s;",(hostId,Year,Semester,))
    cur.fetchall()
    if cur.rowcount == 0:
        cur.execute("Insert host_attendance (Industry_host_id,Year,Semester) VALUES (%s,%s,%s)",
                                                                        (hostId,Year,Semester,))
    return None

def add_new_company(form):
    cur = get_cursor()
    userid = User_id_creator(2) # 2 for new company user_id
          #uuid.uuid4().fields[0]
    password = "password1" # sets default to password1
    company = form.get('companyName').upper() 
    c_name = form.get('contactName')
    number = form.get('contactNumber')
    email = form.get('contactEmail')
    attending = form.get('attending')
    cur.execute("""INSERT INTO users VALUES (%s, %s, SHA2(%s,256), %s);""",
                       (userid, company.lower(), password, COMPANY, ))
    cur.execute("""INSERT INTO industry_host (Industry_host_id, organization_name, contact_name, contact_phone, contact_email) 
                     VALUES (%s, %s, %s, %s, %s);""",
                       (userid, company, c_name, number, email))

    if attending != None:
        add_attend_record(userid)


def semester():
    month = datetime.now().month
    if 1<= month <=6:
        return "1"
    else:
        return "2"


def show_host_attendance(host_id):
    cur = get_cursor()
    year = datetime.now().year
    current_semester = semester()
    cur.execute(""" SELECT * FROM host_attendance WHERE Industry_host_id=%s AND Year=%s AND Semester=%s;""",(host_id, year, current_semester,))
    return cur.fetchone()


def show_project(host_id):
    cur = get_cursor()
    # year = datetime.now().year
    # current_semester = semester()
    year, current_semester = HostProjectSemester(host_id)
    cur.execute("""SELECT * FROM projects WHERE Industry_host_id=%s AND year=%s AND semester=%s;""",(host_id, year, current_semester,))
    return cur.fetchone()


def add_tech_person(form, host_id):
    cur = get_cursor()
    tech_name = form.get('techName')
    tech_number = form.get('techNumber')
    tech_email = form.get('techEmail')
    cur.execute("""INSERT INTO tech_person (Industry_host_id, tech_name, tech_phone, tech_email) 
                     VALUES (%s, %s, %s, %s);""",
                       (host_id, tech_name, tech_number, tech_email))


def get_tech_id(tech_name):
    cur = get_cursor()
    cur.execute(""" SELECT Tech_id FROM tech_person WHERE tech_name=%s;""",(tech_name,))
    return cur.fetchone()




def add_host_attendance(host_id):
    cur = get_cursor()
    year = datetime.now().year
    current_semester = semester()
    cur.execute("""INSERT INTO host_attendance(Industry_host_id,Year,Semester) 
                     VALUES (%s, %s, %s);""",
                       (host_id, year, current_semester))


def add_project(form,host_id,tech_id):
    cur = get_cursor()
    project_desc = form.get('projectDesc')
    placement = form.get('placement')
    # year = datetime.now().year
    # current_semester = semester()
    year, current_semester = PrjectForNextSemester()
    cur.execute("""INSERT INTO projects (Industry_host_id, Tech_id, project_description, potential_placements, year, semester) 
                     VALUES (%s, %s, %s, %s, %s, %s);""",
                       (host_id, tech_id, project_desc, placement, year, current_semester))
    

def get_project_id(user_id):
    cur = get_cursor()
    # year = datetime.now().year
    # current_semester = semester()
    year, current_semester = PrjectForNextSemester()
    cur.execute(""" SELECT Projects_id FROM projects WHERE Industry_host_id=%s AND year=%s AND semester=%s;""",(user_id, year, current_semester,))
    return cur.fetchone()


def add_tech_rank(project_id, skill_id, rank):
    cur = get_cursor()
    cur.execute("""INSERT INTO project_tech_rank VALUES (%s, %s, %s);""",(project_id, skill_id, rank,))


def show_student_background():
    cur = get_cursor()
    cur.execute("""SELECT first_name, last_name, Student_background
                FROM students;""")
    return cur.fetchall()


def show_matched_student(user_id):
    cur = get_cursor()
    cur.execute("""SELECT first_name, last_name, phone_number, email, placement_status, cv
                FROM students 
                JOIN company_selections
                ON company_selections.Students_id = students.student_id
                WHERE company_selections.Industry_host_id = %s and company_selections.match_confirmation = 1;""",(user_id,))
    return cur.fetchall()


def show_students():
    cur = get_cursor()
    year,semester = AdminCurrentSemester()
    cur.execute(""" SELECT * FROM students WHERE year=%s AND semester=%s;
                """,(year,semester,))
    return cur.fetchall()


def show_host_project_report():
    cur = get_cursor()
    year, semester = PrjectForNextSemester()
    cur.execute("""SELECT i.organization_name, p.project_description, p.Projects_id
                    FROM projects p
                        JOIN industry_host i 
                            ON p.Industry_host_id = i.Industry_host_id
                    WHERE p.year=%s AND p.semester=%s;""",(year, semester,))
    return cur.fetchall()



def show_alltech():
    cur = get_cursor()
    cur.execute("SELECT * FROM technology; ")
    return cur.fetchall()


# def Selection_report_to_pdf():
#     cur = get_cursor()
#     todays_date = date.today()
#     todays_date.month
#     todays_date.day
#     Year = todays_date.year
#     if todays_date.month <= 6 and todays_date.day <=25:
#         Semester = 1
#     else:
#         Semester = 2

#     pdf_name = "pdf/Selection_report_{}_{}.pdf".format(Year,Semester)
  
    

#     if isfile(pdf_name):
#         return pdf_name
#     else:
        
#         students = student_profile_report()
#         file = render_template('admin/pdf_reports/Selection_report.html',students=students)
#         static_path = "/static/"
#         file_path = "pdfs/out.pdf"
       
#         return file_path



# def semester_selector(date):
   
#     if date.month <= 6:
#         semeter = 1
#     else:
#         semeter = 2
#     return semeter



def get_all_available_industry_hosts():
    cur = get_cursor()
    # year = datetime.now().year
    # current_semester = semester()
    year, current_semester = PrjectForNextSemester()
    cur.execute("SELECT I.Industry_host_id, I.organization_name , SUM(CASE WHEN C.match_confirmation=1 THEN 1 ELSE 0 END) as `count`, \
                        I.contact_name, I.contact_phone, I.contact_email, P.project_description \
                FROM industry_host I \
                    INNER JOIN projects P \
                        ON I.Industry_host_id = P.Industry_host_id \
                    INNER JOIN company_selections C \
                        ON I.Industry_host_id = C.Industry_host_id \
                WHERE P.year=%s AND P.semester=%s \
                GROUP BY C.Industry_host_id \
                ORDER BY `count` ASC;",(year,current_semester,))
    industry_host = cur.fetchall()

    return industry_host

def update_student_matches(form):
    cur = get_cursor()
    student_id = form.get("student_id")
    form.getlist("add_match_industry")
    for industry_id in form.getlist("add_match_industry"):
        cur.execute("UPDATE company_selections \
                            SET match_confirmation=1 \
                                WHERE Students_id=%s AND Industry_host_id=%s",(student_id,industry_id,))
        
        if cur.rowcount == 0:
            cur.execute("INSERT company_selections VALUE (%s,%s,%s,%s,%s)",(industry_id,student_id,1,"NULL",1,))
    for industry_id in form.getlist("remove_match_industry"):
        cur.execute("UPDATE company_selections \
                            SET match_confirmation=0 \
                                WHERE Students_id=%s AND Industry_host_id=%s",(student_id,industry_id,))

    return None


def users_yet_to_select():
    cur = get_cursor()
    year = datetime.now().year
    current_semester = semester()

    cur.execute("SELECT I.Industry_host_id, I.organization_name,  \
                        I.contact_name, I.contact_phone, I.contact_email \
                FROM industry_host I \
                    INNER JOIN host_attendance A \
                        ON I.Industry_host_id = A.Industry_host_id \
                WHERE A.Year=%s AND A.Semester=%s \
                    AND (NOT I.Industry_host_id IN  \
                    (SELECT DISTINCT Industry_host_id FROM company_selections));",(year,current_semester,))
    industry_hosts = cur.fetchall()
    cur.execute("SELECT first_name, last_name, phone_number, email FROM students S \
                    WHERE S.year=%s AND S.semester=%s AND attendance=1 AND \
                    (NOT S.student_id IN (SELECT DISTINCT Students_id FROM student_selections));",(year,current_semester,))
    
    students = cur.fetchall()
    return industry_hosts, students




def PrjectForNextSemester():
    """function returns the year and semester for the next semester from the admins 
        current semester from 'AdminCurrentSemester()'."""
    Year, Semester = AdminCurrentSemester()

    if Semester == 1:
        Semester+=1
        return Year, Semester
    else:
        Year+=1
        Semester-=1
        return Year, Semester

def StudentSemester(student_id):
    """function returns the years and semester from student table"""
    cur = get_cursor()
    cur.execute("SELECT year,semester FROM students WHERE student_id=%s",(student_id,))
    data = cur.fetchone()
    Year = data[0]
    Semester = data[1]
    return Year, Semester

def StudentProjectSemester(student_id):
    """function returns the years and semester for which the student will be
        attending the project for industry project course"""
    Year, Semester = StudentSemester(student_id)        

    if Semester == 1:
        Semester+=1
        return Year, Semester
    else:
        Year+=1
        Semester-=1
        return Year, Semester



def HostProjectSemester(hostid):
    """function returns the next year and semester for Hostid for the lastest semester
        which they have attanded the networking event or placed a student 
        for a project next semester project"""
    Year, Semester = HostCurrentSemester(hostid)

    if Semester == 1:
        Semester+=1
        return Year, Semester
    else:
        Year+=1
        Semester-=1
        return Year, Semester

def Matching_algorithm_reset():
    """function resets the matching report so that the Matching
        report can be regenerated."""
    # Get the year and semester of current matching report.
    Year, Semester = AdminCurrentSemester()
    # company_selections, match_confirmation
    cur = get_cursor()
    cur.execute("UPDATE company_selections C \
                    SET match_confirmation=0 \
                    WHERE match_confirmation= 1 \
                        AND (C.Industry_host_id IN (SELECT Industry_host_id \
                                                        FROM host_attendance \
                                                        WHERE Year=%s AND Semester=%s));",
                                                        (Year, Semester,))
    return None
    