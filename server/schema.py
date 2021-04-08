import graphene
from graphene_sqlalchemy import SQLAlchemyConnectionField, SQLAlchemyObjectType
from models import *

class Person(SQLAlchemyObjectType):
    class Meta:
        model = PersonModel
        interfaces = (graphene.relay.Node, )

class Article(SQLAlchemyObjectType):
    class Meta:
        model = ArticleModel
        interfaces = (graphene.relay.Node, )
        
class Query(graphene.ObjectType):
    node = graphene.relay.Node.Field()
    person = graphene.Field(Person, uuid=graphene.Int())   
    def resolve_person(self, info, uuid):
        query = Person.get_query(info)
        return query.get(uuid)

schema = graphene.Schema(query=Query, types=[Person])