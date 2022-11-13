from datetime import datetime
from models.db import get_cursor
from datetime import date
from flask import render_template,request, session,redirect,url_for

def get_users():
    cursor = get_cursor()
    cursor.execute('''SELECT users_id, user_name FROM users;''')
    return cursor.fetchall()


# get user by user id
def get_user_by_id(user_id):
    cursor = get_cursor()
    cursor.execute('''SELECT * FROM users WHERE users_id=%s;''', (user_id,))
    users = cursor.fetchall()
    return users[0] if len(users) else None

def User_id_creator(role_id):
    """this function creates a new user id for Users table
    (role id is 1,2,3 for student, company and admin)"""
    cursor = get_cursor()
    cursor.execute('''SELECT Users_id FROM users;''')
    results = cursor.fetchall()
    user_count = str(cursor.rowcount+1)
    user_id = int(str(role_id) + user_count)
    return user_id



