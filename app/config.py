import os


class Config:
    SECRET_KEY = os.urandom(32)
    SQLALCHEMY_DATABASE_URI = 'postgresql://apsi:12345@localhost/apsi_db'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
