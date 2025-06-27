# views.py
from django.shortcuts import get_object_or_404, render, redirect
from django.contrib import messages
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from rest_framework_simplejwt.tokens import RefreshToken
from .models import User
import random, string

otp_storage = {}

def generate_otp():
    return ''.join(random.choices(string.ascii_letters + string.digits, k=7))


from django.shortcuts import render, redirect
from django.contrib import messages
from django.contrib.auth.models import BaseUserManager
from rest_framework_simplejwt.tokens import RefreshToken

from .models import User  # your custom user model

def signup_view(request):
    if request.method == 'POST':
        name = request.POST.get('username')
        phone = request.POST.get('phone_number')
        email = request.POST.get('email')

        # Server-side validation
        if len(phone) != 10 or not phone.isdigit():
            messages.error(request, "Enter a valid 10-digit phone number")
            return redirect('signup')

        if User.objects.filter(phone_number=phone).exists():
            messages.error(request, "Phone number already registered")
            return redirect('signup')

        if User.objects.filter(email=email).exists():
            messages.error(request, "Email already registered")
            return redirect('signup')

        # Generate random password using BaseUserManager
        # random_password = BaseUserManager().make_random_password()

        # Create user
        user = User.objects.create_user(
            username=name,
            email=email,
            phone_number=phone,
            # password=random_password
        )

        # Generate JWT token
        refresh = RefreshToken.for_user(user)
        user.jwt_token = str(refresh.access_token)
        user.save()

        messages.success(request, "Signup successful! Please login.")
        return redirect('login')

    return render(request, 'signup.html')



def login_view(request):
    if request.method == 'POST':
        phone = request.POST.get('phone_number')
        try:
            user = User.objects.get(phone_number=phone)
            if not user.jwt_token:
                messages.error(request, "Invalid token")
                return redirect('login')
            otp = generate_otp()
            otp_storage[phone] = otp
            print(f"\U0001F511 OTP for {phone}: {otp}")
            request.session['phone_number'] = phone
            messages.success(request, "OTP sent")
            return redirect('verify_otp')
        except User.DoesNotExist:
            messages.error(request, "Please SignUp your number")
    return render(request, 'login.html')

def verify_otp_view(request):
    phone = request.session.get('phone_number')
    if not phone:
        return redirect('login')

    if request.method == 'POST':
        input_otp = request.POST.get('otp')
        if otp_storage.get(phone) == input_otp:
            user = User.objects.get(phone_number=phone)
            login(request, user)
            refresh = RefreshToken.for_user(user)
            access_token = str(refresh.access_token)
            request.session['access_token'] = access_token
            # response = redirect('dashboard')
            response = redirect('formpage')
            response.set_cookie('auth_token', access_token)
            return response
        else:
            messages.error(request, "OTP is not valid")
    return render(request, 'verify_otp.html')


# @login_required
# def dashboard_view(request):
#     # return render(request, 'dashboard.html')
#     return render(request, 'formpage.html')

def logout_view(request):
    logout(request)
    messages.success(request, "Logged out successfully.")
    response = redirect('login')
    response.delete_cookie('jwt_token')
    return response




############# for formpage functionalities  deleted for for all user

# from django.shortcuts import render, redirect, get_object_or_404
# from .models import KycDetailsNew, User
# from django.contrib.auth.decorators import login_required
# from django.contrib import messages

# @login_required
# def form_page(request):
#     user = request.user

#     # Show all data to main user, or only their own data
#     if user.is_main_user:
#         kyc_list = KycDetailsNew.objects.all()
#     else:
#         kyc_list = KycDetailsNew.objects.filter(user=user)

#     if request.method == "POST":
#         name = request.POST.get('name')
#         mobile = request.POST.get('mobile_number')
#         aadhar = request.POST.get('aadhar_number')
#         pan = request.POST.get('pan_number')
#         aadhar_img = request.FILES.get('aadhar_image')
#         pan_img = request.FILES.get('pan_image')

#         if not all([name, mobile, aadhar, pan, aadhar_img, pan_img]):
#             messages.error(request, "All fields are required.")
#         else:
#             KycDetailsNew.objects.create(
#                 user=user,
#                 name=name,
#                 mobile_number=mobile,
#                 aadhar_number=aadhar,
#                 pan_number=pan,
#                 aadhar_image=aadhar_img,
#                 pan_image=pan_img
#             )
#             messages.success(request, "KYC submitted successfully.")
#             return redirect("formpage")

#     return render(request, "formpage.html", {"kyc_list": kyc_list})


# @login_required
# def edit_kyc(request, kyc_id):
#     kyc = get_object_or_404(KycDetailsNew, id=kyc_id)

#     if not (request.user.is_main_user or request.user == kyc.user):
#         messages.error(request, "You are not authorized.")
#         return redirect("formpage")

#     if request.method == "POST":
#         kyc.name = request.POST.get('name')
#         kyc.mobile_number = request.POST.get('mobile_number')
#         kyc.aadhar_number = request.POST.get('aadhar_number')
#         kyc.pan_number = request.POST.get('pan_number')

#         if request.FILES.get('aadhar_image'):
#             kyc.aadhar_image = request.FILES['aadhar_image']
#         if request.FILES.get('pan_image'):
#             kyc.pan_image = request.FILES['pan_image']

#         kyc.save()
#         messages.success(request, "KYC updated successfully.")
#         return redirect("formpage")

#     return render(request, "edit_kyc.html", {"kyc": kyc})


# @login_required
# def delete_kyc(request, kyc_id):
#     kyc = get_object_or_404(KycDetailsNew, id=kyc_id)

#     if not (request.user.is_main_user or request.user == kyc.user):
#         messages.error(request, "You are not authorized.")
#     else:
#         kyc.delete()
#         messages.success(request, "KYC deleted.")

#     return redirect("formpage")



################ delete option only acccess in main user
################ otherwise normal user delete the record only delete(hide) the paricular role

from django.shortcuts import render, redirect
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from .models import KycDetailsNew, User, BondImage
from django.contrib.auth import get_user_model

User = get_user_model()

@login_required
def form_page(request):
    user = request.user
    selected_user = None
    user_id = request.GET.get('user_id')

    # If a main or sub-main user selected someone from sidebar
    if user.is_main_user or user.is_sub_mainuser:
        if user_id:
            try:
                selected_user = User.objects.get(id=user_id)
            except User.DoesNotExist:
                selected_user = None

    if selected_user:
        # Show all entries created by selected_user
        my_kyc_list = KycDetailsNew.objects.filter(user=selected_user, created_by=selected_user, is_hidden=False)
        sub_kyc_list = KycDetailsNew.objects.filter(created_by=selected_user).exclude(user=selected_user).filter(is_hidden=False)
    else:
        # Normal view based on logged-in user
        my_kyc_list = KycDetailsNew.objects.filter(user=user, created_by=user, is_hidden=False)
        sub_kyc_list = KycDetailsNew.objects.filter(created_by=user).exclude(user=user).filter(is_hidden=False)

    # All non-super users for dropdown and sidebar
    users = User.objects.filter(is_superuser=False, is_main_user=False, is_sub_mainuser=False).exclude(id=user.id)

    # Show all visible KYC entries (for overview if needed)
    kyc_list = KycDetailsNew.objects.filter(is_hidden=False) if (user.is_main_user or user.is_sub_mainuser) else []
    if request.method == "POST":
        name = request.POST.get('name')
        age = request.POST.get('age')
        fathername = request.POST.get('fathername')
        mobile = request.POST.get('mobile_number')
        aadhar = request.POST.get('aadhar_number')
        aadhar_img = request.FILES.get('aadhar_image')
        pan_img = request.FILES.get('pan_image')
        address = request.POST.get('address')
        profession = request.POST.get('profession')
        contactSH = request.POST.get('contactSH')
        nameSH = request.POST.get('nameSH')
        investmentamt = request.POST.get('investmentamt')
        passportphoto = request.FILES.get('passportphoto')
        bonds = request.FILES.getlist('bonds')

        # 👇 Determine for whom the KYC is created
        data_for_user = user  # default
        if user.is_main_user or user.is_sub_mainuser:
            data_for_user_id = request.POST.get('data_for_user')
            try:
                data_for_user = User.objects.get(id=data_for_user_id)
            except User.DoesNotExist:
                messages.error(request, "Invalid user selected.")
                return redirect("formpage")

        # Validate required fields
        if not all([name, mobile, aadhar, aadhar_img, pan_img, address]):
            messages.error(request, "All required fields must be filled.")
        else:
            try:
                investmentamt = int(investmentamt) if investmentamt else None
            except ValueError:
                messages.error(request, "Investment amount must be a number.")
                return redirect("formpage")

            kyc = KycDetailsNew.objects.create(
                user=data_for_user,               # who the KYC is about
                created_by=user,                 # who is creating the KYC
                name=name,
                age=age,
                fathername=fathername,
                mobile_number=mobile,
                aadhar_number=aadhar,
                aadhar_image=aadhar_img,
                pan_image=pan_img,
                address=address,
                profession=profession,
                contactSH=contactSH,
                nameSH=nameSH,
                investmentamt=investmentamt,
                passportphoto=passportphoto,
            )

            for bond_img in bonds:
                BondImage.objects.create(kyc=kyc, image=bond_img)

            messages.success(request, "KYC submitted successfully.")
            return redirect("formpage")

    return render(request, "formpage.html", {
        "kyc_list": kyc_list,
        "users": users,
        "my_kyc_list": my_kyc_list,
        "sub_kyc_list": sub_kyc_list,
        "is_sub_mainuser": user.is_sub_mainuser,
        "is_main_user": user.is_main_user,
    })




from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from .models import KycDetailsNew, BondImage

@login_required
def edit_kyc(request, kyc_id):
    kyc = get_object_or_404(KycDetailsNew, id=kyc_id)

    # Authorization check
    if not (request.user.is_main_user or request.user == kyc.created_by):
        messages.error(request, "You are not authorized to edit this entry.")
        return redirect("formpage")

    if request.method == "POST":
        name = request.POST.get('name')
        age = request.POST.get('age')
        fathername = request.POST.get('fathername')
        mobile_number = request.POST.get('mobile_number')
        aadhar_number = request.POST.get('aadhar_number')
        address = request.POST.get('address')
        profession = request.POST.get('profession')
        contactSH = request.POST.get('contactSH')
        nameSH = request.POST.get('nameSH')
        investmentamt = request.POST.get('investmentamt')

        # Validate required fields
        if not all([name, fathername, mobile_number, aadhar_number, address, profession]):
            messages.error(request, "All fields are required.")
            return render(request, "edit_kyc.html", {"kyc": kyc})

        # Assign new values
        kyc.name = name
        kyc.age = age
        kyc.fathername = fathername
        kyc.mobile_number = mobile_number
        kyc.aadhar_number = aadhar_number
        kyc.address = address
        kyc.profession = profession
        kyc.contactSH = contactSH
        kyc.nameSH = nameSH
        kyc.investmentamt = investmentamt

        # File updates
        if request.FILES.get('aadhar_image'):
            kyc.aadhar_image = request.FILES['aadhar_image']
        if request.FILES.get('pan_image'):
            kyc.pan_image = request.FILES['pan_image']
        if request.FILES.get('passportphoto'):
            kyc.passportphoto = request.FILES['passportphoto']

        # Handle bond image deletion
        delete_bond_ids = request.POST.getlist('delete_bonds')
        for bond_id in delete_bond_ids:
            bond = BondImage.objects.filter(id=bond_id, kyc=kyc).first()
            if bond:
                bond.image.delete(save=False)  # deletes file from storage
                bond.delete()

        # Handle new bond image uploads
        new_bonds = request.FILES.getlist('bonds')
        for bond_img in new_bonds:
            BondImage.objects.create(kyc=kyc, image=bond_img)

        kyc.save()
        messages.success(request, "KYC updated successfully.")
        return redirect("formpage")

    return render(request, "edit_kyc.html", {"kyc": kyc})



@login_required
def delete_kyc(request, kyc_id):
    kyc = get_object_or_404(KycDetailsNew, id=kyc_id)

    # Authorization check
    if not (request.user.is_main_user or request.user == kyc.created_by):
        messages.error(request, "You are not authorized to delete this entry.")
        return redirect("formpage")

    if request.user.is_main_user:
        # Hard delete
        kyc.delete()
        messages.success(request, "KYC permanently deleted.")
    else:
        # Soft delete
        kyc.is_hidden = True
        kyc.save()
        messages.success(request, "KYC record deleted successfully.")

    return redirect("formpage")



# Download Excel Sheet

import openpyxl
from django.http import HttpResponse
from .models import KycDetailsNew
from django.contrib.auth.decorators import login_required

@login_required
def download_kyc_excel(request):
    workbook = openpyxl.Workbook()
    sheet = workbook.active
    sheet.title = "KYC Details"

    # Headers
    headers = [
        'S.No', 'Name', 'Age', 'Father Name', 'Mobile Number', 'Aadhar Number',
        'Address', 'Profession', 'Contact SH/NH', 'Name SH/NH', 'Investment Amount'
    ]
    sheet.append(headers)

    # Get the same data as shown in the frontend table
    user = request.user
    if user.is_superuser or getattr(user, "is_main_user", False):
        kyc_list = KycDetailsNew.objects.all()
    elif getattr(user, "is_sub_mainuser", False):
        # assuming sub_mainuser sees child users' data
        kyc_list = KycDetailsNew.objects.filter(user__parent=user)
    else:
        kyc_list = KycDetailsNew.objects.filter(user=user)

    # Add rows to Excel
    for idx, kyc in enumerate(kyc_list, start=1):
        sheet.append([
            idx,
            kyc.name,
            kyc.age,
            kyc.fathername,
            kyc.mobile_number,
            kyc.aadhar_number,
            kyc.address,
            kyc.profession,
            kyc.contactSH,
            kyc.nameSH,
            kyc.investmentamt
        ])

    # Return Excel file as HTTP response
    response = HttpResponse(
        content_type='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    )
    response['Content-Disposition'] = 'attachment; filename=kyc_details.xlsx'
    workbook.save(response)
    return response


# Download pdf sheet

from reportlab.lib.pagesizes import A4
from reportlab.pdfgen import canvas
from reportlab.lib import colors
from reportlab.lib.units import mm
from django.http import HttpResponse
from django.contrib.auth.decorators import login_required
from .models import KycDetailsNew

@login_required
def download_kyc_pdf(request):
    response = HttpResponse(content_type='application/pdf')
    response['Content-Disposition'] = 'attachment; filename="kyc_report.pdf"'

    c = canvas.Canvas(response, pagesize=A4)
    W, H = A4
    margin = 20 * mm
    card_width = W - 2 * margin
    card_height = 60 * mm
    x0 = margin
    y = H - margin

    # Title
    c.setFont("Helvetica-Bold", 18)
    c.drawCentredString(W / 2, y, "KYC Report")
    y -= 15 * mm

    # ✅ Filter only what's visible in the table
    user = request.user
    if user.is_superuser or getattr(user, "is_main_user", False):
        kyc_list = KycDetailsNew.objects.all()
    else:
        kyc_list = KycDetailsNew.objects.filter(user=user)

    for idx, kyc in enumerate(kyc_list, 1):
        if y - card_height < margin:
            c.showPage()
            y = H - margin
            c.setFont("Helvetica-Bold", 18)
            c.drawCentredString(W / 2, y, "KYC Report")
            y -= 15 * mm

        # Card border
        c.setLineWidth(1)
        c.roundRect(x0, y - card_height, card_width, card_height, 5 * mm, stroke=1, fill=0)

        # Header band
        header_h = 10 * mm
        c.setFillColor(colors.lightgrey)
        c.roundRect(x0, y - header_h, card_width, header_h, 5 * mm, stroke=0, fill=1)
        c.setFillColor(colors.black)
        c.setFont("Helvetica-Bold", 12)
        c.drawString(x0 + 5 * mm, y - header_h + 2 * mm, f"KYC #{idx}")

        # Two-column field layout
        labels = [
            ("Name", kyc.name),
            ("Father's Name", kyc.fathername or "—"),
            ("Mobile", kyc.mobile_number),
            ("Aadhar", kyc.aadhar_number),
            ("Address", kyc.address),
            ("Profession", kyc.profession or "—"),
            ("Contact SH", kyc.contactSH or "—"),
            ("Name SH", kyc.nameSH or "—"),
            ("Investment", str(kyc.investmentamt) if kyc.investmentamt else "—"),
        ]

        col_x = [x0 + 5 * mm, x0 + card_width / 2 + 5 * mm]
        c.setFont("Helvetica", 10)
        line_h = 6 * mm
        start_y = y - header_h - 5 * mm

        for i, (label, val) in enumerate(labels):
            col = i % 2
            row = i // 2
            text_y = start_y - row * line_h
            c.drawString(col_x[col], text_y, f"{label}: {val}")

        y -= card_height + 5 * mm

    c.save()
    return response




################################################################


################### for profile page functionalities

# from django.contrib.auth.decorators import login_required
# from django.shortcuts import render, redirect
# from django.contrib import messages
# from .models import CustomUser

# @login_required
# def profile_view(request):
#     user = request.user

#     if request.method == 'POST':
#         user.username = request.POST.get('username')
#         user.email = request.POST.get('email')
#         user.phone_number = request.POST.get('phone_number')
#         user.save()
#         messages.success(request, "Profile updated successfully.")
#         return redirect('profile')

#     return render(request, 'profile.html', {'user_obj': user})



@login_required
def profile_view(request):
    user = request.user

    if request.method == 'POST':
        user.username = request.POST['username']
        user.email = request.POST['email']
        user.phone_number = request.POST['phone_number']
        user.save()
        messages.success(request, "Profile updated successfully.")
        return redirect('profile')

    return render(request, 'profile.html', {'user_obj': user})


# from django.contrib.auth.decorators import login_required
# from django.contrib.auth import get_user_model
# from django.shortcuts import render, redirect, get_object_or_404
# from django.contrib import messages
# from .models import KycDetailsNew, BondImage

# User = get_user_model()

# @login_required
# def form_page(request):
#     user = request.user

#     # Show users only if the logged-in user is main or sub main
#     users = []
#     if getattr(user, "is_main_user", False) or getattr(user, "is_sub_mainuser", False):
#         users = User.objects.filter(
#             is_superuser=False,
#             is_main_user=False,
#             is_sub_mainuser=False
#         ).exclude(id=user.id)

#     # KYC data
#     if user.is_superuser or getattr(user, "is_main_user", False):
#         kyc_list = KycDetailsNew.objects.filter(is_hidden=False)
#     elif getattr(user, "is_sub_mainuser", False):
#         kyc_list = KycDetailsNew.objects.filter(is_hidden=False)
#     else:
#         kyc_list = KycDetailsNew.objects.filter(user=user, is_hidden=False)

#     return render(request, "formpage.html", {
#         "kyc_list": kyc_list,
#         "users": users,
#         "is_main_user": getattr(user, 'is_main_user', False),
#         "is_sub_mainuser": getattr(user, 'is_sub_mainuser', False)
#     })


# add_my_kyc and add_sub_kc

@login_required
def add_my_kyc(request):
    if request.method == "POST":
        user = request.user
        try:
            investmentamt = int(request.POST.get('investmentamt')) if request.POST.get('investmentamt') else None
        except ValueError:
            messages.error(request, "Investment amount must be numeric.")
            return redirect('formpage')

        kyc = KycDetailsNew.objects.create(
            user=user,
            created_by=user,
            name=request.POST.get('name'),
            age=request.POST.get('age'),
            fathername=request.POST.get('fathername'),
            mobile_number=request.POST.get('mobile_number'),
            aadhar_number=request.POST.get('aadhar_number'),
            aadhar_image=request.FILES.get('aadhar_image'),
            pan_image=request.FILES.get('pan_image'),
            address=request.POST.get('address'),
            profession=request.POST.get('profession'),
            contactSH=request.POST.get('contactSH'),
            nameSH=request.POST.get('nameSH'),
            investmentamt=investmentamt,
            passportphoto=request.FILES.get('passportphoto'),
        )

        for bond_file in request.FILES.getlist('bonds'):
            BondImage.objects.create(kyc=kyc, image=bond_file)

        messages.success(request, "My KYC data saved successfully.")
        return redirect('formpage')

@login_required
def add_other_kyc(request):
    if request.method == 'POST':
        created_by = request.user

        # Proceed to save the form data
        # Example:
        kyc = KycDetailsNew(
            created_by=created_by,
            name=request.POST.get('name'),
            age=request.POST.get('age'),
            mobile_number=request.POST.get('mobile_number'),
            fathername=request.POST.get('fathername'),
            address=request.POST.get('address'),
            aadhar_number=request.POST.get('aadhar_number'),
            profession=request.POST.get('profession'),
            contactSH=request.POST.get('contactSH'),
            nameSH=request.POST.get('nameSH'),
            investmentamt=request.POST.get('investmentamt'),
            aadhar_image=request.FILES.get('aadhar_image'),
            pan_image=request.FILES.get('pan_image'),
            passportphoto=request.FILES.get('passportphoto'),
        )
        kyc.save()

        messages.success(request, "Sub-KYC added successfully.")
        return redirect('formpage')

