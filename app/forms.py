from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField, SelectField
from wtforms.validators import DataRequired, Length, ValidationError, EqualTo
from app.models import User


class RegistrationForm(FlaskForm):
    login = StringField('Username', validators=[DataRequired(), Length(max=20)])
    password = PasswordField('Password', validators=[DataRequired(), Length(min=6,max=30)])
    confirm_password = PasswordField('Confirm password', validators=[DataRequired(), EqualTo('password')])
    name = StringField('Name', validators=[DataRequired(), Length(max=20)])
    surname = StringField('Surname', validators=[DataRequired(), Length(max=30)])
    role = SelectField('Role', choices=['kierownik', 'pracownik', 'klient'])
    submit = SubmitField('Register')

    def validate_login(self, login):
        user = User.query.filter_by(login=login.data).first()
        if user:
            raise ValidationError('That username is taken. Please choose a different one.')


class LoginForm(FlaskForm):
    login = StringField('Username', validators=[DataRequired()])
    password = PasswordField('Password', validators=[DataRequired()])
    submit = SubmitField('Login')
