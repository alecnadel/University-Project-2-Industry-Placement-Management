
import os
from flask import Flask
from flask import Blueprint, render_template,request,redirect,session,flash
from werkzeug.utils import secure_filename
from werkzeug.datastructures import FileStorage
from models.services import show_alltech
from models.student_model import add_interview, get_student_profile, survey_status, update_student_profile,student_project,student_init_survey,student_elective,stu_tech_rank, add_response,\
 student_interest_report,uploadcv,get_host_id,get_hostid_interview
from models.company_model import show_host_project,get_project_host_attending,show_matching,Selection_status
student_module = Blueprint('student_module', __name__)



@student_module.route("/student/home",methods=["GET"])
def student_home():
    """Control student user home page behaviour after a student login."""
    if session['loggedin']:
        id = session.get("user_id")
        student = session.get('student')
        # to check if student has complete the survey or not, if has completeed, return is not None, if not,the return value is none.
        stu_status = survey_status(id)
        # if return value is not none, which means student has completed the survey already, then direct to home page.
        if  stu_status is not None:
            return render_template("student/home.html",student = student)
        # if return value is None, which means student has not completed the survey, then redirect to the survey form
        else:
            return redirect("/student/survey")
    else:
        return redirect('/login')



@student_module.route("/student/personal/edit",methods=["GET","POST"])
def student_edit():
    """Controls the editing student contact details and profile photo."""
    if session['loggedin']:
        id = session.get("user_id")
        if request.method == "GET":
            student = get_student_profile(id)
            return render_template("student/edit_info.html",student=student)
        else:
            update_student_profile(id)
            flash('Personal Details Updated!', category='success')
            return render_template("student/home.html")
            
    else:
        return redirect('/login')



@student_module.route("/student/survey",methods=["GET","POST"])
def student_survey():
    """Processes this student survey form."""
    if session['loggedin']:
        id = session.get("user_id")
        # if method is post, then pass the survey data to database
        if request.method =="POST":
            # update student table
            student_init_survey(request.form,id)
            # only update user,host, project table for the student who already had a placement,placement status=1
            placement=request.form.get("potential_project")
            if placement == 1:
                student_project(request.form)
            # update student_elective table
            student_elective(request.form,id)
            # update stu_tech_rank table
            stu_tech_rank(request.form,id)
            flash("Your survey has been submitted,thank you!", category="success")
            return render_template("student/home.html")
        # if method is get,show survey form, get all technoligies from database , pass those to the survey form question 12 for the selection options
        else:
            teches = show_alltech()
            return render_template('student/survey.html',teches = teches)   

#Student tick their interested companies after networking.
@student_module.route("/student/company/selection",methods=["GET","POST"])
def student_response():
    """Loads and then processes the student selection form after the speed networking event."""
    if session['loggedin']:

        if request.method == "GET":
            id = session.get('user_id')
            student = session.get('student')
            interest = show_host_project(id)
            form_complete,Not_attending = Selection_status(id)
            return render_template("student/student_selection.html", interest=interest,student=student,
                                                                    form_complete=form_complete,
                                                                    Not_attending=Not_attending)
        else:
            student_id = session['user_id']
            company_ids = get_project_host_attending(student_id) #Get host id who is attending the event.
            form = request.form #Get the form from html.
            
            add_response(student_id,company_ids,form) #calling the variables 
            flash("Student Response added Successfully!", category="success")
            return render_template("student/home.html")


@student_module.route("/student/interview/add",methods=["GET","POST"])
def interview_outcome():
    """Loads and processes the interview form. For students to keep 
        records of their interviews with industry host."""
    if session['loggedin']:
    #If student logged in, get the id and information from that student.
        if request.method == "GET":
            id = session.get('user_id')
            student = session.get('student')
            interview = get_hostid_interview(id)
            
            return render_template("student/interview.html",interview=interview,student=student)
        else:
            Students_id = session['user_id']
            company_ids = get_project_host_attending(Students_id)
            form = request.form

            add_interview(Students_id,company_ids,form)
            flash("Interview form updated Successfully!", category="success")
            return render_template("student/home.html")


@student_module.route("/student/company/view_matching",methods=["GET"])
def view_matching():
    """Loads in the student matching report, after students and industry hosts 
        selections have been processed by the matching algorithm."""
    student = session.get('student')
    Students_id = session['user_id']
    companies = show_matching(Students_id) #Get the correct columns and data to display on the matching table.
    return render_template("student/view_matching.html",companies=companies,student=student)   


@student_module.route("/student/company/view_companies",methods=["GET"])
def view_company():
    """Loads and a list of companies who may be attending the speed networking event."""
    id = session["user_id"]
    student = session.get('student')
    comps = show_host_project(id)
    return render_template("student/view_company.html",comps=comps,student=student)            


@student_module.route("/student/personal/submit_CV",methods=["GET","POST"])
def student_CV():
    """Processes the submission of a student's CV as well as different error 
        messages should they try to submit it incorrectly."""
    if session['loggedin']:
        id = session.get("user_id")
        student = session.get('student')
        if request.method=="GET":
            return render_template("/student/submit_cv.html",student=student)
        else:
            id = session.get("user_id")
            filename=uploadcv(id)
            if filename:
                if filename.rsplit('.', 1)[1].lower()!="pdf":
                    flash("File format is not right,please upload a PDF file",category="error")
                    return render_template("/student/submit_cv.html",student=student) 
                else:
                    flash("Your CV has been submitted Successfully,thank you!", category="success")
                    return redirect("/student/home")
            else:
                flash("You did not upload any file",category="warning")
                return render_template("/student/submit_cv.html",student=student)    