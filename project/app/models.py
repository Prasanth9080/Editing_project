from django.contrib.auth.models import AbstractUser
from django.db import models
from django.utils import timezone

class User(AbstractUser):
    phone_number = models.CharField(max_length=15, unique=True)
    jwt_token = models.CharField(max_length=500, blank=True, null=True)
    is_main_user = models.BooleanField(default=False)  # 🔐 Add this
    is_sub_mainuser = models.BooleanField(default=False)

    def __str__(self):
        return self.username

### another file models

from django.db import models
from django.utils import timezone
from django.conf import settings

class KycDetailsNew(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, null=True, blank=True)
    name = models.CharField(max_length=100)
    age = models.IntegerField(null=True, blank=True)
    fathername = models.CharField(max_length=100, default="")
    mobile_number = models.CharField(max_length=15)
    aadhar_number = models.CharField(max_length=20)
    aadhar_image = models.ImageField(upload_to='kyc/aadhar/')
    pan_image = models.ImageField(upload_to='kyc/pan/')
    is_hidden = models.BooleanField(default=False)
    address = models.CharField(max_length=250, default="")
    profession = models.CharField(max_length=100, blank=True)
    contactSH = models.CharField(max_length=100, blank=True)
    nameSH = models.CharField(max_length=100, blank=True)
    investmentamt = models.IntegerField(null=True, blank=True)
    passportphoto = models.ImageField(upload_to='kyc/passport_photo/')

    def __str__(self):
        return self.name

class BondImage(models.Model):
    kyc = models.ForeignKey(KycDetailsNew, related_name='bonds', on_delete=models.CASCADE)
    image = models.ImageField(upload_to='kyc/bonds/')
