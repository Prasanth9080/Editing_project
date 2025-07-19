from django.contrib.auth.models import AbstractUser
from django.db import models
from django.utils import timezone

class User(AbstractUser):
    phone_number = models.CharField(max_length=15, unique=True)
    jwt_token = models.CharField(max_length=500, blank=True, null=True)
    is_main_user = models.BooleanField(default=False)  # 🔐 Add this
    is_sub_mainuser = models.BooleanField(default=False)
    parent_user = models.ForeignKey('self', on_delete=models.SET_NULL, null=True, blank=True, related_name='children')

    def __str__(self):
        return self.username

### another file models

from django.db import models
from django.contrib.auth import get_user_model

User = get_user_model()

class MyKYC(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="my_kycs", default='')
    created_by = models.ForeignKey(User, on_delete=models.CASCADE, related_name="created_my_kycs")
    name = models.CharField(max_length=100)
    age = models.IntegerField(null=True, blank=True)
    fathername = models.CharField(max_length=100)
    mobile_number = models.CharField(max_length=15)
    aadhar_number = models.CharField(max_length=20, null=True, blank=True)
    aadhar_front_image = models.ImageField(upload_to='aadhar/', null=True, blank=True)
    aadhar_back_image = models.ImageField(upload_to='pan/', null=True, blank=True)
    address = models.TextField()
    profession = models.CharField(max_length=100, null=True, blank=True)
    contactSH = models.CharField(max_length=100, null=True, blank=True)
    nameSH = models.CharField(max_length=100, null=True, blank=True)
    investmentamt = models.IntegerField(null=True, blank=True)
    passportphoto = models.ImageField(upload_to='passport/', null=True, blank=True)
    is_hidden = models.BooleanField(default=False)

    def __str__(self):
        return f"MyKYC - {self.name}"


# -----------------------------
# Model 2: SubKYC (Sub KYC)
# -----------------------------
class SubKYC(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="sub_kycs", default='')
    created_by = models.ForeignKey(User, on_delete=models.CASCADE, related_name='sub_kycs_created')
    name = models.CharField(max_length=100)
    age = models.IntegerField()
    mobile_number = models.CharField(max_length=15)
    fathername = models.CharField(max_length=100)
    address = models.TextField()
    aadhar_number = models.CharField(max_length=20)
    aadhar_front_image = models.ImageField(upload_to='sub_aadhar_front/', blank=True, null=True)
    aadhar_back_image = models.ImageField(upload_to='sub_aadhar_back/', blank=True, null=True)
    profession = models.CharField(max_length=100)
    contactSH = models.CharField(max_length=100)
    nameSH = models.CharField(max_length=100)
    investmentamt = models.DecimalField(max_digits=12, decimal_places=2)
    passportphoto = models.ImageField(upload_to='sub_passport_photos/', blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    is_hidden = models.BooleanField(default=False)

    def __str__(self):
        return f"SubKYC: {self.name}"

# -----------------------------
# Common Model: Bond Images
# -----------------------------
from decimal import Decimal
import datetime
from django.db import models

class BondImage(models.Model):
    my_kyc = models.ForeignKey("MyKYC", on_delete=models.CASCADE, null=True, blank=True, related_name='bonds')
    sub_kyc = models.ForeignKey("SubKYC", on_delete=models.CASCADE, null=True, blank=True, related_name='bonds')
    image = models.ImageField(upload_to='bonds/')
    companyname = models.CharField(max_length=100,)
    projectname = models.CharField(max_length=100,)
    investment_date = models.DateField(default=datetime.date.today)  # ✅ CORRECT DEFAULT
    customer_id = models.CharField(max_length=10,)
    amount = models.IntegerField(null=True, blank=True, default=0)

    def __str__(self):
        return f"BondImage ({self.image.name})"

