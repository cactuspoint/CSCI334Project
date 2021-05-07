from sqlalchemy import Column, Integer, ForeignKey
from sqlalchemy.orm import relationship

from . database import Base, engine

class PersonModel(Base):
    __tablename__ = 'person'
    uuid = Column(Integer, primary_key=True)
    
class ArticleModel(Base):
    __tablename__ = 'article'
    uuid = Column(Integer, primary_key=True)
    person_id = Column(ForeignKey("person.uuid"))
    
Base.prepare(engine)