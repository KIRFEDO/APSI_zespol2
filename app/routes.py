from app import app, db, bcrypt
from flask import render_template, redirect, flash, url_for
from app.forms import RegistrationForm
from app.models import User


@app.route('/')
def home():
    return render_template('home.html')


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
        return redirect(url_for('home'))
    return render_template('register.html', title='Register', form=form)
