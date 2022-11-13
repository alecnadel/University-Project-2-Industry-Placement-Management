from os import urandom
from pickle import GET
from sre_constants import SUCCESS
from flask import Blueprint, render_template, session, request, flash, redirect, url_for
from werkzeug.utils import secure_filename
from models.company_model import get_company_by_id, update_company_by_id,selection_form_completion_check,\
                                industry_student_selection, Selection_status,\
                                get_project_host_attending
from models.services import AdminCurrentSemester, show_companies, add_new_company, show_students, student_profile_report,Matching_algorithm_reset
from models.student_model import show_students_by_id, update_student_by_ID,attending_students,\
                                 IndustryHost_select_Insert,show_response, add_response,IndustryHost_select_form,stu_bg,placement_report
from models.services import add_new_company, show_students, show_host_project_report, \
                            get_all_available_industry_hosts, update_student_matches, users_yet_to_select, \
                            PrjectForNextSemester,CurrentlyAttendingHost
from models.users import get_user_by_id, get_users, User_id_creator
from models.Selection_algorithm import Matching_algorithm,industry_host_selection,industry_host_selected,student_host_selected
from models.admin_model import industry_student_selection_update,admin_student_profile_report,admin_add_response, \
                                admin_show_host_project,CreateNewSemester,Currenthostprojects,HostProjectUpdates, \
                                CurrentHostTechPersons, EditProjectDescription, ReadExcelHostSurvey, AttendingManualUpdate, \
                                MatchingTable     

admin_module = Blueprint('admin_module', __name__)





# admin home page
@admin_module.route("/admin/home")
def admin_home():
    if session['loggedin']:
        user = session.get('user_id')
        return render_template('admin/home.html', user=user)
    else:
        return redirect('/login')



@admin_module.route("/admin/company", methods=["GET", "POST"])
def get_companies():  
    """Loads the list of all companies (industry hosts) currently in the database."""
    if session['loggedin']:
        if request.method =="POST":
            return render_template("admin/company.html")
        company_list = show_companies()
        return render_template("admin/company.html", company_list = company_list)
    else:
        return redirect('/login')

@admin_module.route("/admin/SemesterHosts", methods=["GET", "POST"])
def SemesterHosts():  
    """Loads the list of all companies (industry hosts) currently attending network event this semseter."""
    if session['loggedin']:
        
        company_list = CurrentlyAttendingHost()
        return render_template("admin/company.html", company_list = company_list,
                                                     attending=True)
    else:
        return redirect('/login')



@admin_module.route("/admin/company/add", methods=["GET", "POST"])
def add_company():
    """Loads and processes the add a new company (industry host) form."""
    if session['loggedin']:
        if request.method == "POST":
            entered_name = request.form.get('companyName')
            entered_phone = request.form.get('contactNumber')
            entered_email = request.form.get('contactEmail')
            entered_contact = request.form.get('contactName')
            attending = request.form.get('attending')
            print("attending",)
            companies = show_companies()
            users = get_users()
            for company in companies:
                if entered_phone == str(company[3]):
                    error_message = f"This contact number already exists, Please enter a different contact number!"
                    flash(error_message, 'error') 
                    return render_template("/admin/add_company.html",entered_name=entered_name,entered_contact=entered_contact,entered_email=entered_email,entered_phone=entered_phone,attending=attending)
                if entered_email == str(company[4]): 
                    error_message = f"This contact email already exists, Please enter a different contact email!"
                    flash(error_message, 'error') 
                    return render_template("/admin/add_company.html",entered_name=entered_name,entered_contact=entered_contact,entered_email=entered_email,entered_phone=entered_phone,attending=attending)
            for user in users:
                if entered_name.lower() == str(user[1]).lower():
                    error_message = f"Company name cannot be the same as existing user name!"
                    flash(error_message, 'error')
                    return render_template("/admin/add_company.html",entered_name=entered_name,entered_contact=entered_contact,entered_email=entered_email,entered_phone=entered_phone,attending=attending)
            add_new_company(request.form)
            
            add_success_message = f"The new company has been successfully added!"
            flash(add_success_message, 'success')
            if attending != None:
                return redirect(url_for('admin_module.SemesterHosts'))
            else:
                return redirect(url_for('admin_module.get_companies'))
        else:
            return render_template("admin/add_company.html")
    else:
        return redirect('/login')

@admin_module.route("/admin/student") 
def get_student(): 
    """Loads a list of all students currently in the students table of the database."""
    if session['loggedin']:
        
        student_list = show_students()
        return render_template("admin/student.html", student_list = student_list)
    else:
        return redirect('/login')

@admin_module.route("/admin/student/<int:id>/update",methods=["GET","POST"])
def update_student(id):
    """Loads and processes the student details update form. Allowing administrators 
        to update any student details if required"""
    if request.method == "GET":
        view_only = request.args.get("view")
        student = show_students_by_id(id)
        return render_template("admin/update_student.html", student = student,
                                                            id=id, 
                                                            view_only = view_only )    
    else:
        update_student_by_ID(request.form,id)
        flash('Information Successfully Updated!', category='success')
        return redirect(url_for("admin_module.get_student"))

@admin_module.route("/admin/report/Host_project_report")
def get_host_project_report(): #admin_module.get_host_project_report
    """Loads a list of industrial hosts with their project information 
        who may be attending the speed networking event."""
    
    if session['loggedin']:
        student_profile_list = show_host_project_report()
        return render_template("admin/industry_host_report.html", student_profile_list = student_profile_list)
    else:
        return redirect('/login')

@admin_module.route("/admin/report/Edit_project_report", methods=["GET","POST"])
def Edit_project_report(): 
    """this function loads in & process the tableForm for editing the
    projection descriptions."""

    if request.method == "POST":
        form = request.form
        EditProjectDescription(form)
        flash("Project Descriptions Successfully Updated", category='success')
        return redirect(url_for("admin_module.get_host_project_report"))
    

    student_profile_list = show_host_project_report()
    return render_template("admin/Edit_Project_Description.html",student_profile_list=student_profile_list)

# @admin_module.route("/admin/report/student_profile",methods=["GET","POST"])
# def update_response(id):
#     if request.method == "GET":
#         update_profile = show_response(id)
#         return render_template("admin/student_profile.html", update_profile = update_profile,id=id )
#     else:
#         add_response(request.form,id)
#         flash('Student Response Successfully Updated!', category='success')
#         return redirect(url_for("admin_module.get_student_profile_report"))






@admin_module.route("/admin/company/<int:id>/update",methods=["GET","POST"])
def update_company(id):
    """Loads and processes the update company form for the administrator 
        to modify industry host information."""
    if request.method == "GET":
       host = get_company_by_id(id)
       return render_template("admin/update_company.html",host = host)    
    else:
        update_company_by_id(request.form,id)
        flash('Company Details Updated!', category='success')
        return redirect (url_for("admin_module.get_companies"))








# admin student attendance report page
@admin_module.route("/admin/report/attendance")
def student_attendance():
    """Loads a list of students who will be attending the speed networking event."""
    students = attending_students()
    return render_template("/admin/student_attendance.html", students = students)
                                                                

@admin_module.route("/admin/report/selection", methods=["POST","GET"])
def student_selecton_IndustryHost(): 
    """Loads the student selection report for industry hosts.
        List of students that are attending the current speed networking event."""
    company_id = request.args.get("Industry_host_id")
    if request.method == "POST":
        for row in request.form:
            IndustryHost_select_Insert(row,request.form)
        return redirect("admin_module.admin_home")

    students = IndustryHost_select_form(company_id)

    return render_template("/admin/Selection_show_report.html", students=students,
                                                                company_id=company_id)


@admin_module.route("/admin/report/student_background",methods=["GET"])
def student_background():
    """Loads in a report of student backgrounds."""
    stu_bgs = stu_bg()
    return render_template("/admin/student_background.html",stu_bgs=stu_bgs)




@admin_module.route("/admin/report/match", methods=["GET","POST"])
def host_match_report(): 
    """Loads and controls the creation of the matching report after the speed networking event
        For the industry host."""
    if request.method == "POST":
        
        matches = Matching_algorithm()
        matches,missing_student,missing_company = industry_host_selection(matches)
    
        return render_template("admin/match_report.html",matches=matches,
                                                        missing_student=missing_student,
                                                        missing_company=missing_company)
    else:
        matches,missing_student,missing_company = industry_host_selected()
        industry_hosts2, students = users_yet_to_select() # companies & students not selected there chocies
        return render_template("admin/match_report.html",matches=matches,
                                                         missing_student=missing_student,
                                                         missing_company=missing_company,
                                                         industry_hosts2=industry_hosts2,
                                                         students=students)


@admin_module.route("/admin/report/Resetmatch", methods=["POST"])
def Reset_Match_Report(): # admin_module.Reset_Match_Report
    """function process the resetting of the matching report if the admin 
        presses the 'Reset Matching Report' after the matching report has
        been generated"""
    Matching_algorithm_reset()
    return redirect(url_for("admin_module.host_match_report"))
    



#matching report for student
@admin_module.route("/admin/report/student_match", methods=["GET"])
def student_match_report():
    """Loads in the student matching report after the speed networking event 
        and matching process has been completed."""
    matches = student_host_selected()
    return render_template("admin/match_student_report.html",matches=matches)



@admin_module.route("/admin/report/placement",methods=["GET"])
def student_placement():
    """Loads in the placement report for students who have found a project with 
        industrial host."""
    placement = placement_report()
    return render_template("admin/placement_report.html",placement = placement)    


@admin_module.route("/admin/student/update",methods=["GET","POST"])
def student_matching_edit(): #admin_module.student_matching_edit
    """Loads and processes manual student placement selection form 
        (Allows administrators to offer more potential placements to students)."""
    if request.method == "POST":
        update_student_matches(request.form)
        flash("Student Matches updated", category="success")
        return redirect(url_for("admin_module.get_student"))
    else:
        student_id = request.args.get("student_id")
        industry_hosts = get_all_available_industry_hosts()
        
    
        return render_template("admin/Manual_Matching.html",industry_hosts = industry_hosts,
                                                                      student_id=student_id)


@admin_module.route("/admin/host/student/selection_form", methods=["GET", "POST"])
def Admin_Host_Student_Selection(): 
    """Controls the industry hosts student selection form. On form submission 
        updates the database with their selections."""
    host_id = request.args.get("Host_id")
    # Completed_status = selection_form_completion_check(host_id)
    if request.method == "POST":
        form = request.form
        industry_student_selection_update(host_id,form)
        flash("Student Selection form successfully submitted",category='success')
        return render_template(url_for('admin_module.get_companies'), user_id=session['user_id'])

    students = admin_student_profile_report(host_id)
    return render_template("admin/SelctionFormTable.html",students=students,
                                                                host_id=host_id)

@admin_module.route("/admin/student/host/selection",methods=["GET","POST"])
def Admin_Student_Host_Selection(): 
    """Loads and then processes the student selection form after the speed networking event."""

    student_id = request.args.get("Student_id")
    if session['loggedin']:

        if request.method == "GET":
            id = session.get('user_id')
            student = session.get('student')
            interest = admin_show_host_project(student_id)
            form_complete,Not_attending = Selection_status(student_id)
            return render_template("admin/StudentSelectionForm.html", interest=interest,student=student,
                                                                    form_complete=form_complete,
                                                                    Not_attending=Not_attending)
        else:
            company_ids = get_project_host_attending(student_id) #Get host id who is attending the event.
            form = request.form #Get the form from html.
            
            admin_add_response(student_id,company_ids,form) #calling the variables 
            flash("Student Response added Successfully!", category="success")
            return render_template(url_for("admin_module.get_student"))


@admin_module.route("/admin/Semester",methods=["POST","GET"])
def SemesterSelection():
    """function controls the Semester selection functionality for the app"""
    Year,Semester = AdminCurrentSemester()
    if  request.method == "POST":
        session["SelectionPeriod"] = (request.form.get("Year"),request.form.get("Semester"))
        flash("Previous Semester Selection Period Successfully Selected!", category="success")
        return redirect(url_for("admin_module.admin_home"))

    return render_template("admin/SemesterSelection.html", Year=Year,
                                                           Semester=Semester)

@admin_module.route("/admin/NewSemester",methods=["POST"])
def NewSemester():
    """function completes the current Year & semester and 
        starts the next semester selection period."""
    
    CreateNewSemester()
    flash("Next Semester Selection Period Successfully Initiated!", category="success")
    return redirect(url_for("admin_module.admin_home"))



@admin_module.route("/admin/host/projects",methods=["POST","GET"])
def AdminProjectManger(): 
    """process and updates the changes made to host projects"""
    HostId = request.args.get("Host_id")
    if request.method == "POST":
        form = request.form
        HostId = HostProjectUpdates(HostId,form)
        flash("Next Industry Host projects Successfully Updated", category="success")
        return redirect(url_for("admin_module.get_companies"))

    year,semester =PrjectForNextSemester()

    projects,contactPerson,HostName,HostId = Currenthostprojects(HostId)
    TechPersons,HostId = CurrentHostTechPersons(HostId)
    return render_template("admin/projectCreator.html",projects=projects,
                                                       contactPerson=contactPerson,
                                                       year=year,
                                                       semester=semester,
                                                       TechPersons=TechPersons,
                                                       Host=HostName,
                                                       HostId=HostId)

@admin_module.route("/admin/host/LoadExcelHostData",methods=["POST","GET"])
def LoadExcelHostData(): # admin_module.LoadExcelHostData
    """Loads and then save Host Survey form excel spreadsheet then process and loadin the updated 
        data provided"""
    
    if session['loggedin']:
        id = session.get("user_id")
        # student = session.get('student')
        if request.method=="GET":
            return render_template("admin/ExcelHostSurvey.html")
        else:
            # id = session.get("user_id")
            filename = secure_filename(request.files['HostResponces'].filename)
            if filename:
                if not filename.rsplit('.', 1)[1].lower() in ["xlsx","xls"]:
                    flash("File format is not right,please upload a PDF file",category="error")
                    return render_template("admin/ExcelHostSurvey.html") 
                else:
                    ReadExcelHostSurvey()
                    flash("Indistry host survey excel data imported Successfully!", category="success")
                    return redirect(url_for("admin_module.admin_home"))
            else:
                flash("You did not upload any file",category="warning")
                return render_template("admin/ExcelHostSurvey.html")



@admin_module.route("/admin/company/AddSemesterHost", methods=["GET"])
def AddHostToCurrentSemester(): # admin_module.AddHostToCurrentSemester
    """Loads and processes the add a new company (industry host) form."""
    if session['loggedin']:
        return render_template("admin/add_company.html",attending=True)
    else:
        return redirect('/login')

@admin_module.route("/admin/company/SemesterHostAttendance", methods=["GET"])
def ManualAttendanceEdit():
    Host = request.args.get("Host_id")
    attendingTable = request.args.get("attend")
    AttendingManualUpdate(Host)
    if attendingTable:
        return redirect(url_for("admin_module.SemesterHosts"))
    else:
        return redirect(url_for("admin_module.get_companies"))
        # admin_module.SemesterHosts, admin_module.get_companies

@admin_module.route("/admin/company/MatchTable", methods=["GET"])
def MatchTable(): #admin_module.MatchTable
    """this function control the loading of the matching table to show the current state 
        of the process for the current semester."""
    MatchingResults = MatchingTable()
    hostID = MatchingResults[0][0]
    hosts = []
    host = []
    for rows in MatchingResults:
        if hostID != rows[0]:
            hosts.append(host)
            hostID= rows[0]
            host = []
        host.append(rows)
        

    return render_template("/admin/MatchingTable.html",hosts=hosts)