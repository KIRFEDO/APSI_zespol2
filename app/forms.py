from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField, SelectField, TextAreaField, DateField, DecimalField
from wtforms.validators import DataRequired, Length, ValidationError, EqualTo
from app.models import User, Project, Task


class RegistrationForm(FlaskForm):
    login = StringField('Login', validators=[DataRequired(), Length(max=20)])
    password = PasswordField('Hasło', validators=[DataRequired(), Length(min=6, max=30)])
    confirm_password = PasswordField('Potwierdź hasło', validators=[DataRequired(), EqualTo('password')])
    name = StringField('Imię', validators=[DataRequired(), Length(max=20)])
    surname = StringField('Nazwisko', validators=[DataRequired(), Length(max=30)])
    role = SelectField('Rola', choices=['kierownik', 'pracownik', 'klient'])
    submit = SubmitField('Stwórz użytkownika')

    def validate_login(self, login):
        user = User.query.filter_by(login=login.data).first()
        if user:
            raise ValidationError('Login jest zajęty. Proszę wybrać inny login.')


class LoginForm(FlaskForm):
    login = StringField('Login', validators=[DataRequired()])
    password = PasswordField('Hasło', validators=[DataRequired()])
    submit = SubmitField('Zaloguj')


class ProjectForm(FlaskForm):
    name = StringField('Nazwa', validators=[DataRequired(), Length(max=50)])
    description = TextAreaField('Opis', validators=[Length(max=500)])
    client = SelectField('Zlecający klient')
    submit = SubmitField('Stwórz projekt')

    def __init__(self, *args, **kwargs):
        super(ProjectForm, self).__init__(*args, **kwargs)
        self.client.choices = [("", "Brak" + " " + "klienta")] + [(c.id, c.name + " " + c.surname) for c in
                                                                  User.query.filter(User.role == "klient")]

    def validate_name(self, name):
        p = Project.query.filter_by(name=name.data).first()
        if p:
            raise ValidationError('Istnieje już projekt o takiej nazwie.')


class AddActivityForm(FlaskForm):
    description = TextAreaField('Opis aktywności:', validators=[DataRequired(), Length(max=500)])
    task = SelectField('Zadanie:', validators=[DataRequired()])
    date = DateField('Data wykonania:', validators=[DataRequired()])
    activityTime = DecimalField('Czas aktywności (w godzinach):', places=2, validators=[DataRequired()])
    submit = SubmitField('Zapisz aktywność')

    def __init__(self, *args, **kwargs):
        super(AddActivityForm, self).__init__(*args, **kwargs)
        self.task.choices = [("", "Wybierz zadanie")] + [(c.id, c.name) for c in Task.query]


class TaskForm(FlaskForm):
    name = StringField('Nazwa', validators=[DataRequired(), Length(max=50)])
    description = TextAreaField('Opis', validators=[Length(max=500)])
    submit = SubmitField('Stwórz projekt')

    def validate_name(self, name):
        t = Task.query.filter_by(name=name.data, project=self.project_id).first()
        if t:
            raise ValidationError('Istnieje już zadanie o takiej nazwie dla tego projektu.')