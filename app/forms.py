from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField, SelectField
from wtforms.validators import DataRequired, Length, ValidationError, EqualTo
from app.models import User


class RegistrationForm(FlaskForm):
    login = StringField('Login', validators=[DataRequired(), Length(max=20)])
    password = PasswordField('Hasło', validators=[DataRequired(), Length(max=30)])
    confirm_password = PasswordField('Potwierdź hasło', validators=[DataRequired(), EqualTo('password')])
    name = StringField('Imię', validators=[DataRequired(), Length(max=20)])
    surname = StringField('Nazwisko', validators=[DataRequired(), Length(max=30)])
    role = SelectField('Rola użytkownika', choices=['administrator', 'kierownik', 'pracownik', 'klient'])
    submit = SubmitField('Utwórz użytkownika')

    def validate_login(self, login):
        user = User.query.filter_by(login=login.data).first()
        if user:
            raise ValidationError('That username is taken. Please choose a different one.')
