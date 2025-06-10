

from django.contrib import admin
from .models import User,KycDetails

@admin.register(User)
class UserAdmin(admin.ModelAdmin):
    list_display = ('username', 'email', 'phone_number','is_main_user', 'date_joined', 'last_login', 'jwt_token')
    list_filter = ('is_main_user',)
    search_fields = ('username', 'phone_number', 'email')

@admin.register(KycDetails)
class KycDetailsAdmin(admin.ModelAdmin):
    list_display = ("name","mobile_number","aadhar_number","aadhar_image","pan_number","pan_image","created_at")



# from django.contrib import admin
# from django.contrib.auth.admin import UserAdmin
# from .models import User, KycDetails

# class CustomUserAdmin(UserAdmin):
#     fieldsets = UserAdmin.fieldsets + (
#         ('Extra Info', {'fields': ('phone_number', 'jwt_token', 'is_main_user')}),
#     )

# admin.site.register(User, CustomUserAdmin)
# admin.site.register(KycDetails)
