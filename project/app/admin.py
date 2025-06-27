from django.contrib import admin
from .models import User,KycDetailsNew,BondImage

@admin.register(User)
class UserAdmin(admin.ModelAdmin):
    list_display = ('username', 'email', 'phone_number','is_main_user', 'date_joined', 'last_login', 'jwt_token')
    list_filter = ('is_main_user','is_sub_mainuser') 
    search_fields = ('username', 'phone_number', 'email')

@admin.register(KycDetailsNew)
class KycDetailsAdmin(admin.ModelAdmin):
    list_display = ("name","age","mobile_number","aadhar_number","aadhar_image","pan_image","address","fathername","profession","contactSH","nameSH","investmentamt","passportphoto")
    list_filter = ('created_by',)
    search_fields = ('name', 'mobile_number', 'created_by__username', 'user__username')

@admin.register(BondImage)
class BondImageAdmin(admin.ModelAdmin):
    list_display = ['id', 'kyc', 'image']
    search_fields = ['kyc__name']

# from django.contrib import admin
# from django.contrib.auth.admin import UserAdmin
# from .models import User, KycDetailsNew

# class CustomUserAdmin(UserAdmin):
#     fieldsets = UserAdmin.fieldsets + (
#         ('Extra Info', {'fields': ('phone_number', 'jwt_token', 'is_main_user')}),
#     )

# admin.site.register(User, CustomUserAdmin)
# admin.site.register(KycDetailsNew)
