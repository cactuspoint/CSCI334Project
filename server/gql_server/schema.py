import graphene
from graphql import GraphQLError
from graphene_sqlalchemy import SQLAlchemyConnectionField, SQLAlchemyObjectType
from sqlalchemy import Column, Integer, ForeignKey

from . middleware import encrypt_jwt, decrypt_jwt
from . models import *
from . database import session

### Mutations 

class AuthMutation(graphene.Mutation):
    class Arguments(object):
        phoneNum = graphene.String()
        password = graphene.String()

    access_token = graphene.String()

    @classmethod
    def mutate(cls, _, info, phoneNum, password):
        query = Person.get_query(info).filter_by(phone_num=phoneNum)
        if query.first():
            if query.first().password==password:
                return AuthMutation(
                    access_token=encrypt_jwt(query.first().uuid),
                )       
            else:
                raise GraphQLError('error: incorrect password')
        else:
            raise GraphQLError('error: incorrect phoneNum')


class Mutation(graphene.ObjectType):
    auth = AuthMutation.Field()

### Queries

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
    person = graphene.Field(Person, uuid=graphene.Int(), jwt=graphene.String())
    def resolve_person(self, info, uuid, jwt):
        auth_uuid = ""
        if jwt != "":
            auth_uuid = decrypt_jwt(jwt)
        print("user logged in is : {}".format(auth_uuid))
        ### As of here the auth_uuid = the uuid of the user logged in
        query = Person.get_query(info)
        return query.get(uuid)

### Setup

schema = graphene.Schema(query=Query, mutation=Mutation, types=[Person])