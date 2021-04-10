#!/usr/bin/python3

from flask import Flask

from database import session
from flask_graphql import GraphQLView
from schema import schema
from flask_graphql_auth import GraphQLAuth

app = Flask(__name__)

app.config["JWT_SECRET_KEY"] = "secure"
app.config["REFRESH_EXP_LENGTH"] = 30
app.config["ACCESS_EXP_LENGTH"] = 10
app.debug = True

auth = GraphQLAuth(app)

app.add_url_rule('/graphql', view_func=GraphQLView.as_view('graphql', schema=schema, graphiql=True, context={'session': session}))

@app.teardown_appcontext
def shutdown_session(exception=None):
    session.remove()

if __name__ == '__main__':
    app.run()