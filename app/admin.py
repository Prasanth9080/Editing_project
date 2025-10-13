from django.contrib import admin
from .models import User,MyKYC,BondImage,SubKYC

@admin.register(User)
class UserAdmin(admin.ModelAdmin):
    list_display = ('username', 'email', 'phone_number','is_main_user', 'date_joined', 'last_login', 'jwt_token')
    list_filter = ('is_main_user','is_sub_mainuser') 
    search_fields = ('username', 'phone_number', 'email')


# ----------------------------------------
# Admin for MyKYC
# ----------------------------------------
from django.contrib import admin
from .models import MyKYC

@admin.register(MyKYC)
class MyKYCAdmin(admin.ModelAdmin):
    list_display = (
        'membershipno', 'depositorsname', 'depositorsmailid', 'depositorsaddress', 'depositormobile_number',
        'aadhar_number', 'pan_number', 'ration_number', 'bankname', 'bankaccno',
        'ifscno', 'aadhar_front_image', 'aadhar_back_image', 'agentname', 'agentmobnum', 'nameofdirector', 'created_by'
    )
    search_fields = (
        'depositorsname', 'bondholdername',
        'depositormobile_number', 'aadhar_number', 'pan_number'
    )
    list_filter = ('created_by',)

# ----------------------------------------
# Admin for SubKYC
# ----------------------------------------
@admin.register(SubKYC)
class SubKYCAdmin(admin.ModelAdmin):
    list_display = ('name', 'created_by', 'name', 'age', 'fathername',
                    'mobile_number', 'aadhar_number','aadhar_front_image','aadhar_back_image','address',
                    'profession','contactSH','nameSH','investmentamt','passportphoto')
    search_fields = ('name', 'mobile_number', 'aadhar_number')
    list_filter = ('created_by',)

# ----------------------------------------
# Admin for BondImage (optional, direct access)
# ----------------------------------------
from django.contrib import admin
from django.utils.html import format_html
from .models import BondImage  # make sure the import is correct


@admin.register(BondImage)
class BondImageAdmin(admin.ModelAdmin):
    list_display = (
        'username', 'image_tag',
        'companyname', 'projectname', 'amount', 'dateofresale', 'tokennum', 'remarks',
        'investment_date', 'customer_id', 'bondholdername', 'agentid',
    )
    search_fields = ('companyname', 'projectname', 'customer_id')
    list_filter = ('investment_date', 'companyname')

    @admin.display(ordering='my_kyc__user__username', description='Username')
    def username(self, obj):
        if obj.my_kyc:
            return obj.my_kyc.user.username
        elif obj.sub_kyc:
            return obj.sub_kyc.user.username
        return '-'

    @admin.display(description='Image')
    def image_tag(self, obj):
        if obj.image and hasattr(obj.image, 'url'):
            return format_html(
                '<img src="{}" style="max-width: 120px; max-height: 120px; border: 1px solid #ccc; border-radius: 5px;" />',
                obj.image.url
            )
        return "-"

