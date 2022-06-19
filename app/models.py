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
    role = db.Column(db.Enum('kierownik', 'pracownik', 'klient', name='role'), nullable=False)
    supervisor = db.Column(db.Integer, db.ForeignKey('users.id'))
    subordinates = db.relationship('User', remote_side=[id], backref='worker_supervisor', lazy=True,
                                   foreign_keys='User.supervisor')
    supervised_projects = db.relationship('Project', backref='project_creator', lazy=True,
                                          foreign_keys='Project.creator')
    commissioned_projects = db.relationship('Project', backref='project_commissioner', lazy=True,
                                            foreign_keys='Project.client')
    assigned_projects = db.relationship('ProjectAssignment', backref='assigned_person', cascade="all,delete", lazy=True,
                                        foreign_keys='ProjectAssignment.user_id')
    activities_done = db.relationship('Activity', backref='done_by', lazy=True,
                                      foreign_keys='Activity.user_id')


class Project(db.Model):
    __tablename__ = 'projects'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50), unique=True, nullable=False)
    description = db.Column(db.String(500))
    creator = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    client = db.Column(db.Integer, db.ForeignKey('users.id'))
    projects_tasks = db.relationship('Task', backref='associated_project', cascade="all,delete", lazy=True,
                                     foreign_keys='Task.project')
    workers = db.relationship('ProjectAssignment', backref='assigned_project', cascade="all,delete", lazy=True,
                              foreign_keys='ProjectAssignment.project_id')


class Task(db.Model):
    __tablename__ = 'tasks'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50), unique=True, nullable=False)
    description = db.Column(db.String(500))
    project = db.Column(db.Integer, db.ForeignKey('projects.id'), nullable=False)
    associated_activities = db.relationship('Activity', order_by="desc(Activity.date),desc(Activity.time)",
                                            backref='associated_task', cascade="all,delete", lazy=True,
                                            foreign_keys='Activity.task_id')


class ProjectAssignment(db.Model):
    __tablename__ = 'project_assignment'
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    project_id = db.Column(db.Integer, db.ForeignKey('projects.id'), nullable=False)
    project_role = db.Column(db.Enum('kierownik projektu', 'uczestnik projektu', name='project_role'), nullable=False)
    start = db.Column(db.Date, nullable=False)
    end = db.Column(db.Date)


class Activity(db.Model):
    __tablename__ = 'activities'
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    task_id = db.Column(db.Integer, db.ForeignKey('tasks.id'), nullable=False)
    date = db.Column(db.Date, nullable=False)
    time = db.Column(db.Interval, nullable=False)
    description = db.Column(db.String(500))
    supervisor_approved = db.Column(db.Boolean)  # null before review, after edit
    client_approved = db.Column(db.Boolean)  # null before review, after edit
    related_resource = db.Column(db.Enum('brak', 'dokument', 'zgłoszony problem', name='related_resource'),
                                 nullable=False)
    document = db.Column(db.Integer, db.ForeignKey('documents.id'))
    error = db.Column(db.Integer, db.ForeignKey('submitted_errors.id'))

    def dump(self):
        return {'id': self.id,
                'user_id': self.user_id,
                'task_id': self.task_id,
                'date': self.date.strftime("%m/%d/%Y"),
                'time': self.time.seconds // 3600,
                'description': self.description,
                'supervisor_approved': self.supervisor_approved,
                'client_approved': self.client_approved}


class Document(db.Model):
    __tablename__ = 'documents'
    id = db.Column(db.Integer, primary_key=True)
    project = db.Column(db.Integer, db.ForeignKey('projects.id'), nullable=False)
    name = db.Column(db.String(50), nullable=False)
    activities = db.relationship('Activity', backref='related_document', cascade="all,delete", lazy=True,
                                 foreign_keys='Activity.document')


class SubmittedError(db.Model):
    __tablename__ = 'submitted_errors'
    id = db.Column(db.Integer, primary_key=True)
    project = db.Column(db.Integer, db.ForeignKey('projects.id'), nullable=False)
    name = db.Column(db.String(50), nullable=False)
    activities = db.relationship('Activity', backref='related_error', cascade="all,delete", lazy=True,
                                 foreign_keys='Activity.error')
