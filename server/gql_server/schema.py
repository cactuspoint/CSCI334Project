import graphene
import uuid
import os
import time
from graphql import GraphQLError
from graphene_sqlalchemy import SQLAlchemyConnectionField, SQLAlchemyObjectType
from sqlalchemy import and_
from flask import request
import pathlib
from .middleware import encrypt_jwt, decrypt_jwt
from .models import db_session, Person as PersonModel
from . import UPLOAD_DIR

# Custom functions


def get_access(uuid):
    query = db_session.query(PersonModel).filter(PersonModel.uuid == uuid).first()
    if query:
        return query.access


# Setup Models


class Person(SQLAlchemyObjectType):
    class Meta:
        model = PersonModel
        exclude_fields = ("password",)
        interfaces = (graphene.relay.Node,)

    pfp = graphene.String()

    @staticmethod
    def resolve_pfp(root, info, **kwargs):
        if pathlib.Path(
            os.path.join(os.path.join(UPLOAD_DIR, "images"), root.uuid + ".png")
        ).is_file():
            return f"{request.url_root}download/images/{root.uuid}.png"
        else:
            return f"{request.url_root}download/images/default.png"


# Mutations


class InfectedMutation(graphene.Mutation):
    class Arguments(object):
        uuid = graphene.String(default_value="")
        jwt = graphene.String()
        status = graphene.Boolean(default_value=True)

    updated = graphene.Boolean()

    @classmethod
    def mutate(cls, _, info, uuid, jwt, status):
        auth_uuid = decrypt_jwt(jwt)
        query = (
            db_session.query(PersonModel).filter(PersonModel.uuid == auth_uuid).first()
        )
        if query.access < 2:
            raise GraphQLError("error: user does not have access")
        if uuid != "":
            query = (
                db_session.query(PersonModel).filter(PersonModel.uuid == uuid).first()
            )
        if query:
            query.infected = int(status)
            db_session.commit()
            return VaccinateMutation(updated=True)
        else:
            raise GraphQLError("error: no user with that jwt/uuid")


class VaccinateMutation(graphene.Mutation):
    class Arguments(object):
        jwt = graphene.String()
        uuid = graphene.String(default_value="")
        vaccineName = graphene.String(default_value="")
        vaccineInj = graphene.Int(default_value=0)
        vaccineRecInj = graphene.Int(default_value=0)

    updated = graphene.Boolean()

    @classmethod
    def mutate(cls, _, info, uuid, jwt, vaccineName, vaccineInj, vaccineRecInj):
        auth_uuid = decrypt_jwt(jwt)
        query = (
            db_session.query(PersonModel).filter(PersonModel.uuid == auth_uuid).first()
        )
        if query.access < 3:
            raise GraphQLError("error: user does not have access")
        if uuid != "":
            query = (
                db_session.query(PersonModel).filter(PersonModel.uuid == uuid).first()
            )
        if query:
            if vaccineName != "":
                query.vaccine_name = vaccineName
                query.vaccine_date = int(time.time())
            if vaccineInj != 0:
                query.vaccine_inj = vaccineInj
            if vaccineRecInj != 0:
                query.vaccine_rec_inj = vaccineRecInj
            db_session.commit()
            return VaccinateMutation(updated=True)
        else:
            raise GraphQLError("error: no user with that uuid/jwt")


class SignUpMutation(graphene.Mutation):
    class Arguments(object):
        phoneNum = graphene.String()
        password = graphene.String()
        firstName = graphene.String()
        lastName = graphene.String()

    access_token = graphene.String()

    @classmethod
    def mutate(cls, _, info, phoneNum, password, firstName, lastName):
        query = (
            db_session.query(PersonModel)
            .filter(PersonModel.phone_num == phoneNum)
            .first()
        )
        if not query:
            user = PersonModel(
                uuid=str(uuid.uuid1()),
                phone_num=phoneNum,
                password=password,
                first_name=firstName,
                last_name=lastName,
                access=0,
            )
            db_session.add(user)
            db_session.commit()
            return SignUpMutation(
                access_token=encrypt_jwt(user.uuid),
            )
        else:
            raise GraphQLError("error: user already exists")


class AuthMutation(graphene.Mutation):
    class Arguments(object):
        phoneNum = graphene.String()
        password = graphene.String()

    access_token = graphene.String()

    @classmethod
    def mutate(cls, _, info, phoneNum, password):
        query = (
            db_session.query(PersonModel)
            .filter(PersonModel.phone_num == phoneNum)
            .first()
        )
        if query:
            if query.password == password:
                return AuthMutation(
                    access_token=encrypt_jwt(query.uuid),
                )
            else:
                raise GraphQLError("error: incorrect password")
        else:
            raise GraphQLError("error: incorrect phoneNum")


class Mutation(graphene.ObjectType):
    auth = AuthMutation.Field()
    signUp = SignUpMutation.Field()
    vaccinate = VaccinateMutation.Field()
    infect = InfectedMutation.Field()


# Queries


class Query(graphene.ObjectType):
    node = graphene.relay.Node.Field()
    person = graphene.Field(
        Person,
        uuid=graphene.String(default_value=""),
        jwt=graphene.String(default_value=""),
    )

    def resolve_person(self, info, uuid, jwt):
        auth_uuid = ""
        if jwt != "":
            auth_uuid = decrypt_jwt(jwt)
        print("user logged in is : {}".format(auth_uuid))
        # As of here the auth_uuid = the uuid of the user logged in
        query = Person.get_query(info)
        uuid = auth_uuid if uuid == "" else uuid
        if uuid == "":
            raise GraphQLError("error: uuid OR jwt can be blank, not both")
        return query.get(uuid)

    uuid = graphene.String(phoneNum=graphene.String())

    def resolve_uuid(self, info, phoneNum):
        query = (
            db_session.query(PersonModel)
            .filter(PersonModel.phone_num == phoneNum)
            .first()
        )
        if query:
            return query.uuid
        else:
            raise GraphQLError("error: no user by that phoneNum")

    infectionLog = graphene.List(graphene.String, backLog=graphene.Int())

    def resolve_infectionLog(self, info, backLog):
        paths = sorted(
            pathlib.Path(os.path.join(UPLOAD_DIR, "logs")).iterdir(),
            key=os.path.getmtime,
        )
        log_paths = []
        backLog_epoch = time.time() - ((24 * 60 * 60) * backLog)
        for path in paths:
            if path.stat().st_mtime >= backLog_epoch:
                break
            log_paths.append(f"{request.url_root}download/logs/{path.name}")
        return log_paths

    injectionLog = graphene.Int(backLog=graphene.Int())

    def resolve_injectionLog(self, info, backLog):
        query = (
            db_session.query(PersonModel)
            .filter(
                PersonModel.vaccine_date >= int(time.time() - backLog * 24 * 60 * 60)
            )
            .count()
        )
        return query


# Setup


schema = graphene.Schema(query=Query, mutation=Mutation, types=[Person])
