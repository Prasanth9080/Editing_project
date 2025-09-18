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
from django.utils import timezone

User = get_user_model()

class MyKYC(models.Model):
    MEMBERSHIP_CHOICES = [
        ('senior', 'Senior'),
        ('junior', 'Junior')
    ]
    BOND_IMAGE_TYPE_CHOICES = [
        ('original', 'Original'),
        ('xerox', 'Xerox'),
    ]

    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="my_kycs", null=True, blank=True)
    created_by = models.ForeignKey(User, on_delete=models.CASCADE, related_name="created_my_kycs", null=True, blank=True)

    membershipno = models.IntegerField(null=True, blank=True)
    depositorsname = models.CharField(max_length=100, blank=True)
    depositorsmailid = models.EmailField(max_length=100, blank=True)
    depositorsaddress = models.TextField(blank=True)
    bondholdername = models.CharField(max_length=100, blank=True, null=True)
    depositormobile_number = models.CharField(max_length=15, blank=True)
    agentname = models.CharField(max_length=100, blank=True)
    agentmobnum = models.CharField(max_length=15, blank=True)  # good for international numbers
    agentmailid = models.EmailField(max_length=100, blank=True)
    agentaddress = models.TextField(blank=True)
    nameofdirector = models.CharField(max_length=100, blank=True)
    aadhar_number = models.CharField(max_length=20, null=True, blank=True)
    pan_number = models.CharField(max_length=20, blank=True)
    ration_number = models.CharField(max_length=20, blank=True)
    bankname = models.CharField(max_length=100, blank=True)
    bankaccno = models.CharField(max_length=20, blank=True)
    ifscno = models.CharField(max_length=50, blank=True)
    aadhar_front_image = models.ImageField(upload_to='kyc/aadhar/', null=True, blank=True)
    aadhar_back_image = models.ImageField(upload_to='kyc/aadhar/', null=True, blank=True)  # fixed path from 'pan/' to 'aadhar/'
    

    def __str__(self):
        return f"MyKYC - {self.depositorsname}"  # fixed wrong attribute 'self.name'

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
    BOND_IMAGE_TYPE_CHOICES = [
        ('original', 'Original'),
        ('xerox', 'Xerox'),
    ]
    my_kyc = models.ForeignKey("MyKYC", on_delete=models.CASCADE, null=True, blank=True, related_name='bonds')
    sub_kyc = models.ForeignKey("SubKYC", on_delete=models.CASCADE, null=True, blank=True, related_name='bonds')
    bondholdername = models.CharField(max_length=100, blank=True, null=True)
    image = models.ImageField(upload_to='bonds/')
    companyname = models.CharField(max_length=100,)
    projectname = models.CharField(max_length=100,)
    investment_date = models.DateField(default=datetime.date.today)  # ✅ CORRECT DEFAULT
    customer_id = models.CharField(max_length=10,)
    amount = models.IntegerField(null=True, blank=True, default=0)
    dateofresale = models.DateField(default=datetime.date.today)
    agentid = models.IntegerField(max_length=10,blank=True, default=0)
    tokennum = models.IntegerField(null=True, blank=True, default=0)
    remarks = models.CharField(max_length=250, blank=True)
    bondimagetype = models.CharField(max_length=50, choices=BOND_IMAGE_TYPE_CHOICES, null=True, blank=True)

    def __str__(self):
        return f"BondImage ({self.image.name})"

