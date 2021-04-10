import graphene
from graphene_sqlalchemy import SQLAlchemyConnectionField, SQLAlchemyObjectType
from sqlalchemy import Column, Integer, ForeignKey
from flask_graphql_auth import (
    AuthInfoField,
    get_jwt_identity,
    get_raw_jwt,
    create_access_token,
    create_refresh_token,
    query_jwt_required,
    mutation_jwt_refresh_token_required,
    mutation_jwt_required,
)
from models import *
from database import session

### Mutations 

class MessageField(graphene.ObjectType):
    message = graphene.String()


class ProtectedUnion(graphene.Union):
    class Meta:
        types = (MessageField, AuthInfoField)

    @classmethod
    def resolve_type(cls, instance, info):
        return type(instance)


class AuthMutation(graphene.Mutation):
    class Arguments(object):
        username = graphene.String()
        password = graphene.String()

    access_token = graphene.String()
    refresh_token = graphene.String()
    message = graphene.String()

    @classmethod
    def mutate(cls, _, info, username, password):
        query = Person.get_query(info).filter_by(username=username)
        if query.first() and query.first().password==password:
            return AuthMutation(
                access_token=create_access_token(username),
                refresh_token=create_refresh_token(username),
                message="success"
            )
        else:
            return AuthMutation(
                message="error: no user by that username",
            )


class ProtectedMutation(graphene.Mutation):
    class Arguments(object):
        token = graphene.String()

    message = graphene.Field(ProtectedUnion)

    @classmethod
    @mutation_jwt_required
    def mutate(cls, _, info):
        return ProtectedMutation(
            message=MessageField(message="Protected mutation works")
        )


class RefreshMutation(graphene.Mutation):
    class Arguments(object):
        refresh_token = graphene.String()

    new_token = graphene.String()

    @classmethod
    @mutation_jwt_refresh_token_required
    def mutate(self, _):
        current_user = get_jwt_identity()
        return RefreshMutation(new_token=create_access_token(identity=current_user))


class Mutation(graphene.ObjectType):
    auth = AuthMutation.Field()
    refresh = RefreshMutation.Field()
    protected = ProtectedMutation.Field()

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
    protected = graphene.Field(type=ProtectedUnion, token=graphene.String())
    person = graphene.Field(Person, uuid=graphene.Int())   

    def resolve_person(self, info, uuid):
        query = Person.get_query(info)
        return query.get(uuid)
    
    @query_jwt_required
    def resolve_protected(self, info):
        return MessageField(message="Hello World!")


### Setup

schema = graphene.Schema(query=Query, mutation=Mutation, types=[Person])