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
@admin.register(MyKYC)
class MyKYCAdmin(admin.ModelAdmin):
    list_display = ('name', 'created_by', 'name', 'age', 'fathername',
                    'mobile_number', 'aadhar_number','aadhar_front_image','aadhar_back_image','address',
                    'profession','contactSH','nameSH','investmentamt','passportphoto')
    search_fields = ('name', 'mobile_number', 'aadhar_number')
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
@admin.register(BondImage)
class BondImageAdmin(admin.ModelAdmin):
    list_display = (
        'id','username', 'image', 'my_kyc', 'sub_kyc',
        'companyname', 'projectname', 'amount',
        'investment_date', 'customer_id'
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
# from django.contrib import admin
# from django.contrib.auth.admin import UserAdmin
# from .models import User, KycDetailsNew

# class CustomUserAdmin(UserAdmin):
#     fieldsets = UserAdmin.fieldsets + (
#         ('Extra Info', {'fields': ('phone_number', 'jwt_token', 'is_main_user')}),
#     )

# admin.site.register(User, CustomUserAdmin)
# admin.site.register(KycDetailsNew)
