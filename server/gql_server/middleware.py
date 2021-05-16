"""module for utilizing JWT for authorization of user"""
import jwt

KEY = "secret" # should change in real application

def encrypt_jwt(input_string):
    output_string = jwt.encode({"uuid": input_string}, KEY, algorithm="HS256")
    return output_string

def decrypt_jwt(input_string):
    output_string = ""
    try:
        output_dict = jwt.decode(input_string, KEY, algorithms="HS256")
        output_string = output_dict["uuid"]
    except:
        pass
    return output_string
