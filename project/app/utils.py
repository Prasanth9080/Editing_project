import random
import string

def generate_otp(length=5):
    return ''.join(random.choices(string.ascii_letters + string.digits, k=length))