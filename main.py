from datetime import datetime
import mariadb
import sys

def RegisterNewStudent(conn):
    name=input("Enter Name Student : ")
    date=input("Enter Birth Of Date (yyyy-mm-dd): ")
    cur = conn.cursor()
    query = """
            SELECT level_id,level_name
            FROM levels;
            """
    cur.execute(query)
    print("----------------------------------------")
    print("| {:<36} |".format('Select Level'))
    print("+--------------------------------------+")
    print("| {:<10} | {:<10} |".format('Level Id', 'Level Name'))
    print("+--------------------------------------+")
    for level_id, level_name in cur:
        print("| {:<10} | {:<10} |".format(level_id, level_name))
    print("----------------------------------------")

    level=input("Enter ID LEVEL : ")
    query = """
            SELECT address_id,address_name
            FROM addresss;
            """
    cur.execute(query)
    print("----------------------------------------")
    print("| {:<36} |".format('Select ADDRESS'))
    print("+--------------------------------------+")
    print("| {:<10} | {:<10} |".format('Address Id', 'Address Name'))
    print("+--------------------------------------+")
    for address_id,address_name in cur:
        print("| {:<10} | {:<10} |".format(address_id,address_name))
    print("----------------------------------------")
    address= input("Enter ID Address : ")
    email= input("Enter Email : ")
    jawwal= input("Enter Number Mobile : ")
    query = f"INSERT INTO contacts (mobile_number, email) VALUES (%s,%s)"
    val = (email, jawwal)
    cur.execute(query, val)
    idContact = cur.lastrowid
    conn.commit()
    query = f"INSERT INTO students (student_name, address_id, level_id, BOD, contact_id) VALUES (%s,%s,%s,%s,%s)"
    val=(name, address, level, date, idContact)
    cur.execute(query,val)
    print(f"{cur.rowcount} details inserted")
    conn.commit()

def EnrollCourse(conn):
    student=input("Enter Student ID : ")
    course = input("Enter Course ID : ")
    try:
        cur = conn.cursor()
        query = f"Select level_id FROM students WHERE student_id={student}"
        cur.execute(query)
        LevelStudent = cur.fetchall()[0][0]
        query = f"Select level_id FROM courses WHERE course_id={course}"
        cur.execute(query)
        LevelCourse = cur.fetchall()[0][0]
        if (LevelCourse == LevelStudent):
            query = f"Select course_id,student_id FROM enrollment_historys WHERE student_id={student} and course_id={course}"
            cur.execute(query)
            if (cur.rowcount==0):
                query = f"Select max_capacity,rate_per_hour,total_hours FROM courses WHERE course_id={course}"
                cur.execute(query)
                row=cur.fetchall()
                rate=row[0][1]
                total=row[0][2]
                MaxCapacity=row[0][0]
                query = f"Select course_id FROM enrollment_historys WHERE course_id={course}"
                cur.execute(query)
                acount = cur.rowcount
                if(acount < MaxCapacity):
                    p = rate * total
                    date = input("Enter Enrol Date (yyyy-mm-dd):")
                    query = f"INSERT INTO enrollment_historys (course_id, student_id, enrol_date,total) VALUES (%s,%s,%s,%s)"
                    val = (course, student, date, p)
                    cur.execute(query, val)
                    print(f"{cur.rowcount} details inserted")
                    conn.commit()
            else:
                print("** Error Student did Enroll The Course Before **")
        else:
            print("** Error Level Student NO Equal Level Course **")
    except IndexError as e:
            print(e)
            pass

def CreateNewCourse(conn):
    name=input("Enter Course Name : ")
    level = input("Enter Level ID : ")
    capacity=input("Enter Max Capacity : ")
    rate=input("Enter Hour Rate (Price) : ")
    total = input("Enter Total Hours : ")
    cur = conn.cursor()
    query = f"INSERT INTO courses (cource_name,level_id,max_capacity,rate_per_hour,total_hours) VALUES (%s,%s,%s,%s,%s)"
    val = (name,level,capacity,rate,total)
    cur.execute(query, val)
    print(f"{cur.rowcount} details inserted")
    conn.commit()

def CreateNewSchedule(conn):
    day = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"][int(input("Enter Day Name Number [Monday=0 >> Sunday=6]: "))]
    course = input("Enter Course ID : ")
    StartTime = datetime.strptime(input("Enter Start Time format (HH:MM:SS) : "), "%H:%M:%S")
    duration  = datetime.strptime(input("Enter Max Duration Format (HH:MM:SS) : "), "%H:%M:%S")
    time_zero = datetime.strptime('00:00:00', '%H:%M:%S')
    EndTime=(StartTime - time_zero + duration).time()
    print("End Time : ", EndTime)
    cur = conn.cursor()
    query = f"SELECT course_schedule_id FROM course_schedules WHERE day='{day}' AND course_id={course}"   # Course once a day
    cur.execute(query)
    acount = cur.rowcount
    if acount==0:
        query = f"SELECT level_id FROM courses WHERE course_id={course}"  # The level of the course does not conflict with time
        cur.execute(query)
        level = cur.fetchall()[0][0]  # The Number Level
        print(StartTime.time())
        query = f"""SELECT * 
                  FROM course_schedules 
                  JOIN courses ON course_schedules.course_id = courses.course_id  
                  WHERE day='{day}' AND courses.level_id={level} AND '{StartTime.time()}' 
                  NOT BETWEEN start_time AND end_time"""
        cur.execute(query)
        acount = cur.rowcount
        print(acount)
        if(acount==0):
            query = f"INSERT INTO course_schedules (day,course_id,start_time,duration,end_time) VALUES (%s,%s,%s,%s,%s)"
            val = (day, course, StartTime.time(), duration.time(), EndTime)
            cur.execute(query, val)
            conn.commit()
        else:
            print("*** There is a time conflict on the same level ***")
    else:
        print("*** you have another course in the day ***")

try:
    conn = mariadb.connect(
        user="root",
        password="password",
        host="localhost",
        port=3306,
        database="Students")

    while True:
        user_input = input(
            """\tSelect
                [ 1 ] Register New Student
                [ 2 ] Enroll Course
                [ 3 ] Create New Course
                [ 4 ] Create New Schedule
                Option ?: """)
        if user_input == '1':
            RegisterNewStudent(conn)
        elif user_input == '2':
            EnrollCourse(conn)
        elif user_input == '3':
            CreateNewCourse(conn)
        elif user_input == '4':
            CreateNewSchedule(conn)
except Exception as e:
    print(f"Error connecting to MariaDB Platform: {e}")
    sys.exit(1)
