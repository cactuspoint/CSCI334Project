import pathlib
import os
from flask import Flask, request, send_from_directory
from flask_graphql import GraphQLView
from werkzeug.utils import secure_filename
from . models import db_session
from . schema import schema
from . import UPLOAD_DIR

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
            if pathlib.Path(f.filename).suffix == '.png':
                f.save(os.path.join(os.path.join(UPLOAD_DIR, 'images'), secure_filename(f.filename)))
                return 'file uploaded successfully'
            elif pathlib.Path(f.filename).suffix == '.db':
                f.save(os.path.join(os.path.join(UPLOAD_DIR, 'logs'), secure_filename(f.filename)))
                return 'file uploaded successfully'
            else:
                # if not png of db wrong file type
                return 'bad request!', 400
    @app.route('/download/<path:filename>', methods=['GET', 'POST'])
    def index(filename):
        if request.method == 'GET':
            return send_from_directory(UPLOAD_DIR, filename)
    @app.teardown_appcontext
    def shutdown_session(exception=None):
        db_session.remove()
    return app
