
from flask import Flask, render_template
import mariadb

conn = mariadb.connect(
        user="root",
        password="password",
        host="localhost",
        port=3306,
        database="Students")
cur = conn.cursor()
app = Flask(__name__, template_folder='template')
@app.route("/")
def index():
	return render_template("index.html")
@app.route("/courses")
def courses():
	query = f"""select course_id,level_name,cource_name,max_capacity,rate_per_hour,total_hours 
				from courses
				join levels l on courses.level_id = l.level_id"""
	cur.execute(query)
	LevelCourses = cur.fetchall()
	return render_template("courses.html", courses=LevelCourses)
@app.route("/CourseSchedule")
def CourseSchedule():
	query = f"""select course_schedule_id,cource_name,day,duration,start_time,end_time
				from course_schedules
				join courses on courses.course_id = course_schedules.course_id"""
	cur.execute(query)
	LevelCourseSchedule = cur.fetchall()
	return render_template("CourseSchedule.html", CourseSchedule=LevelCourseSchedule)
@app.route("/student")
def student():
	query = f"""SELECT student_id,student_name,email,mobile_number,address_name,level_name,BOD
				 FROM students
				 join contacts c on students.contact_id = c.contact_id
	             join addresss a on students.address_id = a.address_id
	             join levels l on l.level_id = students.level_id"""
	cur.execute(query)
	LevelStudent = cur.fetchall()
	return render_template("student.html", student=LevelStudent)
@app.route("/<name>")
def welcome(name):
	return render_template("welcome.html", name=name)

if __name__ == "__main__":
	app.run(debug=True)