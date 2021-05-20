import graphene
import uuid
import os
import time
from graphql import GraphQLError
from graphene_sqlalchemy import SQLAlchemyConnectionField, SQLAlchemyObjectType
from sqlalchemy import and_
from flask import request
import pathlib
from . middleware import encrypt_jwt, decrypt_jwt
from . models import db_session, Person as PersonModel
from . import UPLOAD_DIR

# Setup Models


class Person(SQLAlchemyObjectType):
    class Meta:
        model = PersonModel
        interfaces = (graphene.relay.Node, )

# Mutations


class SignUpMutation(graphene.Mutation):
    class Arguments(object):
        phoneNum = graphene.String()
        password = graphene.String()
        firstName = graphene.String()
        lastName = graphene.String()

    access_token = graphene.String()

    @classmethod
    def mutate(cls, _, info, phoneNum, password, firstName, lastName):
        query = db_session.query(PersonModel).filter(
            PersonModel.phone_num == phoneNum).first()
        if not query:
            user = PersonModel(uuid=str(uuid.uuid1()), phone_num=phoneNum,
                               password=password, first_name=firstName, last_name=lastName)
            db_session.add(user)
            db_session.commit()
            return SignUpMutation(
                access_token=encrypt_jwt(user.uuid),
            )
        else:
            raise GraphQLError('error: user already exists')


class AuthMutation(graphene.Mutation):
    class Arguments(object):
        phoneNum = graphene.String()
        password = graphene.String()

    access_token = graphene.String()

    @classmethod
    def mutate(cls, _, info, phoneNum, password):
        query = db_session.query(PersonModel).filter(
            PersonModel.phone_num == phoneNum).first()
        if query:
            if query.password == password:
                return AuthMutation(
                    access_token=encrypt_jwt(query.uuid),
                )
            else:
                raise GraphQLError('error: incorrect password')
        else:
            raise GraphQLError('error: incorrect phoneNum')


class Mutation(graphene.ObjectType):
    auth = AuthMutation.Field()
    signUp = SignUpMutation.Field()

# Queries


class Query(graphene.ObjectType):
    node = graphene.relay.Node.Field()
    person = graphene.Field(Person, uuid=graphene.String(
        default_value=""), jwt=graphene.String(default_value=""))
    def resolve_person(self, info, uuid, jwt):
        auth_uuid = ""
        if jwt != "":
            auth_uuid = decrypt_jwt(jwt)
        print("user logged in is : {}".format(auth_uuid))
        # As of here the auth_uuid = the uuid of the user logged in
        query = Person.get_query(info)
        if auth_uuid != "" and uuid == "":
            return query.get(auth_uuid)
        else:
            return query.get(uuid)
    uuid = graphene.String(phoneNum=graphene.String())
    def resolve_uuid(self, info, phoneNum):
        query = db_session.query(PersonModel).filter(
            PersonModel.phone_num == phoneNum).first()
        if query:
            return query.uuid
        else:
            raise GraphQLError('error: no user by that phoneNum')
    infectionLog = graphene.List(graphene.String, backLog=graphene.Int())
    def resolve_infectionLog(self, info, backLog):
        paths = sorted(pathlib.Path(os.path.join(UPLOAD_DIR, 'logs')).iterdir(), key=os.path.getmtime)
        log_paths = []
        backLog_epoch = time.time()-((24*60*60)*backLog)
        for path in paths:
            if path.stat().st_mtime < backLog_epoch:
                break
            log_paths.append(f'{request.url_root}dowload/log/{path.name}')
        return log_paths


# Setup


schema = graphene.Schema(query=Query, mutation=Mutation, types=[Person])
