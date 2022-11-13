
from flask import Blueprint, render_template, session, request, flash, redirect, url_for
from models.company_model import get_company_by_id, update_company_by_id,industry_student_selection,selection_form_completion_check
from models.services import add_host_attendance, add_project, add_tech_rank, get_project_id, get_tech_id, show_alltech\
,show_companies, add_new_company, show_host_attendance,semester, add_tech_person, show_matched_student, show_project, show_student_background,\
    student_profile_report
from models.student_model import update_student_by_ID
from models.users import get_user_by_id, get_users, User_id_creator
from datetime import datetime

company_module = Blueprint('company_module', __name__)

@company_module.route("/company/home")
def company_home():
    """Takes users of the industrial host or roll to their home 
        page once they have logged or the survey form if they 
        have yet to fill it out."""
    msg = None
    if session['loggedin']:
        user_id = session.get('user_id')
        filled = show_project(user_id)
        if filled:
            return render_template('company/home.html', user_id=user_id,
                                                        msg=msg)
        else:
            return redirect('/company/survey')
    else:
        return redirect('/login')


@company_module.route("/company/survey", methods=["GET", "POST"])
def survey():
    """Controls the loading of the survey form and it is inserts the data 
        returned into the database on submission redirecting them back to 
        the industry host home page."""
    if session['loggedin']:
        user_id = session.get('user_id')
        if request.method == "POST":
            update_company_by_id(request.form, user_id)
            add_tech_person(request.form, user_id)
            if request.form.get('attendance') == "yes":
                add_host_attendance(user_id)
            tech_name = request.form.get('techName')
            tech_id = get_tech_id(tech_name)
            add_project(request.form, user_id,tech_id[0])
            project_id = get_project_id(user_id)
            first = request.form.get('tech1')
            second = request.form.get('tech2')
            third = request.form.get('tech3')
            fourth = request.form.get('tech4')
            fifth = request.form.get('tech5')
            add_tech_rank(project_id[0],first,1)
            add_tech_rank(project_id[0],second,2)
            add_tech_rank(project_id[0],third,3)
            if fourth !="":
                add_tech_rank(project_id[0],fourth,4)
            if fifth !="":
                add_tech_rank(project_id[0],fifth,5)
            add_success_message = f"Thanks for filling out survey!"
            flash(add_success_message, 'success')
            return redirect('/company/home')
        else:
            company = get_company_by_id(user_id)
            teches = show_alltech()
            return render_template("company/survey.html", teches = teches, company = company)
    else:
        return redirect('/login')


@company_module.route("/company/student/background")
def view_student_background():
     """Manages the student background report for the industry host."""
     if session['loggedin']:
        results = show_student_background()
        return render_template('company/student_background.html',results = results)
     else:
        return redirect('/login')




@company_module.route("/company/student/selection_form", methods=["GET", "POST"])
def Company_Student_Selection():
    """Controls the industry hosts student selection form. On form submission 
        updates the database with their selections."""
    company_id = session['user_id']
    Completed_status = selection_form_completion_check(company_id)
    if request.method == "POST":
        form = request.form
        industry_student_selection(company_id,form)
        flash("Student Selection form successfully submitted",category='success')
        return render_template('company/home.html', user_id=company_id)

    students = student_profile_report(company_id)
    return render_template("company/Selection_show_report.html",students=students,
                                                                Completed_status=Completed_status)


@company_module.route("/company/student/matched")
def view_matched_student():
    """Controls the matched student report for the logged in industry host"""
    if session['loggedin']:
        user_id = session.get('user_id')
        students_list = show_matched_student(user_id)
        return render_template('company/matched_student.html', students_list = students_list)
    else:
        return redirect('/login')
