__version__ = '0.1.0'

import os
from flask import Flask, request
from flask_graphql import GraphQLView
from werkzeug.utils import secure_filename
from . models import db_session
from . schema import schema
#from . file_handling import file_upload

uploads_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'uploads')
os.makedirs(uploads_dir, exist_ok=True)

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
    @app.route('/upload', methods = ['GET', 'POST'])
    def upload_file():
        if request.method == 'POST':
            f = request.files['file']
            f.save(os.path.join(uploads_dir, secure_filename(f.filename)))
            return 'file uploaded successfully'
    @app.teardown_appcontext
    def shutdown_session(exception=None):
        db_session.remove()
    return app
