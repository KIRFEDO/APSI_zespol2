from app import app, db, bcrypt
from flask import render_template, redirect, flash, url_for, request, abort
from flask_login import current_user, login_user, logout_user, login_required
from app.forms import LoginForm, RegistrationForm, ProjectForm, TaskForm
from app.models import User, Project, Task


# Temp variable for skipping login process
login_override = True
def check_user():
    if login_override:
        return User.query.filter(User.role == 'kierownik').first()
    user = -1
    if current_user.is_authenticated:
        user = current_user.get_id()
    return User.query.get(user)


# Taskboard list
@app.route('/taskboard')
#@login_required    # TODO: Uncomment in final
def taskboard():
    current_view = 'taskboard'
    u = check_user()

    return render_template('common/taskboard.html', u=u, current_view=current_view)


# Projects list
@app.route('/projects')
#@login_required    # TODO: Uncomment in final
def projects():
    current_view = 'projects'
    u = check_user()

    if login_override or (u.role == 'kierownik'):
        projectlist = Project.query.filter(Project.supervisor == u.id)
        if(login_override):
            projectlist = Project.query.all()
        return render_template('admin/admin-project-list.html', projects=projectlist, u=u, current_view=current_view)
    else:
        return render_template('employee/employee-project-list.html', u=u, current_view=current_view)


# Projects add
@app.route('/projects/add', methods=['GET', 'POST'])
#@login_required    # TODO: Uncomment in final
def project_add():
    form = ProjectForm()
    current_view = 'projects-add'
    u = check_user()

    if login_override or (u.role == 'kierownik'):
        if form.validate_on_submit():
            c = form.client.data
            if c == "":
                c = None
            user = current_user.get_id()
            project = Project(name=form.name.data, description=form.description.data, supervisor=user,
                              client=c)
            db.session.add(project)
            db.session.commit()
            flash('Projekt utworzony', 'success')
            return redirect(url_for('projects'))
        return render_template('admin/admin-project-add.html', u=u, current_view=current_view, form=form)
    else:
        abort(403)


# Single project
@app.route('/projects/<int:project_id>')
#@login_required    # TODO: Uncomment in final
def projects_view(project_id):
    project = Project.query.get_or_404(project_id)
    current_view = 'projects-view'
    u = check_user()

    if login_override or (u.role == 'kierownik'):
        return render_template('admin/admin-project-view.html', u=u, project=project, current_view=current_view)

    else:
        return render_template('employee/employee-project-view.html', u=u, project=project, current_view=current_view)


# Add new task
@app.route('/projects/<int:project_id>/task/add', methods=['GET', 'POST'])
#@login_required    # TODO: Uncomment in final
def task_add(project_id):
    form = TaskForm()
    current_view = 'task-add'
    u = check_user()
    project = Project.query.get_or_404(project_id)
    form.project_id = project.id

    if login_override or (u.role == 'kierownik'):
        if form.validate_on_submit():
            task = Task(name=form.name.data, description=form.description.data, project=project_id)
            db.session.add(task)
            db.session.commit()
            flash('Zadanie utworzone', 'success')
            return redirect(url_for('projects_view', project_id=project_id))
        return render_template('admin/admin-task-add.html', u=u, current_view=current_view, project=project_id,
                               form=form)
    else:
        abort(403)


# Employee list
@app.route('/employees')
#@login_required    # TODO: Uncomment in final
def employees():
    current_view = 'employees'
    u = check_user()

    if login_override or (u.role == 'kierownik'):
        employeeList = User.query.all()
        return render_template('admin/admin-employee-list.html', employees=employeeList, u=u, current_view=current_view)

    else:
        # TODO unauthantized
        return 0


# Registration -----------------------------------------------------------------
@app.route("/register", methods=['GET', 'POST'])
def register():
    form = RegistrationForm()
    if form.validate_on_submit():
        hashed_password = bcrypt.generate_password_hash(form.password.data).decode('utf-8')
        user = User(login=form.login.data, password=hashed_password, name=form.name.data, surname=form.surname.data,
                    role=form.role.data)
        db.session.add(user)
        db.session.commit()
        flash('Użytkownik utworzony', 'success')
        return redirect(url_for('login'))
    return render_template('register.html', title='Register', form=form)


# Login ------------------------------------------------------------------------
@app.route('/', methods=['GET', 'POST'])
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
    return render_template('login.html', title='Login', form=form, error_message=error_message)


@app.route('/logout')
def logout():
    logout_user()
    return redirect(url_for('login'))
