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
