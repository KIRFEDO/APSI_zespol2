from app import app, db, bcrypt
from flask import render_template, redirect, flash, url_for, request, abort
from flask_login import current_user, login_user, logout_user, login_required
from app.forms import LoginForm, RegistrationForm, ProjectForm, TaskForm, AddActivityForm, create_employee_assign_form
from app.models import User, Project, Task, Activity, ProjectAssignment, Document, SubmittedError
import json

import datetime
from babel.dates import format_timedelta


@app.template_filter('formatdatetime')
def formatdatetime(value):
    return str(value.days * 24 + value.seconds // 3600) + " h"


# ------------------------------------------------------------------------------
# Login/Register/Logout --------------------------------------------------------
# ------------------------------------------------------------------------------

# Get user

def get_user():
    return User.query.get(current_user.get_id())


# Resource ownership check

def check_ownership(user, required):
    if isinstance(required, list):
        if user not in required:
            abort(403)
    else:
        if user != required:
            abort(403)

# Registration
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


# Login
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


# Logout
@app.route('/logout')
def logout():
    logout_user()
    return redirect(url_for('login'))


# ------------------------------------------------------------------------------
# Activities -------------------------------------------------------------------
# ------------------------------------------------------------------------------

# Activities list
@app.route('/activities')
@login_required
def activities():
    current_view = 'activities'
    u = get_user()

    if u.role == 'pracownik':
        activityList = Activity.query.filter(Activity.user_id == u.id)
        #activitiesToAccept = db.session.query(Activity, Project).filter(u.id in [worker.user_id for worker in Project.workers if worker.project_role == 'kierownik projektu']).all()
    elif u.role == 'klient':
        activityList = db.session.query(Activity, Project).filter(Project.client == u.id).all()
    elif u.role == 'kierownik':
        activityList = Activity.query.filter(Activity.user_id == u.id)
        #activitiesToAccept = db.session.query(Activity, Project).filter(u.id in [worker.user_id for worker in Project.workers if worker.project_role == 'kierownik projektu']).all()

    return render_template('common/activity/activities-list.html', activities=activityList, u=u, current_view=current_view)#, activitiesToAccept=activitiesToAccept)


@app.route("/activities/info")
@login_required
def api_info():
    u = get_user()
    return json.dumps([ob.dump() for ob in list(Activity.query.filter(Activity.user_id == u.id))])


# Activity add
@app.route('/activities/add', methods=['GET', 'POST'])
@app.route('/activities/add/<project_id>/<task_id>/', methods=['GET', 'POST'])
@login_required
def activity_add(project_id=None, task_id=None):
    # Go back descitnation url
    if request.args.get('go_back'):
        go_back = request.args.get('go_back')
    else:
        go_back = 'project-view'

    form = AddActivityForm(task=task_id, project=project_id)
    current_view = 'activities-add'
    u = get_user()

    if u.role != 'klient':
        if form.validate_on_submit():
            user = current_user.get_id()
            doc = form.document.data
            if doc == "":
                doc = None
            err = form.error.data
            if err == "":
                err = None
            activity = Activity(date=form.date.data, description=form.description.data, user_id=user,
                                task_id=form.task.data, time=datetime.timedelta(hours=float(form.activityTime.data)),
                                related_resource=form.related_resource.data, document=doc, error=err)
            db.session.add(activity)
            db.session.commit()
            flash('Aktywność utworzona', 'success')

            if go_back == 'project-view':
                return redirect(url_for('projects_view', project_id=activity.associated_task.associated_project.id,
                                        active_task_id=task_id))
            elif go_back == 'activities':
                return redirect(url_for('activities'))
        return render_template('common/activity/activity-add.html', u=u, current_view=current_view, form=form,
                               task_id=task_id)
    else:
        # TODO: Co w przypadku klienta wchodzącego na formularz dodania czynnosci?
        abort(403)



# Modify activity
@app.route('/activities/modify/<project_id>/<task_id>/<activity_id>', methods=['GET', 'POST'])
@login_required
def activity_modify(project_id=None, task_id=None, activity_id=None):
    # Go back descitnation url
    if request.args.get('go_back'):
        go_back = request.args.get('go_back')
    else:
        go_back = 'project-view'
    current_view = 'activities-add'
    u = get_user()

    activity = Activity.query.filter(Activity.id == activity_id).first()
    form = AddActivityForm(task=task_id, project=project_id, date=activity.date,
                                activityTime=activity.time.seconds//3600, description=activity.description,
                                related_resource = activity.related_resource)

    if u.role != 'klient':
        if form.validate_on_submit():
            user = current_user.get_id()
            doc = form.document.data
            if doc == "":
                doc = None
            err = form.error.data
            if err == "":
                err = None

            activity.date = form.date.data
            activity.time = datetime.timedelta(hours=float(form.activityTime.data))
            activity.description = form.description.data
            activity.related_resource = form.related_resource.data
            activity.document = doc

            db.session.commit()
            flash('Aktywność utworzona', 'success')

            if go_back == 'project-view' or go_back == None:
                return redirect(url_for('projects_view', project_id=project_id, active_task_id=task_id))
            elif go_back == 'activities':
                return redirect(url_for('activities'))
        return render_template('common/activity/activity-add.html', u=u, current_view=current_view, form=form,
                               task_id=task_id)
    else:
        # TODO: Co w przypadku klienta wchodzącego na formularz dodania czynnosci?
        abort(403)



# Delete activity
@app.route('/projects/<int:project_id>/<int:task_id>/<int:activity_id>/delete', methods=['GET', 'POST'])
@login_required
def activity_delete(project_id=None, task_id=None, activity_id=None):
    u = get_user()
    if u.role == 'pracownik':
        activity = Activity.query.get_or_404(activity_id)
        check_ownership(u.id, activity.user_id)
    elif u.role == 'klient':
        abort(403)
    elif u.role == 'kierownik':
        project = Project.query.get_or_404(project_id)
        check_ownership(u.id, [worker.user_id for worker in project.workers if worker.project_role == 'kierownik projektu'])

    Activity.query.filter(Activity.id == activity_id).delete()
    db.session.commit()
    return redirect(url_for('projects_view', project_id=project_id, active_task_id=task_id))


# Accept activity - supervisor
@app.route('/projects/<int:project_id>/<int:task_id>/<int:activity_id>/accept_supervisor/<int:state>')
@login_required
def activity_accept_supervisor(project_id=None, task_id=None, activity_id=None, state=None):
    u = get_user()

    if request.args.get('go_back'):
        go_back = request.args.get('go_back')
    else:
        go_back = 'project-view'

    project = Project.query.get_or_404(project_id)
    check_ownership(u.id, [worker.user_id for worker in project.workers if worker.project_role == 'kierownik projektu'])

    if u.role == 'kierownik':
        activity = Activity.query.filter(Activity.id == activity_id).first()
        if state == 0:
            activity.supervisor_approved = False
        elif state == 1:
            activity.supervisor_approved = True
        elif state == 2:
            activity.supervisor_approved = None
        db.session.commit()

    if go_back == 'project-view':
        return redirect(url_for('projects_view', project_id=project_id, active_task_id=task_id))
    elif go_back == 'activities':
        return redirect(url_for('activities'))


# Accept activity - customer
@app.route('/projects/<int:project_id>/<int:task_id>/<int:activity_id>/accept_client/<int:state>')
@login_required
def activity_accept_client(project_id=None, task_id=None, activity_id=None, state=None):
    u = get_user()

    if request.args.get('go_back'):
        go_back = request.args.get('go_back')
    else:
        go_back = 'project-view'

    project = Project.query.get_or_404(project_id)
    check_ownership(u.id, project.client)

    if u.role == 'klient':
        activity = Activity.query.filter(Activity.id == activity_id).first()
        if state == 0:
            activity.client_approved = False
        elif state == 1:
            activity.client_approved = True
        elif state == 2:
            activity.client_approved = None
        db.session.commit()

    if go_back == 'project-view':
        return redirect(url_for('projects_view', project_id=project_id, active_task_id=task_id))
    elif go_back == 'activities':
        return redirect(url_for('activities'))


# ------------------------------------------------------------------------------
# Tasks ------------------------------------------------------------------------
# ------------------------------------------------------------------------------

# Add new task
@app.route('/projects/<int:project_id>/task/add', methods=['GET', 'POST'])
@login_required
def task_add(project_id):
    form = TaskForm()
    current_view = 'task-add'
    u = get_user()
    project = Project.query.get_or_404(project_id)
    check_ownership(u.id, [worker.user_id for worker in project.workers if worker.project_role == 'kierownik projektu'])
    project = Project.query.get_or_404(project_id)
    form.project_id = project.id

    if form.validate_on_submit():
        task = Task(name=form.name.data, description=form.description.data, project=project_id)
        db.session.add(task)
        db.session.commit()
        flash('Zadanie utworzone', 'success')
        return redirect(url_for('projects_view', project_id=project_id))
    return render_template('admin/admin-task-add.html', u=u, current_view=current_view, project=project_id,
                           form=form)

@app.route('/tasks/<int:project_id>', methods=['GET', 'POST'])
@login_required
def project_tasks(project_id):
    tasks = [(c.id, c.name) for c in Task.query.join(Project).filter(Project.id == project_id)]
    return json.dumps(tasks)


@app.route('/documents/<int:project_id>', methods=['GET', 'POST'])
@login_required
def project_documents(project_id):
    documents = [(c.id, c.name) for c in Document.query.join(Project).filter(Project.id == project_id)]
    return json.dumps(documents)


@app.route('/errors/<int:project_id>', methods=['GET', 'POST'])
@login_required
def project_errors(project_id):
    errors = [(c.id, c.name) for c in SubmittedError.query.join(Project).filter(Project.id == project_id)]
    return json.dumps(errors)


# Delete task
@app.route('/projects/<int:project_id>/<int:task_id>/delete', methods=['GET', 'POST'])
@login_required
def task_delete(project_id=None, task_id=None):
    project = Project.query.get_or_404(project_id)
    check_ownership(int(current_user.get_id()), [worker.user_id for worker in project.workers if worker.project_role == 'kierownik projektu'])
    Task.query.filter(Task.id == task_id).delete()
    db.session.commit()
    return redirect(url_for('projects_view', project_id=project_id, active_task_id=None))

# ------------------------------------------------------------------------------
# Projects ---------------------------------------------------------------------
# ------------------------------------------------------------------------------

# Single project view
@app.route('/projects/<int:project_id>', methods=['GET', 'POST'])
@login_required
def projects_view(project_id):
    project = Project.query.get_or_404(project_id)
    current_view = 'projects-view'
    u = get_user()
    project_assigns = ProjectAssignment.query.filter(ProjectAssignment.project_id == project_id,
                                                     ProjectAssignment.end.is_(None))
    assigned_users = [a.user_id for a in project_assigns]
    project_supervisors = ProjectAssignment.query.filter(ProjectAssignment.project_id == project_id,
                                                         ProjectAssignment.project_role == 'kierownik projektu')
    supervisors = [a.user_id for a in project_supervisors]

    # Active task
    if request.args.get('active_task_id'):
        active_task_id = int(request.args.get('active_task_id'))
    else:
        active_task_id = 0

    # Employee assign/remove form
    form = create_employee_assign_form(assigned_users, project, supervisors)
    if form.validate_on_submit():
        emp = form.employee.data
        if emp != "" and (int(emp) not in assigned_users):
            past_assign = ProjectAssignment.query.filter(ProjectAssignment.project_id == project_id,
                                                         ProjectAssignment.user_id == emp,
                                                         ProjectAssignment.project_role == form.employee_role.data).first()
            if past_assign is None:
                pAssignment = ProjectAssignment(user_id=form.employee.data, project_id=project_id,
                                                project_role=form.employee_role.data, start=datetime.date.today())
                db.session.add(pAssignment)
            else:
                past_assign.end = None
            db.session.commit()
            return redirect(url_for('projects_view', project_id=project_id))

        emp_to_remove = form.employee_to_remove.data
        if emp_to_remove != "" and (int(emp_to_remove) in assigned_users):
            eAssignment = ProjectAssignment.query.filter(ProjectAssignment.project_id == project_id,
                                                         ProjectAssignment.user_id == emp_to_remove,
                                                         ProjectAssignment.end.is_(None)).first()
            eAssignment.end = datetime.date.today()
            db.session.commit()
            return redirect(url_for('projects_view', project_id=project_id))

    return render_template('common/project/project-view.html', u=u, project=project, project_assigns=project_assigns,
                           active_task_id=active_task_id, current_view=current_view, form=form)


# Projects list
@app.route('/projects')
@login_required
def projects():
    current_view = 'projects'
    u = get_user()

    if u.role == 'kierownik' or u.role == 'pracownik':
        projectlist = [p.assigned_project for p in u.assigned_projects]

    if u.role == 'klient':
        projectlist = Project.query.filter(Project.client == u.id)

    return render_template('common/project/project-list.html', projects=projectlist, u=u, current_view=current_view)


# Project add
@app.route('/projects/add', methods=['GET', 'POST'])
@login_required
def project_add():
    form = ProjectForm()
    current_view = 'projects-add'
    u = get_user()

    if u.role == 'kierownik':
        if form.validate_on_submit():
            c = form.client.data
            if c == "":
                c = None
            user = current_user.get_id()
            project = Project(name=form.name.data, description=form.description.data, creator=user,
                              client=c)
            db.session.add(project)
            db.session.flush()
            db.session.refresh(project)
            pAssignment = ProjectAssignment(user_id=project.creator, project_id=project.id,
                                            project_role='kierownik projektu', start=datetime.date.today())
            db.session.add(pAssignment)
            db.session.commit()
            flash('Projekt utworzony', 'success')
            return redirect(url_for('projects'))
        return render_template('admin/admin-project-add.html', u=u, current_view=current_view, form=form)
    else:
        abort(403)


# Delete project
@app.route('/projects/<int:project_id>/delete', methods=['GET', 'POST'])
@login_required
def project_delete(project_id=None):
    project = Project.query.get_or_404(project_id)
    check_ownership(int(current_user.get_id()), [worker.user_id for worker in project.workers if worker.project_role == 'kierownik projektu'])


    Project.query.filter(Project.id == project_id).delete()
    db.session.commit()
    return redirect(url_for('projects'))


# ------------------------------------------------------------------------------
# Various ----------------------------------------------------------------------
# ------------------------------------------------------------------------------

# Employee list
@app.route('/employees')
@login_required
def employees():
    current_view = 'employees'
    u = get_user()

    if u.role == 'kierownik':
        employeeList = User.query.all()
        return render_template('admin/admin-employee-list.html', employees=employeeList, u=u, current_view=current_view)
    else:
        # TODO unauthantized
        return 0


# Invoice printing
@app.route('/projects/<int:project_id>/invoice', methods=['GET', 'POST'])
@login_required
def invoice_view(project_id):
    project = Project.query.get_or_404(project_id)
    current_view = 'invoice-view'
    u = get_user()
    return render_template('common/project/invoice-view.html', u=u, project=project, current_view=current_view)
