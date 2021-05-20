from gql_server import __version__
import requests

def test_version():
    assert __version__ == '0.1.0'

def test_upload_picture():
    with open("./assets/face.png", "rb") as a_file:
        file_dict = {"file": a_file}
        response = requests.post("http://127.0.0.1:5000/upload", files=file_dict)