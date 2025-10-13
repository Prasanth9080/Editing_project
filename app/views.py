# views.py
import datetime
from django.shortcuts import render, redirect
from django.contrib import messages
from django.contrib.auth import login, logout
from rest_framework_simplejwt.tokens import RefreshToken
from .models import User
import random, string

otp_storage = {}

def generate_otp():
    return ''.join(random.choices(string.digits, k=6))  # 6-digit OTP



# Signup

def signup_view(request):
    if request.method == 'POST':
        name = request.POST.get('username')
        phone = request.POST.get('phone_number')
        email = request.POST.get('email')
        password = request.POST.get('password')

        if " " in name:
            messages.error(request, "Username must not contain spaces")
            return redirect('signup')

        if User.objects.filter(username=name).exists():
            messages.error(request, "Username is already exists")
            return redirect('signup')

        if len(phone) != 10 or not phone.isdigit():
            messages.error(request, "Enter a valid 10-digit phone number")
            return redirect('signup')

        if User.objects.filter(phone_number=phone).exists():
            messages.error(request, "Phone number already registered")
            return redirect('signup')

        if User.objects.filter(email=email).exists():
            messages.error(request, "Email already registered")
            return redirect('signup')

        user = User.objects.create_user(
            username=name,
            email=email, 
            phone_number=phone,
            password=password
        )

        refresh = RefreshToken.for_user(user)
        user.jwt_token = str(refresh.access_token)
        user.save()

        messages.success(request, "Signup successful! Please login.")
        return redirect('login')

    return render(request, 'signup.html')

# change password

from django.contrib.auth.decorators import login_required
from django.contrib.auth import update_session_auth_hash
from django.contrib import messages
from django.shortcuts import render, redirect

@login_required
def change_password_view(request):
    if request.method == 'POST':
        old_password = request.POST.get('old_password')
        new_password1 = request.POST.get('new_password1')
        new_password2 = request.POST.get('new_password2')

        user = request.user

        if not user.check_password(old_password):
            messages.error(request, '❌ Old password is incorrect.')
        elif new_password1 != new_password2:
            messages.error(request, '❌ New passwords do not match.')
        else:
            user.set_password(new_password1)
            user.save()
            update_session_auth_hash(request, user)  # prevent logout
            messages.success(request, '✅ Password changed successfully.')
            return redirect('profile')  # change this to your success page

    return render(request, 'change_password.html')


# password reset through email
# views.py
# views.py
from django.shortcuts import render, redirect
from .forms import CustomPasswordResetForm
from django.contrib import messages
from .forms import CustomPasswordResetForm
from django.contrib import messages

def password_reset_request(request):
    form = CustomPasswordResetForm(request.POST or None)
    form = CustomPasswordResetForm(request.POST or None)
    if request.method == "POST":
        if form.is_valid():
            form.save(
                request=request,
                use_https=False,
                # use_https=False,
                from_email='prasanthchaandhu02@gmail.com',
                email_template_name='password_reset_email.html',
            )
            messages.success(request, "Password reset link sent! Please check your email.")
            messages.success(request, "Password reset link sent! Please check your email.")
            return redirect('password_reset_done')
        else:
            messages.error(request, "Email is not valid. Please enter a valid email address.")
    return render(request, 'password_reset.html', {'form': form})


# Login 

from django.shortcuts import render, redirect
from django.contrib.auth import login
from django.contrib import messages
from .models import User
 
def login_view(request):
    if request.method == 'POST':
        phone = request.POST.get('phone_number')
        password = request.POST.get('password')

        try:
            user = User.objects.get(phone_number=phone)

            if user.check_password(password):
                login(request, user)
                messages.success(request, "Login successful.")
                return redirect('formpage')
            else:
                messages.error(request, "Incorrect password.")
                return redirect('login')

        except User.DoesNotExist:
            messages.error(request, "User with this phone number does not exist.")
            return redirect('login')

    return render(request, 'login.html')


# Phone number

from django.contrib.auth.backends import ModelBackend
from .models import User

class PhoneNumberBackend(ModelBackend):
    def authenticate(self, request, phone_number=None, password=None, **kwargs):
        try:
            user = User.objects.get(phone_number=phone_number)
            if user.check_password(password):
                return user
        except User.DoesNotExist:
            return None


def verify_otp_view(request):
    phone = request.session.get('phone_number')
    if not phone:
        return redirect('login')

    if request.method == 'POST':
        input_otp = request.POST.get('otp')
        expected_otp = otp_storage.get(phone)

        if input_otp == expected_otp:
            try:
                user = User.objects.get(phone_number=phone)
            except User.DoesNotExist:
                messages.error(request, "User not found.")
                return redirect('login')

            login(request, user)

            # Generate access token
            refresh = RefreshToken.for_user(user)
            access_token = str(refresh.access_token)
            request.session['access_token'] = access_token

            response = redirect('formpage')
            response.set_cookie('auth_token', access_token)
            return response
        else:
            messages.error(request, "Invalid OTP.")

    return render(request, 'verify_otp.html')


def logout_view(request):
    logout(request)
    messages.success(request, "Logged out successfully.")
    response = redirect('login')
    response.delete_cookie('jwt_token')
    return response



################ delete option only acccess in main user
################ otherwise normal user delete the record only delete(hide) the paricular role
from django.contrib.auth.decorators import login_required
from django.shortcuts import render, redirect
from django.contrib import messages
from django.contrib.auth import get_user_model
from .models import MyKYC, SubKYC, BondImage

User = get_user_model()


@login_required
def form_page(request):
    user = request.user
    user_id = request.GET.get("user_id")
    show_all = request.GET.get("all")  # ✅ Detect "All Data"
    selected_user = None

    hidden_my_kyc_ids = request.session.get("hidden_my_kyc", [])
    hidden_sub_kyc_ids = request.session.get("hidden_sub_kyc", [])

    # ===============================
    # ✅ Handle ALL DATA (Main/Sub only)
    # ===============================
    if show_all and (user.is_main_user or user.is_sub_mainuser):
        my_kyc_list = MyKYC.objects.all().exclude(id__in=hidden_my_kyc_ids)
        sub_kyc_list = SubKYC.objects.all().exclude(id__in=hidden_sub_kyc_ids)
        selected_user = None  # No specific user selected

    else:
        # ===============================
        # ✅ Main/Sub user selecting one user
        # ===============================
        if user.is_main_user or user.is_sub_mainuser:
            if user_id:
                try:
                    selected_user = User.objects.get(id=user_id)
                except User.DoesNotExist:
                    messages.error(request, "Selected user does not exist.")
                    return redirect("formpage")

                my_kyc_list = MyKYC.objects.filter(
                    user=selected_user
                ).exclude(id__in=hidden_my_kyc_ids)

                sub_kyc_list = (
                    SubKYC.objects.filter(user=selected_user)
                    | SubKYC.objects.filter(created_by=selected_user)
                ).exclude(id__in=hidden_sub_kyc_ids).distinct()

            else:
                # Default: main/sub user’s own KYC data
                selected_user = user
                my_kyc_list = MyKYC.objects.filter(
                    user=user
                ).exclude(id__in=hidden_my_kyc_ids)

                sub_kyc_list = SubKYC.objects.filter(user=user).exclude(
                    id__in=hidden_sub_kyc_ids
                )

        # ===============================
        # ✅ Normal user (non main/sub)
        # ===============================
        else:
            selected_user = user
            my_kyc_list = MyKYC.objects.filter(
                user=user
            ).exclude(id__in=hidden_my_kyc_ids)

            sub_kyc_list = SubKYC.objects.filter(user=user).exclude(
                id__in=hidden_sub_kyc_ids
            )

    # List of users for dropdown (only visible to main/sub users)
    users = (
        User.objects.filter(is_superuser=False, is_main_user=False, is_sub_mainuser=False)
        .exclude(id=user.id)
    )

    # ===============================
    # ✅ Handle POST (KYC submission)
    # ===============================
    if request.method == "POST":
        # Basic KYC fields
        kyc_data = {
            "membershipno": request.POST.get("membershipno"),
            "membershiptype": request.POST.get("membershiptype"),
            "depositorsname": request.POST.get("depositorsname"),
            "depositorsmailid": request.POST.get("depositorsmailid"),
            "depositorsaddress": request.POST.get("depositorsaddress"),
            "bondholdername": request.POST.get("bondholdername"),
            "depositormobile_number": request.POST.get("depositormobile_number"),
            "agentname": request.POST.get("agentname"),
            "agentmobnum": request.POST.get("agentmobnum"),
            # "agentmailid": request.POST.get("agentmailid"),
            # "agentaddress": request.POST.get("agentaddress"),
            "nameofdirector": request.POST.get("nameofdirector"),
            "aadhar_number": request.POST.get("aadhar_number"),
            "pan_number": request.POST.get("pan_number"),
            "ration_number": request.POST.get("ration_number"),
            "bankname": request.POST.get("bankname"),
            "bankaccno": request.POST.get("bankaccno"),
            "ifscno": request.POST.get("ifscno"),
        }

        # File uploads
        # kyc_data["aadhar_front_image"] = request.FILES.get("aadhar_front_image")
        # kyc_data["aadhar_back_image"] = request.FILES.get("aadhar_back_image")
        if request.FILES.get("aadhar_front_image"):
            kyc_data["aadhar_front_image"] = request.FILES["aadhar_front_image"]
        if request.FILES.get("aadhar_back_image"):
            kyc_data["aadhar_back_image"] = request.FILES["aadhar_back_image"]
        # kyc_data["passportphoto"] = request.FILES.get("passportphoto")

        # Bond details
        bond_entries = []
        index = 0
        while True:
            company_key = f"companyname_{index}"
            if company_key not in request.POST:
                break
            bond_entries.append(
                {
                    "bondholdername": request.POST.get(f"bondholdername_{index}"),
                    "bond_image": request.FILES.getlist("bonds")[index]
                    if len(request.FILES.getlist("bonds")) > index
                    else None,
                    "company_name": request.POST.get(company_key),
                    "project_name": request.POST.get(f"projectname_{index}"),
                    "amount": request.POST.get(f"amount_{index}"),
                    "investment_date": request.POST.get(f"investment_date_{index}"),
                    "customer_id": request.POST.get(f"customer_id_{index}"),
                    "dateofresale": request.POST.get(f"dateofresale_{index}"),
                    "agentid": request.POST.get(f"agentid_{index}"),
                    "tokennum": request.POST.get(f"tokennum_{index}"),
                    "remarks": request.POST.get(f"remarks_{index}"),
                    "bondimagetype": request.POST.get(f"bondimagetype_{index}"),
                }
            )
            index += 1

        # Determine KYC type
        is_sub_kyc = "is_sub_kyc" in request.POST
        data_for_user = user
        if is_sub_kyc and (user.is_main_user or user.is_sub_mainuser):
            try:
                data_for_user = User.objects.get(id=request.POST.get("data_for_user"))
            except User.DoesNotExist:
                messages.error(request, "Invalid user selected.")
                return redirect("formpage")

        # Validation
        if not kyc_data["depositorsname"] or not kyc_data["aadhar_number"]:
            messages.error(request, "Depositor's name and Aadhar number are required.")
            return redirect("formpage")

        # Save KYC
        if is_sub_kyc:
            kyc_obj = SubKYC.objects.create(created_by=user, user=data_for_user, **kyc_data)
        else:
            kyc_obj = MyKYC.objects.create(user=user, created_for_user=data_for_user, **kyc_data)

        # Save bonds
        for bond in bond_entries:
            BondImage.objects.create(
                sub_kyc=kyc_obj if is_sub_kyc else None,
                my_kyc=kyc_obj if not is_sub_kyc else None,
                bondholdername=bond["bondholdername"],
                image=bond["bond_image"],
                company_name=bond["company_name"],
                project_name=bond["project_name"],
                amount=bond["amount"],
                investment_date=bond["investment_date"],
                customer_id=bond["customer_id"],
                dateofresale=bond["dateofresale"],
                agentid=bond["agentid"],
                tokennum=bond["tokennum"],
                remarks=bond["remarks"],
                bondimagetype=bond["bondimagetype"],
            )

        messages.success(request, "KYC submitted successfully.")
        return redirect("formpage")

    return render(
        request,
        "formpage.html",
        {
            "users": users,
            "my_kyc_list": my_kyc_list,
            "sub_kyc_list": sub_kyc_list,
            "is_sub_mainuser": user.is_sub_mainuser,
            "is_main_user": user.is_main_user,
            "selected_user": selected_user,
            "show_all": show_all,  # 👈 used in template
        },
    )


from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from .models import MyKYC, SubKYC, BondImage
import datetime  # ✅ import the module

def parse_date_safe(date_str):
    """Parse a date string safely from DD-MM-YYYY or YYYY-MM-DD."""
    if not date_str:
        return None
    for fmt in ("%d-%m-%Y", "%d.%m.%Y", "%d.%m.%Y"):
        try:
            return datetime.datetime.strptime(date_str, fmt).date()  # ✅ explicit
        except ValueError:
            continue
    raise ValueError("Invalid date format (use DD-MM-YYYY or YYYY-MM-DD)")


@login_required
def edit_kyc(request, kyc_id, kyc_type):
    if kyc_type == "my":
        kyc = get_object_or_404(MyKYC, id=kyc_id)
    else:
        kyc = get_object_or_404(SubKYC, id=kyc_id)

    # Only creator or main user can edit
    if not (request.user.is_main_user or request.user == kyc.created_by):
        messages.error(request, "You are not authorized to edit this entry.")
        return redirect("formpage")

    if request.method == "POST":
        # -------- Update KYC text fields ---------------
        kyc.membershipno = request.POST.get("membershipno")
        kyc.depositorsname = request.POST.get("depositorsname")
        kyc.depositorsmailid = request.POST.get("depositorsmailid")
        kyc.depositorsaddress = request.POST.get("depositorsaddress")
        kyc.bondholdername = request.POST.get("bondholdername")
        kyc.depositormobile_number = request.POST.get("depositormobile_number")
        kyc.aadhar_number = request.POST.get("aadhar_number")
        kyc.pan_number = request.POST.get("pan_number")
        kyc.ration_number = request.POST.get("ration_number")
        kyc.bankname = request.POST.get("bankname")
        kyc.bankaccno = request.POST.get("bankaccno")
        kyc.ifscno = request.POST.get("ifscno")
        kyc.agentname = request.POST.get("agentname")
        kyc.agentmobnum = request.POST.get("agentmobnum")
        # kyc.agentmailid = request.POST.get("agentmailid")
        # kyc.agentaddress = request.POST.get("agentaddress")
        kyc.nameofdirector = request.POST.get("nameofdirector")

        # File fields — update only if a new file is uploaded
        if request.FILES.get("aadhar_front_image"):
            kyc.aadhar_front_image = request.FILES["aadhar_front_image"]
        if request.FILES.get("aadhar_back_image"):
            kyc.aadhar_back_image = request.FILES["aadhar_back_image"]

        # Update existing bonds
        bond_ids = request.POST.getlist("bond_id")
        for bond_id in bond_ids:
            try:
                bond = BondImage.objects.get(id=bond_id)
            except BondImage.DoesNotExist:
                continue

            bond.bondholdername = request.POST.get(f"bondholdername_{bond_id}", "")
            new_image = request.FILES.get(f"bond_image_{bond_id}")
            if new_image:
                bond.image = new_image

            bond.companyname = request.POST.get(f"companyname_{bond_id}", "")
            bond.projectname = request.POST.get(f"projectname_{bond_id}", "")
            bond.amount = request.POST.get(f"amount_{bond_id}") or 0
            bond.customer_id = request.POST.get(f"customer_id_{bond_id}", "")
            bond.agentid = request.POST.get(f"agentid_{bond_id}", "")
            bond.tokennum = request.POST.get(f"tokennum_{bond_id}", "")
            bond.remarks = request.POST.get(f"remarks_{bond_id}", "")
            bond.bondimagetype = request.POST.get(f"bondimagetype_{bond_id}", "")

            # Validate & parse investment date
            investment_date_str = request.POST.get(f"investment_date_{bond_id}", "")
            try:
                bond.investment_date = parse_date_safe(investment_date_str)
            except ValueError as e:
                messages.error(request, str(e))
                return redirect("formpage")

            # Validate & parse resale date
            resale_date_str = request.POST.get(f"dateofresale_{bond_id}", "")
            try:
                bond.dateofresale = parse_date_safe(resale_date_str) if resale_date_str else None
            except ValueError as e:
                messages.error(request, str(e))
                return redirect("formpage")

            bond.save()

        # Delete selected bond images
        delete_ids = request.POST.getlist("delete_bonds")
        for bond_id in delete_ids:
            bond = BondImage.objects.filter(id=bond_id).first()
            if bond:
                if bond.image:
                    bond.image.delete(save=False)
                bond.delete()

        # Add new bond images
        new_bondholder_names = request.POST.getlist("new_bondholdername")
        new_bond_files = request.FILES.getlist("new_bonds")
        new_company_names = request.POST.getlist("new_companyname")
        new_project_names = request.POST.getlist("new_projectname")
        new_amounts = request.POST.getlist("new_amount")
        new_dates = request.POST.getlist("new_investment_date")
        new_customer_ids = request.POST.getlist("new_customer_id")
        new_dateresale = request.POST.getlist("new_dateofresale")
        new_agentids = request.POST.getlist("new_agentid")
        new_tokennums = request.POST.getlist("new_tokennum")
        new_remark = request.POST.getlist("remarks")
        new_bondimagetypes = request.POST.getlist("new_bondimagetype")

        for i, bond_img in enumerate(new_bond_files):
            try:
                investment_date = parse_date_safe(new_dates[i]) if i < len(new_dates) else None
            except ValueError as e:
                messages.error(request, str(e))
                return redirect("formpage")

            try:
                resale_date = parse_date_safe(new_dateresale[i]) if i < len(new_dateresale) and new_dateresale[i] else None
            except ValueError as e:
                messages.error(request, str(e))
                return redirect("formpage")

            bond_data = {
                "bondholdername": new_bondholder_names[i] if i < len(new_bondholder_names) else "",
                "image": bond_img,
                "companyname": new_company_names[i] if i < len(new_company_names) else "",
                "projectname": new_project_names[i] if i < len(new_project_names) else "",
                "amount": new_amounts[i] if i < len(new_amounts) else 0,
                "investment_date": investment_date,
                "customer_id": new_customer_ids[i] if i < len(new_customer_ids) else "",
                "dateofresale": resale_date,
                "agentid": new_agentids[i] if i < len(new_agentids) else "",
                "tokennum": new_tokennums[i] if i < len(new_tokennums) else "",
                "remarks": new_remark[i] if i < len(new_remark) else "",
                "bondimagetype": new_bondimagetypes[i] if i < len(new_bondimagetypes) else "",
            }

            if kyc_type == "my":
                BondImage.objects.create(my_kyc=kyc, **bond_data)
            else:
                BondImage.objects.create(sub_kyc=kyc, **bond_data)

        kyc.save()
        messages.success(request, "KYC updated successfully.")
        return redirect("formpage")

    return render(request, "edit_kyc.html", {"kyc": kyc, "kyc_type": kyc_type})



# views.py
from django.shortcuts import get_object_or_404, redirect
from django.contrib import messages
from .models import MyKYC, SubKYC
from django.contrib.auth.decorators import login_required

@login_required
def delete_kyc(request, kyc_id, kyc_type):
    if kyc_type == "my":
        kyc = get_object_or_404(MyKYC, id=kyc_id)
        key = "hidden_my_kyc"
    elif kyc_type == "sub":
        kyc = get_object_or_404(SubKYC, id=kyc_id)
        key = "hidden_sub_kyc"
    else:
        messages.error(request, "Invalid KYC type.")
        return redirect("formpage")

    if not (request.user.is_main_user or request.user == kyc.created_by):
        messages.error(request, "You are not authorized to delete this entry.")
        return redirect("formpage")

    if request.user.is_main_user:
        kyc.delete()
        messages.success(request, "KYC permanently deleted.")
    else:
        # Track deleted IDs in session
        hidden_ids = request.session.get(key, [])
        if kyc_id not in hidden_ids:
            hidden_ids.append(kyc_id)
        request.session[key] = hidden_ids
        messages.success(request, "KYC removed from your view.")

    return redirect("formpage")


import openpyxl
from django.http import HttpResponse
from django.contrib.auth.decorators import login_required
from django.utils.dateformat import format as date_format
from django.contrib.auth import get_user_model
from .models import MyKYC, SubKYC


@login_required
def download_kyc_excel(request, kyc_type):
    workbook = openpyxl.Workbook()
    sheet = workbook.active
    sheet.title = "KYC Details"

    headers = [
        'S.No', 'Membership No', 'Depositor Head of the Family Name', 'Depositor Mail ID', 'Depositor Address',
        'Depositor Mobile Number', 'Aadhar Number',
        'PAN Number', 'Ration Number', 'Aadhar Front Image URL', 'Aadhar Back Image URL',
        'Bank Name', 'Bank A/C No', 'IFSC No', 'Agent Name', 'Agent Mobile Number', 'Name of Director',
        'Bond S.No','Bond Holder Name', 'Image URL', 'Company Name', 'Project Name',
        'Deposit Amount',
        'Investment Date', 'Date of Resale', 'Customer ID', 'Agent ID', 'Token No.', 'Remarks', 'Bond in Hand Original or Xerox'
    ]
    sheet.append(headers)

    user = request.user
    all_flag = str(request.GET.get("all", "")).lower() in ("1", "true", "yes", "on")
    user_id = request.GET.get("user_id")

    # helper: check model has field
    def has_field(model, fieldname):
        return fieldname in [f.name for f in model._meta.get_fields()]

    # Select queryset in the same way your table does
    if kyc_type == "my":
        # MyKyc selection
        if all_flag and getattr(user, "is_main_user", False):
            kyc_qs = MyKYC.objects.all()
        elif getattr(user, "is_main_user", False) and user_id:
            # main user requested specific user
            try:
                selected_user = User.objects.get(pk=user_id)
            except User.DoesNotExist:
                selected_user = user
            if has_field(MyKYC, "user"):
                kyc_qs = MyKYC.objects.filter(user=selected_user)
            elif has_field(MyKYC, "created_by"):
                kyc_qs = MyKYC.objects.filter(created_by=selected_user)
            else:
                kyc_qs = MyKYC.objects.none()
        else:
            # default -> current user's own records
            if has_field(MyKYC, "user"):
                kyc_qs = MyKYC.objects.filter(user=user)
            elif has_field(MyKYC, "created_by"):
                kyc_qs = MyKYC.objects.filter(created_by=user)
            else:
                kyc_qs = MyKYC.objects.none()
    else:
        # subkyc selection
        if all_flag and getattr(user, "is_main_user", False):
            kyc_qs = SubKYC.objects.all()
        elif getattr(user, "is_main_user", False) and user_id:
            try:
                selected_user = User.objects.get(pk=user_id)
            except User.DoesNotExist:
                selected_user = user
            if has_field(SubKYC, "user"):
                kyc_qs = SubKYC.objects.filter(user=selected_user)
            elif has_field(SubKYC, "created_by"):
                kyc_qs = SubKYC.objects.filter(created_by=selected_user)
            else:
                kyc_qs = SubKYC.objects.none()
        else:
            if has_field(SubKYC, "user"):
                kyc_qs = SubKYC.objects.filter(user=user)
            elif has_field(SubKYC, "created_by"):
                kyc_qs = SubKYC.objects.filter(created_by=user)
            else:
                kyc_qs = SubKYC.objects.none()

    # Exclude hidden IDs
    hidden_ids_key = 'hidden_my_kyc' if kyc_type == 'my' else 'hidden_sub_kyc'
    hidden_ids = request.session.get(hidden_ids_key, [])
    if hidden_ids:
        kyc_qs = kyc_qs.exclude(id__in=hidden_ids)

    def safe_attr(obj, *names, default=""):
        for n in names:
            v = getattr(obj, n, None)
            if v is not None:
                return v
        return default
    

    for idx, kyc in enumerate(kyc_qs, start=1):
        # Safe URL fetch
        aadhar_front_url = safe_attr(kyc, "aadhar_front_image")
        aadhar_front_url = getattr(aadhar_front_url, "url", "") if aadhar_front_url else ""
        aadhar_back_url = safe_attr(kyc, "aadhar_back_image")
        aadhar_back_url = getattr(aadhar_back_url, "url", "") if aadhar_back_url else ""
        # passport_url = safe_attr(kyc, "passportphoto")
        # passport_url = getattr(passport_url, "url", "") if passport_url else ""

        base_row = [
            idx,
            safe_attr(kyc, "membershipno", default=""),
            safe_attr(kyc, "depositorsname", default=""),
            safe_attr(kyc, "depositorsmailid", default=""),
            safe_attr(kyc, "depositorsaddress", default=""),
            safe_attr(kyc, "depositormobile_number", default=""),
            safe_attr(kyc, "aadhar_number", default=""),
            safe_attr(kyc, "pan_number", default=""),
            safe_attr(kyc, "ration_number", default=""),
            aadhar_front_url,
            aadhar_back_url,
            # passport_url,
            safe_attr(kyc, "bankname", default=""),
            safe_attr(kyc, "bankaccno", default=""),
            safe_attr(kyc, "ifscno", default=""),
            safe_attr(kyc, "agentname", default=""),
            safe_attr(kyc, "agentmobnum", default=""),
            # safe_attr(kyc, "agentmailid", default=""),
            # safe_attr(kyc, "agentaddress", default=""),
            safe_attr(kyc, "nameofdirector", default=""),
        ]
        sheet.append(base_row + [''] * 7)  # empty bond columns

        # bonds (support both companyname/company_name & projectname/project_name)
        bonds = getattr(kyc, "bonds", None)
        if bonds is None:
            # some models might use different related_name, try common ones
            if hasattr(kyc, "bondimage_set"):
                bonds = kyc.bondimage_set
        if bonds:
            for b_i, bond in enumerate(bonds.all(), start=1):
                bond_img = getattr(bond, "image", None)
                bond_img_url = getattr(bond_img, "url", "") if bond_img else ""
                company = safe_attr(bond, "companyname", "company_name", default="")
                project = safe_attr(bond, "projectname", "project_name", default="")
                inv = getattr(bond, "investment_date", None)
                resale = getattr(bond, "dateofresale", None)
                date_str = inv.strftime('%d-%m-%Y') if inv else ""
                date_str2 = resale.strftime('%d-%m-%Y') if resale else ""
                sheet.append(
                    [""] * 18 + [
                        b_i,
                        safe_attr(bond, "bondholdername", default=""),
                        bond_img_url,
                        company,
                        project,
                        safe_attr(bond, "amount", default=""),
                        # date_format(getattr(bond, "investment_date", None), "d-m-Y") if getattr(bond, "investment_data", None) else "",
                        date_str,
                        date_str2,
                        safe_attr(bond, "customer_id", default=""),
                        safe_attr(bond, "agentid", default=""),
                        safe_attr(bond, "tokennum", default=""),
                        safe_attr(bond, "remarks", default=""),
                        safe_attr(bond, "bondimagetype", default="")
                    ]
                )

    # Response
    response = HttpResponse(
        content_type='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    )
    # filename logic: all -> uses all flag, else indicate type/user
    if all_flag and getattr(user, "is_main_user", False):
        filename = f"all_{kyc_type}_kyc.xlsx"
    elif user_id:
        filename = f"user_{user_id}_{kyc_type}_kyc.xlsx"
    else:
        filename = f"{user.username}_{kyc_type}_kyc.xlsx"
    response['Content-Disposition'] = f'attachment; filename="{filename}"'
    workbook.save(response)
    return response



# pdf download

from reportlab.lib.pagesizes import A4
from reportlab.platypus import SimpleDocTemplate, Table, TableStyle, Paragraph, Spacer, Image
from reportlab.lib.styles import getSampleStyleSheet
from reportlab.lib import colors
from reportlab.lib.units import mm
from django.http import HttpResponse
from django.contrib.auth.decorators import login_required
from django.contrib.auth import get_user_model
from django.utils.dateformat import format as date_format
import os
from .models import MyKYC, SubKYC

User = get_user_model()


@login_required
def download_kyc_pdf(request, kyc_type):
    response = HttpResponse(content_type='application/pdf')
    user = request.user

    # --- filtering params ---
    all_flag = str(request.GET.get("all", "")).lower() in ("1", "true", "yes", "on")
    user_id = request.GET.get("user_id")

    # filename logic
    if all_flag and getattr(user, "is_main_user", False):
        filename = f"all_{kyc_type}_kyc.pdf"
    elif user_id:
        filename = f"user_{user_id}_{kyc_type}_kyc.pdf"
    else:
        filename = f"{user.username}_{kyc_type}_kyc.pdf"
    response['Content-Disposition'] = f'attachment; filename="{filename}"'

    # PDF setup
    doc = SimpleDocTemplate(response, pagesize=A4)
    elements = []
    styles = getSampleStyleSheet()
    title = Paragraph("KYC Details", styles['Heading1'])
    elements.append(title)
    elements.append(Spacer(1, 5 * mm))

    # helper: check field exists
    def has_field(model, fieldname):
        return fieldname in [f.name for f in model._meta.get_fields()]

    # --- Queryset logic ---
    if kyc_type == "my":
        if all_flag and getattr(user, "is_main_user", False):
            kyc_qs = MyKYC.objects.all()
        elif getattr(user, "is_main_user", False) and user_id:
            try:
                selected_user = User.objects.get(pk=user_id)
            except User.DoesNotExist:
                selected_user = user
            if has_field(MyKYC, "user"):
                kyc_qs = MyKYC.objects.filter(user=selected_user)
            elif has_field(MyKYC, "created_by"):
                kyc_qs = MyKYC.objects.filter(created_by=selected_user)
            else:
                kyc_qs = MyKYC.objects.none()
        else:
            if has_field(MyKYC, "user"):
                kyc_qs = MyKYC.objects.filter(user=user)
            elif has_field(MyKYC, "created_by"):
                kyc_qs = MyKYC.objects.filter(created_by=user)
            else:
                kyc_qs = MyKYC.objects.none()
    else:
        if all_flag and getattr(user, "is_main_user", False):
            kyc_qs = SubKYC.objects.all()
        elif getattr(user, "is_main_user", False) and user_id:
            try:
                selected_user = User.objects.get(pk=user_id)
            except User.DoesNotExist:
                selected_user = user
            if has_field(SubKYC, "user"):
                kyc_qs = SubKYC.objects.filter(user=selected_user)
            elif has_field(SubKYC, "created_by"):
                kyc_qs = SubKYC.objects.filter(created_by=selected_user)
            else:
                kyc_qs = SubKYC.objects.none()
        else:
            if has_field(SubKYC, "user"):
                kyc_qs = SubKYC.objects.filter(user=user)
            elif has_field(SubKYC, "created_by"):
                kyc_qs = SubKYC.objects.filter(created_by=user)
            else:
                kyc_qs = SubKYC.objects.none()

    # Exclude hidden IDs
    hidden_ids_key = 'hidden_my_kyc' if kyc_type == 'my' else 'hidden_sub_kyc'
    hidden_ids = request.session.get(hidden_ids_key, [])
    if hidden_ids:
        kyc_qs = kyc_qs.exclude(id__in=hidden_ids)

    # Helper safe getter
    def safe_attr(obj, *names, default=""):
        for n in names:
            v = getattr(obj, n, None)
            if v not in (None, ""):
                return v
        return default

    # Helper for safe images
    def safe_image(field, width=20*mm, height=15*mm):
        if field and hasattr(field, "path") and os.path.exists(field.path):
            return Image(field.path, width=width, height=height)
        return "—"

    # --- Loop through records ---
    for idx, kyc in enumerate(kyc_qs, start=1):
        record_heading = Paragraph(f"MyKYC Record {idx}", styles['Heading2'])
        elements.append(record_heading)
        elements.append(Spacer(1, 3 * mm))

        main_table_data = [
            ["S.No", str(idx)],
            ["Membership No", safe_attr(kyc, "membershipno")],
            ["Depositor Head of the family Name", safe_attr(kyc, "depositorsname")],
            ["Depositor Mail ID", safe_attr(kyc, "depositorsmailid")],
            ["Depositor Address", safe_attr(kyc, "depositorsaddress")],
            ["Mobile", safe_attr(kyc, "depositormobile_number")],
            ["Aadhar Number", safe_attr(kyc, "aadhar_number")],
            ["PAN Number", safe_attr(kyc, "pan_number")],
            ["Ration Number", safe_attr(kyc, "ration_number")],
            ["Aadhar Front", safe_image(getattr(kyc, "aadhar_front_image", None))],
            ["Aadhar Back", safe_image(getattr(kyc, "aadhar_back_image", None))],
            # ["Passport Photo", safe_image(getattr(kyc, "passportphoto", None), width=20*mm, height=25*mm)],
            ["Bank Name", safe_attr(kyc, "bankname")],
            ["Bank A/C No", safe_attr(kyc, "bankaccno")],
            ["IFSC No", safe_attr(kyc, "ifscno")],
            ["Agent Name", safe_attr(kyc, "agentname")],
            ["Agent Mobile Number", safe_attr(kyc, "agentmobnum")],
            # ["Agent Mail ID", safe_attr(kyc, "agentmailid")],
            # ["Agent Address", safe_attr(kyc, "agentaddress")],
            ["Name of Director", safe_attr(kyc, "nameofdirector")],
        ]

        main_table = Table(main_table_data, colWidths=[50*mm, 110*mm])
        main_table.setStyle(TableStyle([
            ('FONTNAME', (0, 0), (-1, -1), 'Helvetica'),
            ('FONTSIZE', (0, 0), (-1, -1), 8),
            ('ALIGN', (0, 0), (0, -1), 'LEFT'),
            ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
            ('ROWBACKGROUNDS', (0, 0), (-1, -1), [colors.whitesmoke, colors.lightyellow]),
            ('BOX', (0, 0), (-1, -1), 0.25, colors.black),
            ('INNERGRID', (0, 0), (-1, -1), 0.25, colors.grey),
        ]))
        elements.append(main_table)
        elements.append(Spacer(1, 5 * mm))

        ######################################################
        # Bond Section
        ######################################################
        bonds = getattr(kyc, "bonds", None)
        if bonds is None and hasattr(kyc, "bondimage_set"):
            bonds = kyc.bondimage_set

        if bonds and bonds.exists():
            elements.append(Paragraph("Bond Details", styles['Heading3']))
            elements.append(Spacer(1, 2 * mm))

            # bond_table_data = [["S.No", "Bond Holder Name", "Company Name", "Project Name", "Deposit Amount",
            #                     "Investment Date", "Date of Resale", "Customer ID", "Token No.", "Bond in Hand Original or Xerox"]]
            for b_i, bond in enumerate(bonds.all(), start=1):
                elements.append(Paragraph(f"Bond Record {b_i}", styles['Heading4']))
                elements.append(Spacer(1, 1 * mm))

                bond_table_data = [
                    ["S.No", str(b_i)],
                    ["Bond Holder Name", safe_attr(bond, "bondholdername")],
                    ["Company Name", safe_attr(bond, "companyname", "company_name")],
                    ["Project Name", safe_attr(bond, "projectname", "project_name")],
                    ["Deposit Name", safe_attr(bond, "amount")],
                    ["Investment Date", date_format(getattr(bond, "investment_date", None), "d-m-Y") if getattr(bond, "investment_date", None) else ""],
                    ["Date of Resale", date_format(getattr(bond, "dateofresale", None), "d-m-Y") if getattr(bond, "dateofresale", None) else ""],
                    ["Customer ID", safe_attr(bond, "customer_id")],
                    ["Token No.", safe_attr(bond, "tokennum")],
                    ["Bond in Hand", safe_attr(bond, "bondimagetype")],
                    ["Remarks", safe_attr(bond, "remarks")],
                ]

                # include bond image inline if present
                bond_image_field = getattr(bond, "image", None)
                if bond_image_field:
                    img = safe_image(bond_image_field, width=30*mm, height=25*mm)
                    bond_table_data.append(["Bond Image", img])

                bond_table = Table(bond_table_data, colWidths=[50*mm, 110*mm])
                bond_table.setStyle(TableStyle([
                    ('FONTNAME', (0, 0), (-1, -1), 'Helvetica'),
                    ('FONTSIZE', (0, 0), (-1, -1), 8),
                    ('ALIGN', (0, 0), (0, -1), 'LEFT'),
                    ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
                    ('ROWBACKGROUNDS', (0, 0), (-1, -1), [colors.whitesmoke, colors.lightcyan]),
                    ('BOX', (0, 0), (-1, -1), 0.25, colors.black),
                    ('INNERGRID', (0, 0), (-1, -1), 0.25, colors.grey),
                    ('TOPPADDING', (0, 0), (-1, -1), 4),
                    ('BOTTOMPADDING', (0, 0), (-1, -1), 4),
                ]))

                elements.append(bond_table)
                elements.append(Spacer(1, 8 * mm))

    doc.build(elements)
    return response



################################################################
# subkyc excel and pdf

from django.shortcuts import render
from django.http import HttpResponse
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from .models import MyKYC, SubKYC, BondImage
from django.contrib.auth import get_user_model

from reportlab.lib.pagesizes import A4
from reportlab.pdfgen import canvas
from reportlab.lib import colors
from reportlab.lib.units import mm

import openpyxl
from openpyxl.styles import Font, Alignment

User = get_user_model()


@login_required
def download_subkyc_pdf(request):
    response = HttpResponse(content_type='application/pdf')
    response['Content-Disposition'] = 'attachment; filename="sub_kyc_report.pdf"'

    c = canvas.Canvas(response, pagesize=A4)
    W, H = A4
    margin = 20 * mm
    card_width = W - 2 * margin
    card_height = 60 * mm
    x0 = margin
    y = H - margin

    c.setFont("Helvetica-Bold", 18)
    c.drawCentredString(W / 2, y, "Sub-KYC Report")
    y -= 15 * mm

    user = request.user
    hidden_sub_kyc_ids = request.session.get('hidden_sub_kyc', [])

    if user.is_superuser or user.is_main_user:
        kyc_list = SubKYC.objects.filter(created_by=user) | SubKYC.objects.filter(user=user)
    else:
        kyc_list = SubKYC.objects.filter(user=user)

    kyc_list = kyc_list.exclude(id__in=hidden_sub_kyc_ids).distinct()

    for idx, kyc in enumerate(kyc_list, 1):
        if y - card_height < margin:
            c.showPage()
            y = H - margin
            c.setFont("Helvetica-Bold", 18)
            c.drawCentredString(W / 2, y, "Sub-KYC Report")
            y -= 15 * mm

        c.setLineWidth(1)
        c.roundRect(x0, y - card_height, card_width, card_height, 5 * mm, stroke=1, fill=0)

        header_h = 10 * mm
        c.setFillColor(colors.lightgrey)
        c.roundRect(x0, y - header_h, card_width, header_h, 5 * mm, stroke=0, fill=1)
        c.setFillColor(colors.black)
        c.setFont("Helvetica-Bold", 12)
        c.drawString(x0 + 5 * mm, y - header_h + 2 * mm, f"Sub-KYC #{idx}")

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



@login_required
def download_subkyc_excel(request):
    response = HttpResponse(content_type='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
    response['Content-Disposition'] = 'attachment; filename="sub_kyc_report.xlsx"'

    wb = openpyxl.Workbook()
    ws = wb.active
    ws.title = "Sub-KYC Report"

    headers = [
        "Name", "Father's Name", "Mobile", "Aadhar",
        "Address", "Profession", "Contact SH",
        "Name SH", "Investment"
    ]
    ws.append(headers)

    header_font = Font(bold=True)
    for cell in ws[1]:
        cell.font = header_font
        cell.alignment = Alignment(horizontal='center')

    user = request.user
    hidden_sub_kyc_ids = request.session.get('hidden_sub_kyc', [])

    if user.is_superuser or user.is_main_user:
        kyc_list = SubKYC.objects.filter(created_by=user) | SubKYC.objects.filter(user=user)
    else:
        kyc_list = SubKYC.objects.filter(user=user)

    kyc_list = kyc_list.exclude(id__in=hidden_sub_kyc_ids).distinct()

    for kyc in kyc_list:
        ws.append([
            kyc.name,
            kyc.fathername or "",
            kyc.mobile_number,
            kyc.aadhar_number,
            kyc.address,
            kyc.profession or "",
            kyc.contactSH or "",
            kyc.nameSH or "",
            kyc.investmentamt if kyc.investmentamt else 0,
        ])

    wb.save(response)
    return response



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



from django.contrib.auth.decorators import login_required
from django.shortcuts import redirect
from django.contrib import messages
import datetime

from .models import MyKYC, BondImage, User


@login_required
def add_my_kyc(request):
    if request.method == "POST":
        created_by = request.user

        # Validate selected user
        try:
            data_for_user = User.objects.get(id=request.POST.get('data_for_user'))
        except User.DoesNotExist:
            messages.error(request, "Invalid user selected.")
            return redirect("formpage")

        # Convert numeric fields safely
        def to_int(val):
            try:
                return int(val) if val else None
            except ValueError:
                return None

        # Parse date safely (YYYY-MM-DD expected from <input type="date">)
        def parse_date_safe(date_str):
            if not date_str:
                return datetime.date.today()
            try:
                return datetime.datetime.strptime(date_str, "%Y-%m-%d").date()
            except ValueError:
                return datetime.date.today()

        my_kyc = MyKYC.objects.create(
            user=data_for_user,
            created_by=created_by,
            membershipno=to_int(request.POST.get('membershipno')),
            depositorsname=request.POST.get('depositorsname'),
            depositorsmailid=request.POST.get('depositorsmailid'),
            depositorsaddress=request.POST.get('depositorsaddress'),
            bondholdername=request.POST.get('bondholdername'),
            depositormobile_number=request.POST.get('depositormobile_number'),
            agentname=request.POST.get('agentname'),
            agentmobnum=request.POST.get('agentmobnum'),
            # agentmailid=request.POST.get('agentmailid'),
            # agentaddress=request.POST.get('agentaddress'),
            nameofdirector=request.POST.get('nameofdirector'),
            aadhar_number=request.POST.get('aadhar_number'),
            pan_number=request.POST.get('pan_number'),
            ration_number=request.POST.get('ration_number'),
            bankname=request.POST.get('bankname'),
            bankaccno=request.POST.get('bankaccno'),
            ifscno=request.POST.get('ifscno'),
            aadhar_front_image=request.FILES.get('aadhar_front_image'),
            aadhar_back_image=request.FILES.get('aadhar_back_image'),
        )

        # Save bond images and related data
        bond_files = request.FILES.getlist('bonds')
        for i, bond_file in enumerate(bond_files):
            BondImage.objects.create(
                my_kyc=my_kyc,
                bondholdername=request.POST.get(f'bondholdername_{i}'),
                image=bond_file,
                companyname=request.POST.get(f'companyname_{i}'),
                projectname=request.POST.get(f'projectname_{i}'),
                amount=to_int(request.POST.get(f'amount_{i}')) or 0,
                investment_date=parse_date_safe(request.POST.get(f'investment_date_{i}')),
                customer_id=request.POST.get(f'customer_id_{i}'),
                dateofresale=parse_date_safe(request.POST.get(f'dateofresale_{i}')),
                agentid=request.POST.get(f'agentid_{i}'),
                tokennum=request.POST.get(f'tokennum_{i}'),
                remarks=request.POST.get(f'remarks_{i}'),
                bondimagetype=request.POST.get(f'bondimagetype_{i}')
            )

        messages.success(request, "My KYC data saved successfully.")
        return redirect('formpage')


from django.contrib.auth.decorators import login_required
from django.shortcuts import redirect
from django.contrib import messages
from .models import SubKYC, BondImage, User

@login_required
def add_other_kyc(request):
    if request.method == "POST":
        created_by = request.user

        try:
            data_for_user = User.objects.get(id=request.POST.get('data_for_user'))
        except User.DoesNotExist:
            messages.error(request, "Invalid user selected.")
            return redirect("formpage")

        try:
            investmentamt = int(request.POST.get('investmentamt')) if request.POST.get('investmentamt') else None
        except ValueError:
            messages.error(request, "Investment amount must be numeric.")
            return redirect("formpage")

        kyc = SubKYC.objects.create(
            user=data_for_user,
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
            investmentamt=investmentamt,
            aadhar_front_image=request.FILES.get('aadhar_front_image'),
            aadhar_back_image=request.FILES.get('aadhar_back_image'),
            passportphoto=request.FILES.get('passportphoto'),
        )

        for bond_file in request.FILES.getlist('bonds'):
            BondImage.objects.create(sub_kyc=kyc, image=bond_file)  # ✅ FIXED HERE

        messages.success(request, "Sub-KYC added successfully.")
        return redirect('formpage')

