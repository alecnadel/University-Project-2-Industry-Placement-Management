from datetime import datetime
import config
from models.db import get_cursor
from models.student_model import get_student_profile
from models.users import User_id_creator
from flask import Flask, url_for
from flask import session, abort
from flask import render_template
from flask import request
from flask import redirect
from models.users import get_users, get_user_by_id #User_login
from modules.admin_module import admin_module
from modules.company_module import company_module
from modules.student_module import student_module
from datetime import date

# role numbers
STUDENT = 1
COMPANY = 2
ADMIN = 3

app = Flask(__name__)
app.config['SECRET_KEY'] = config.app_secret
app.register_blueprint(student_module)
app.register_blueprint(company_module)
app.register_blueprint(admin_module)
app.config["UPLOAD_FOLDER"]="/static/img"


@app.route("/")
def root():
    return redirect(url_for("login"))
    

# login to different home page depending on roles
@app.route("/login", methods=['GET','POST'])
def login():
    """This function controls the user login for industy placement system"""
    cursor = get_cursor()
    # Output Error message 
    msg1 = ''
    msg2 = ''
    # Check if "username" and "password" POST requests exist (user submitted form)
    if request.method == 'POST' and 'username' in request.form and 'password' in request.form:

        # Create variables for easy access
        username = (request.form['username']).lower()
        password = request.form['password']
        # Check if account exists using MySQL
        # cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM users WHERE user_name = %s;', (username,))
        accounts = cursor.fetchall()

        cursor.execute('SELECT * FROM users WHERE user_name = %s AND password = SHA2(%s, 256);', (username, password,))
        # Fetch one record and return result
        account = cursor.fetchone()
        
        # If account exists in accounts table in out database
        if account:
            # Create session data, we can access this data in other routes
            session['loggedin'] = True
            session['user_id'] = account[0] # user_id
            session['username'] = account[1]  # user_name
            session['role'] = account[3] # role

            # Redirect to home page based on role.
            if session['role'] == ADMIN:
                return redirect("/admin/home")
            if session['role'] == STUDENT:
                id = session.get('user_id')
                student = get_student_profile(id)
                session['student'] = student
                return redirect("/student/home")
            if session['role'] == COMPANY:
                return redirect("/company/home")
        else:
            # Account doesnt exist or username/password incorrect
            if len(accounts) == 0:
                msg1 = 'Incorrect username!'
            else:
                msg2 = 'Incorrect password!'

    # Show the login form with message (if any) 
    return render_template('login.html', msg1=msg1,
                                         msg2=msg2)
   
@app.route('/logout')
def logout():
    # Remove session data, this will log the user out
   session.pop('loggedin', None)
   session.pop('user_id', None)
   session.pop('username', None)
   session.pop('role', None)
   # Redirect to login page
   return redirect(url_for('login'))

@app.route("/student_registration", methods=['GET','POST'])
def student_registration ():
    # controlls the registration of new students.
    if request.method == "POST":
        username = (request.form.get("username")).lower()
        password = request.form.get("password")
        role = 1
        userid = User_id_creator(role) # 1 for new student user_id
        cur = get_cursor()
        cur.execute("INSERT users VALUES (%s,%s,SHA2(%s, 256),%s);",(userid,username,password,role,))
        
        session['loggedin'] = True
        session['user_id'] = userid # user_id
        session['username'] = username # user_name
        session['role'] = role # role
        
        student = get_student_profile(userid)
        session['student'] = student
        return redirect("/student/home")
    else:
        return render_template("student/student_registration.html")

# Initialises the app.
if __name__ == '__main__':
    app.run(debug=True)