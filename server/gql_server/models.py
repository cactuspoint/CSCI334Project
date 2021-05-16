from sqlalchemy import *
from sqlalchemy.orm import scoped_session, sessionmaker, relationship, backref
from sqlalchemy.ext.declarative import declarative_base

engine = create_engine('sqlite:///db.sqlite3', convert_unicode=True)
db_session = scoped_session(sessionmaker(autocommit=False, autoflush=False, bind=engine))

Base = declarative_base()
Base.query = db_session.query_property()

class Person(Base):
    __tablename__ = 'Person'
    uuid = Column(String, primary_key=True)
    phone_num = Column(String)
    password = Column(String)
    first_name = Column(String)
    last_name = Column(String)

class Vaccine(Base):
    __tablename__ = 'Vaccine'    
    person_id = Column(ForeignKey("Person.uuid"), primary_key=True)
