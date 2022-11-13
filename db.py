
import mysql.connector
import config

dbconn = None


# Define database cursor
def get_cursor():
    global dbconn
    global connection
    if dbconn == None:
        connection = mysql.connector.connect(user=config.db_user,
                                             password=config.db_password, 
                                             host=config.db_host,
                                             port=config.db_port,
                                             database=config.db_name,
                                             autocommit=True)

        dbconn = connection.cursor()
        # dbconn = connection.cursor(dictionary=True)  [{},{},{},{}] instead of [(),(),(),()]
        return dbconn
    else:
        if connection.is_connected():
            return dbconn
        else:
            connection = None
            dbconn = None
            return get_cursor()
            