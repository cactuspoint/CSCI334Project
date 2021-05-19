import os
from flask import request
from werkzeug.utils import secure_filename

uploads_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'uploads')
os.makedirs(uploads_dir, exist_ok=True)

def file_upload():
    if request.method == 'POST':
        print("uploading file")
        f = request.files['file']
        f.save(os.path.join(uploads_dir, secure_filename(f.filename)))
        return 'file uploaded successfully'