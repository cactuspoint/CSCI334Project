import sqlalchemy as sqa
from sqlalchemy.orm import scoped_session, sessionmaker, relationship, backref
from sqlalchemy.ext.declarative import declarative_base

engine = sqa.create_engine("sqlite:///db.sqlite3", convert_unicode=True)
db_session = scoped_session(
    sessionmaker(autocommit=False, autoflush=False, bind=engine)
)

Base = declarative_base()
Base.query = db_session.query_property()


class Person(Base):
    __tablename__ = "Person"
    uuid = sqa.Column(sqa.String, primary_key=True)
    access = sqa.Column(sqa.Integer)
    phone_num = sqa.Column(sqa.String)
    password = sqa.Column(sqa.String)
    first_name = sqa.Column(sqa.String)
    last_name = sqa.Column(sqa.String)
    infected = sqa.Column(sqa.Boolean)
    vaccine_name = sqa.Column(sqa.String)
    vaccine_inj = sqa.Column(sqa.Integer)
    vaccine_rec_inj = sqa.Column(sqa.Integer)
    vaccine_date = sqa.Column(sqa.Integer)
