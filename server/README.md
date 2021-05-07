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
auth(username, password) -> accessToken, message
where accessToken is a JWT and message is pass/fail message
```
mutation {
  auth(username:"acarter", password:"rawpass") {
    accessToken
    message
  }
}
```

### Data query
person(uuid, jwt) -> Person
where Person is the Person's data with the uuid, uuid
```
query{
  person(uuid:1, jwt:"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6MX0.psvcsWpD8k8ToNASO4RsXp6EM0NJhz4fu2gpIN_4V_E"){
    name
  }
}
```
the jwt string can be decrypted to find the uuid of the user who sent this query and depending on either the access level or if the jwt_uuid==query_uuid the amount of data returned from the query can be modified


