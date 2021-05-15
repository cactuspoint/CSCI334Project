import graphene
import uuid
from graphql import GraphQLError
from graphene_sqlalchemy import SQLAlchemyConnectionField, SQLAlchemyObjectType
from sqlalchemy import and_
from . middleware import encrypt_jwt, decrypt_jwt
from . models import db_session, Person as PersonModel, Vaccine as VaccineModel

### Setup Models
class Person(SQLAlchemyObjectType):
    class Meta:
        model = PersonModel
        interfaces = (graphene.relay.Node, )

class Vaccine(SQLAlchemyObjectType):
    class Meta:
        model = VaccineModel
        interfaces = (graphene.relay.Node, )

### Mutations 

class SignUpMutation(graphene.Mutation):
    class Arguments(object):
        phoneNum = graphene.String()
        password = graphene.String()
        firstName = graphene.String()
        lastName = graphene.String()

    access_token = graphene.String()

    @classmethod
    def mutate(cls, _, info, phoneNum, password, firstName, lastName):
        query = db_session.query(PersonModel).filter(PersonModel.phone_num == phoneNum).first()
        if not query:
            user = PersonModel(uuid=str(uuid.uuid1()), phone_num=phoneNum, password=password, first_name=firstName, last_name=lastName)
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
        query = db_session.query(PersonModel).filter(PersonModel.phone_num == phoneNum).first()
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

### Queries
        
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