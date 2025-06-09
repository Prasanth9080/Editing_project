from django.contrib.auth.models import AbstractUser
from django.db import models

class User(AbstractUser):
    phone_number = models.CharField(max_length=15, unique=True)
    jwt_token = models.CharField(max_length=500, blank=True, null=True)
    is_main_user = models.BooleanField(default=False)  # 🔐 Add this


    def __str__(self):
        return self.username

### another file models

class KycDetails(models.Model):
    name = models.CharField(max_length=100)
    mobile_number = models.CharField(max_length=15)
    aadhar_number = models.CharField(max_length=20)
    aadhar_image = models.ImageField(upload_to='kyc/aadhar/')
    pan_number = models.CharField(max_length=20)
    pan_image = models.ImageField(upload_to='kyc/pan/')

    def __str__(self):
        return self.name