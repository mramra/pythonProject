from flask import Flask, jsonify
import mariadb
from functools import wraps
from flask import request, abort

conn = mariadb.connect(
        user="root",
        password="password",
        host="localhost",
        port=3306,
        database="Students")
cur = conn.cursor()
# The actual decorator function
app = Flask(__name__)
def require_appkey(view_function):
    @wraps(view_function)
    # the new, post-decoration function. Note *args and **kwargs here.
    def decorated_function(*args, **kwargs):
        key='eiWee8ep9due4deeshoa8Peichai8Eih'
        #if request.args.get('key') and request.args.get('key') == key:
        if request.headers.get('x-api-key') == key:
            return view_function(*args, **kwargs)
        else:
            abort(401)
    return decorated_function

@app.route('/json/', methods=['POST'])
@require_appkey
def put_user():
    try:
        id = request.form.get('id')
        if id:
            cur.execute(f"""SELECT student_id,student_name,email,mobile_number,address_name,level_name,BOD
    			 FROM students
    			 join contacts c on students.contact_id = c.contact_id
                 join addresss a on students.address_id = a.address_id
                 join levels l on l.level_id = students.level_id where student_id={id}""")
            row = cur.fetchall()
            resp = jsonify(row)
            resp.status_code = 200
            return resp
        else:
            resp = 'User "id" not found in query string'
            resp.status_code = 500
            return resp
    except Exception as e:
        print(e)
    finally:
        conn.commit()
    #return 'Posted JSON!'

app.run(debug =True)