__version__ = '0.1.0'

from flask import Flask
from flask_graphql import GraphQLView

from . models import db_session
from . schema import schema

def create_server(debug: bool):
    app = Flask(__name__)
    app.debug = debug
    app.add_url_rule(
        '/graphql', 
        view_func=GraphQLView.as_view(
            'graphql', 
            schema=schema, 
            graphiql=True, 
            context={
                'session': db_session
            }
        )
    )
    @app.teardown_appcontext
    def shutdown_session(exception=None):
        db_session.remove()
    return app
