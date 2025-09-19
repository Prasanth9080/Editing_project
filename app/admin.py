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
        'ifscno', 'aadhar_front_image', 'aadhar_back_image', 'agentname', 'agentmobnum', 'agentmailid', 'agentaddress', 'nameofdirector', 'created_by'
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
from django.utils.html import format_html

@admin.register(BondImage)
class BondImageAdmin(admin.ModelAdmin):
    list_display = (
        'id','username', 'image_tag', 'my_kyc', 'sub_kyc',
        'companyname', 'projectname', 'amount', 'dateofresale', 'tokennum','remarks',
        'investment_date', 'customer_id', 'bondimagetype', 'bondholdername', 'agentid',
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
        if obj.image:
            return format_html('<img src="{}" style="width: 100px; height: auto;" />', obj.image.url)
        return "-"

