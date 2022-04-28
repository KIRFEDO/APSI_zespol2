from app import app, db, bcrypt
from flask import render_template, redirect, flash, url_for, request
from flask_login import current_user, login_user, logout_user
from app.forms import LoginForm, RegistrationForm
from app.models import User

# Home
#@app.route('/')
#def home():
#    user = -1
#    if current_user.is_authenticated:
#        user = current_user.get_id()
#    u = User.query.get(user)
#    return render_template('home.html', u=u)


# Employee views ---------------------------------------------------------------

# Taskboard list
@app.route('/taskboard')
def taskboard():
    current_view = 'taskboard'
    user = -1
    if current_user.is_authenticated:
        user = current_user.get_id()
    u = User.query.get(user)

    return render_template('common/taskboard.html', u=u, current_view=current_view)

# Projects list
@app.route('/')
@app.route('/projects')
def projects():
    current_view = 'projects'
    user = -1
    if current_user.is_authenticated:
        user = current_user.get_id()
    u = User.query.get(user)

    if(u.role =='administrator'):
        return render_template('admin/admin-project-list.html', u=u, current_view=current_view)

    if(u.role == 'employee'):
        return render_template('employee/employee-project-list.html', u=u, current_view=current_view)

# Projects add
@app.route('/projects/add')
def projectAdd():
    current_view = 'projects-add'
    user = -1
    if current_user.is_authenticated:
        user = current_user.get_id()
    u = User.query.get(user)

    if(u.role =='administrator'):
        return render_template('admin/admin-project-add.html', u=u, current_view=current_view)

    if(u.role == 'employee'):
        #TODO unauthantized
        return 0

# Single project
@app.route('/projects/p')
def projectsView():
    current_view = 'projects-view'
    user = -1
    if current_user.is_authenticated:
        user = current_user.get_id()
    u = User.query.get(user)

    if(u.role =='administrator'):
        return render_template('admin/admin-project-view.html', u=u, current_view=current_view)

    if(u.role == 'employee'):
        return render_template('employee/employee-project-view.html', u=u, current_view=current_view)

# Add new task
@app.route('/task/add')
def addtask():
    current_view = 'task-add'
    user = -1
    if current_user.is_authenticated:
        user = current_user.get_id()
    u = User.query.get(user)
    return render_template('common/task-add.html', u=u)

# Add new epic
@app.route('/epic/add')
def addEpic():
    current_view = 'epic-add'
    user = -1
    if current_user.is_authenticated:
        user = current_user.get_id()
    u = User.query.get(user)

    if(u.role =='administrator'):
        return render_template('admin/admin-epic-add.html', u=u, current_view=current_view)

    if(u.role == 'employee'):
        #TODO unauthantized
        return 0

# Single project
@app.route('/employees')
def employees():
    current_view = 'employees'
    user = -1
    if current_user.is_authenticated:
        user = current_user.get_id()
    u = User.query.get(user)

    if(u.role =='administrator'):
        return render_template('admin/admin-employee-list.html', u=u, current_view=current_view)

    if(u.role == 'employee'):
        #TODO unauthantized
        return 0

# Login/registration -----------------------------------------------------------
@app.route("/register", methods=['GET', 'POST'])
def register():
    form = RegistrationForm()
    if form.validate_on_submit():
        hashed_password = bcrypt.generate_password_hash(form.password.data).decode('utf-8')
        user = User(login=form.login.data, password=hashed_password, name=form.name.data, surname=form.surname.data,
                    role=form.role.data, active=True)
        db.session.add(user)
        db.session.commit()
        flash('Użytkownik utworzony', 'success')
        return redirect(url_for('login'))
    return render_template('register.html', title='Register', form=form)


@app.route('/login', methods=['GET', 'POST'])
def login():
    if current_user.is_authenticated:
        return redirect(url_for('projects'))
    form = LoginForm()
    error_message = ''
    if form.validate_on_submit():
        user = User.query.filter_by(login=form.login.data).first()
        if user and bcrypt.check_password_hash(user.password, form.password.data):
            login_user(user)
            next_page = request.args.get('next')
            return redirect(next_page) if next_page else redirect(url_for('projects'))
        else:
            error_message = 'Incorrect username or password.'
    return render_template('login.html', title='Login', form = form, error_message = error_message)


@app.route('/logout')
def logout():
    logout_user()
    return redirect(url_for('login'))
