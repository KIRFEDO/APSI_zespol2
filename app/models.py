from app import db, login_manager
from flask_login import UserMixin


@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))


class User(db.Model, UserMixin):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True)
    login = db.Column(db.String(20), unique=True, nullable=False)
    password = db.Column(db.String(100), nullable=False)
    name = db.Column(db.String(20), nullable=False)
    surname = db.Column(db.String(30), nullable=False)
    role = db.Column(db.Enum('administrator', 'employee', name='role'), nullable=False)
    supervisor = db.Column(db.Integer, db.ForeignKey('users.id'))
    active = db.Column(db.Boolean, nullable=False)
    subordinates = db.relationship('User', remote_side=[id], backref='worker_supervisor', lazy=True, foreign_keys='User.supervisor')
    supervised_projects = db.relationship('Project', backref='project_supervisor', lazy=True,
                                          foreign_keys='Project.supervisor')
    commissioned_projects = db.relationship('Project', backref='project_commissioner', lazy=True,
                                            foreign_keys='Project.client')
    created_epics = db.relationship('Epic', backref='created_by', lazy=True, foreign_keys='Epic.creator')
    created_tasks = db.relationship('Task', backref='created_by', lazy=True, foreign_keys='Task.creator')
    assigned_tasks = db.relationship('Task', backref='assigned_person', lazy=True, foreign_keys='Task.assigned_to')


class Project(db.Model):
    __tablename__ = 'projects'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50), unique=True, nullable=False)
    description = db.Column(db.String(500))
    status = db.Column(db.Enum('aktywny', 'zakończony', 'zawieszony', name='status'), nullable=False)
    supervisor = db.Column(db.Integer, db.ForeignKey('users.id'))
    client = db.Column(db.Integer, db.ForeignKey('users.id'))
    start = db.Column(db.DateTime, nullable=False)
    deadline = db.Column(db.DateTime, nullable=False)
    projects_epics = db.relationship('Epic', backref='associated_project', cascade="all,delete", lazy=True,
                                     foreign_keys='Epic.project')


class Epic(db.Model):
    __tablename__ = 'epics'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50), unique=True, nullable=False)
    description = db.Column(db.String(500))
    creator = db.Column(db.Integer, db.ForeignKey('users.id'))
    deadline = db.Column(db.DateTime, nullable=False)
    supervisor_approved = db.Column(db.Boolean, nullable=False)
    client_approved = db.Column(db.Boolean, nullable=False)
    project = db.Column(db.Integer, db.ForeignKey('projects.id'), nullable=False)
    epic_tasks = db.relationship('Task', backref='associated_epic', cascade="all,delete", lazy=True,
                                 foreign_keys='Task.epic')


class Task(db.Model):
    __tablename__ = 'tasks'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50), unique=True, nullable=False)
    description = db.Column(db.String(500))
    creator = db.Column(db.Integer, db.ForeignKey('users.id'))
    expected_time = db.Column(db.Float)
    assigned_to = db.Column(db.Integer, db.ForeignKey('users.id'))
    finished = db.Column(db.Boolean, nullable=False)
    supervisor_approved = db.Column(db.Boolean, nullable=False)
    epic = db.Column(db.Integer, db.ForeignKey('epics.id'), nullable=False)
