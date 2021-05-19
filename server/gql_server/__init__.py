__version__ = '0.1.0'

import os
#from . file_handling import file_upload

UPLOAD_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'uploads')
os.makedirs(UPLOAD_DIR, exist_ok=True)
os.makedirs(os.path.join(UPLOAD_DIR, 'images'), exist_ok=True)
os.makedirs(os.path.join(UPLOAD_DIR, 'logs'), exist_ok=True)
