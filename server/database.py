from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base, DeferredReflection
from sqlalchemy.orm import scoped_session, sessionmaker

engine = create_engine('sqlite:////home/iommu/Desktop/CSCI334Project/server/test.db', echo=True)
session = scoped_session(sessionmaker(autocommit=False, autoflush=False, bind=engine))

Base = declarative_base(cls=DeferredReflection)
Base.query = session.query_property()
