# Server
This folder contains all the code necessary to run the python graphql server a long with a "poetry" installation file.

## Installing dependencies 
All dependency management is done with poetry, so the only dependencies are python>=3.9 and poetry then using poetry run the command
```
poetry install
```

## Running the server
The server is fully self contained and runs using an included sqlite .db file so to run the server just run
```
poetry run ./main.py
```

## Using the graphql server
By visiting the server on http://localhost:5000/graphql you can input various queries

### Login query 
auth(phone_num, password) -> accessToken, message
e.g.
```
mutation {
  auth(phoneNum:"0401", password:"rawpass") {
    accessToken
    message
  }
}
```  
will return
```
{
  "data": {
    "auth": {
      "accessToken": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1dWlkIjoxfQ.4YFfGcdP5RSECkNMgSQV3DVC9rrtC2-5Df3gyJ2dywA",
      "message": "success"
    }
  }
}
```
where accessToken is a JWT and message is pass/fail message

### Data query
person(uuid, jwt) -> Person
*Note* UUID can be a blank string for unprivileged requests
e.g.
```
query{
  person(uuid:1, jwt:"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1dWlkIjoxfQ.4YFfGcdP5RSECkNMgSQV3DVC9rrtC2-5Df3gyJ2dywA"){
    fName
  }
}
```
will return
```
{
  "data": {
    "person": {
      "fName": "alex"
    }
  }
}
```
where fName is the requested data of the person with the uuid of 1

The jwt string can be decrypted to find the uuid of the user who sent this query and depending on either the access level or if the jwt_uuid==query_uuid the amount of data returned from the query can be modified


