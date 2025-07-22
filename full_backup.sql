BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "django_migrations" (
	"id"	integer NOT NULL,
	"app"	varchar(255) NOT NULL,
	"name"	varchar(255) NOT NULL,
	"applied"	datetime NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "django_content_type" (
	"id"	integer NOT NULL,
	"app_label"	varchar(100) NOT NULL,
	"model"	varchar(100) NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "auth_group_permissions" (
	"id"	integer NOT NULL,
	"group_id"	integer NOT NULL,
	"permission_id"	integer NOT NULL,
	FOREIGN KEY("group_id") REFERENCES "auth_group"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("permission_id") REFERENCES "auth_permission"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "auth_permission" (
	"id"	integer NOT NULL,
	"content_type_id"	integer NOT NULL,
	"codename"	varchar(100) NOT NULL,
	"name"	varchar(255) NOT NULL,
	FOREIGN KEY("content_type_id") REFERENCES "django_content_type"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "auth_group" (
	"id"	integer NOT NULL,
	"name"	varchar(150) NOT NULL UNIQUE,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "app_user_groups" (
	"id"	integer NOT NULL,
	"user_id"	bigint NOT NULL,
	"group_id"	integer NOT NULL,
	FOREIGN KEY("group_id") REFERENCES "auth_group"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("user_id") REFERENCES "app_user"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "app_user_user_permissions" (
	"id"	integer NOT NULL,
	"user_id"	bigint NOT NULL,
	"permission_id"	integer NOT NULL,
	FOREIGN KEY("user_id") REFERENCES "app_user"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("permission_id") REFERENCES "auth_permission"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "django_admin_log" (
	"id"	integer NOT NULL,
	"object_id"	text,
	"object_repr"	varchar(200) NOT NULL,
	"action_flag"	smallint unsigned NOT NULL CHECK("action_flag" >= 0),
	"change_message"	text NOT NULL,
	"content_type_id"	integer,
	"user_id"	bigint NOT NULL,
	"action_time"	datetime NOT NULL,
	FOREIGN KEY("user_id") REFERENCES "app_user"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("content_type_id") REFERENCES "django_content_type"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "app_user" (
	"id"	integer NOT NULL,
	"password"	varchar(128) NOT NULL,
	"last_login"	datetime,
	"is_superuser"	bool NOT NULL,
	"username"	varchar(150) NOT NULL UNIQUE,
	"first_name"	varchar(150) NOT NULL,
	"last_name"	varchar(150) NOT NULL,
	"email"	varchar(254) NOT NULL,
	"is_staff"	bool NOT NULL,
	"is_active"	bool NOT NULL,
	"date_joined"	datetime NOT NULL,
	"phone_number"	varchar(15) NOT NULL UNIQUE,
	"jwt_token"	varchar(500),
	"is_main_user"	bool NOT NULL,
	"is_sub_mainuser"	bool NOT NULL,
	"parent_user_id"	bigint,
	FOREIGN KEY("parent_user_id") REFERENCES "app_user"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "django_session" (
	"session_key"	varchar(40) NOT NULL,
	"session_data"	text NOT NULL,
	"expire_date"	datetime NOT NULL,
	PRIMARY KEY("session_key")
);
CREATE TABLE IF NOT EXISTS "token_blacklist_blacklistedtoken" (
	"blacklisted_at"	datetime NOT NULL,
	"token_id"	bigint NOT NULL UNIQUE,
	"id"	integer NOT NULL,
	FOREIGN KEY("token_id") REFERENCES "token_blacklist_outstandingtoken"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "token_blacklist_outstandingtoken" (
	"token"	text NOT NULL,
	"created_at"	datetime,
	"expires_at"	datetime NOT NULL,
	"user_id"	bigint,
	"jti"	varchar(255) NOT NULL UNIQUE,
	"id"	integer NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "app_user"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "app_subkyc" (
	"id"	integer NOT NULL,
	"name"	varchar(100) NOT NULL,
	"age"	integer NOT NULL,
	"mobile_number"	varchar(15) NOT NULL,
	"fathername"	varchar(100) NOT NULL,
	"address"	text NOT NULL,
	"aadhar_number"	varchar(20) NOT NULL,
	"aadhar_front_image"	varchar(100),
	"aadhar_back_image"	varchar(100),
	"profession"	varchar(100) NOT NULL,
	"contactSH"	varchar(100) NOT NULL,
	"nameSH"	varchar(100) NOT NULL,
	"investmentamt"	decimal NOT NULL,
	"passportphoto"	varchar(100),
	"created_at"	datetime NOT NULL,
	"created_by_id"	bigint NOT NULL,
	"user_id"	bigint NOT NULL,
	"is_hidden"	bool NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("created_by_id") REFERENCES "app_user"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("user_id") REFERENCES "app_user"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "app_mykyc" (
	"id"	integer NOT NULL,
	"name"	varchar(100) NOT NULL,
	"age"	integer,
	"fathername"	varchar(100) NOT NULL,
	"mobile_number"	varchar(15) NOT NULL,
	"address"	text NOT NULL,
	"profession"	varchar(100),
	"contactSH"	varchar(100),
	"nameSH"	varchar(100),
	"investmentamt"	integer,
	"passportphoto"	varchar(100),
	"is_hidden"	bool NOT NULL,
	"created_by_id"	bigint NOT NULL,
	"user_id"	bigint NOT NULL,
	"aadhar_back_image"	varchar(100),
	"aadhar_front_image"	varchar(100),
	"aadhar_number"	varchar(20),
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("created_by_id") REFERENCES "app_user"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("user_id") REFERENCES "app_user"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "app_bondimage" (
	"id"	integer NOT NULL,
	"image"	varchar(100) NOT NULL,
	"companyname"	varchar(100),
	"projectname"	varchar(100),
	"customer_id"	varchar(10),
	"my_kyc_id"	bigint,
	"sub_kyc_id"	bigint,
	"amount"	integer,
	"investment_date"	date,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("sub_kyc_id") REFERENCES "app_subkyc"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("my_kyc_id") REFERENCES "app_mykyc"("id") DEFERRABLE INITIALLY DEFERRED
);
INSERT INTO "django_migrations" ("id","app","name","applied") VALUES (1,'contenttypes','0001_initial','2025-07-01 06:14:43.567567'),
 (2,'contenttypes','0002_remove_content_type_name','2025-07-01 06:14:43.581842'),
 (3,'auth','0001_initial','2025-07-01 06:14:43.606469'),
 (4,'auth','0002_alter_permission_name_max_length','2025-07-01 06:14:43.623208'),
 (5,'auth','0003_alter_user_email_max_length','2025-07-01 06:14:43.631718'),
 (6,'auth','0004_alter_user_username_opts','2025-07-01 06:14:43.641386'),
 (7,'auth','0005_alter_user_last_login_null','2025-07-01 06:14:43.654318'),
 (8,'auth','0006_require_contenttypes_0002','2025-07-01 06:14:43.657646'),
 (9,'auth','0007_alter_validators_add_error_messages','2025-07-01 06:14:43.670105'),
 (10,'auth','0008_alter_user_username_max_length','2025-07-01 06:14:43.718584'),
 (11,'auth','0009_alter_user_last_name_max_length','2025-07-01 06:14:43.725134'),
 (12,'auth','0010_alter_group_name_max_length','2025-07-01 06:14:43.740798'),
 (13,'auth','0011_update_proxy_permissions','2025-07-01 06:14:43.751777'),
 (14,'auth','0012_alter_user_first_name_max_length','2025-07-01 06:14:43.759612'),
 (15,'app','0001_initial','2025-07-01 06:14:43.785646'),
 (16,'admin','0001_initial','2025-07-01 06:14:43.813955'),
 (17,'admin','0002_logentry_remove_auto_add','2025-07-01 06:14:43.834112'),
 (18,'admin','0003_logentry_add_action_flag_choices','2025-07-01 06:14:43.856240'),
 (19,'app','0002_kycdetailsnew_contactsh_kycdetailsnew_investmentamt_and_more','2025-07-01 06:14:43.904858'),
 (20,'app','0003_alter_kycdetailsnew_passportphoto','2025-07-01 06:14:43.924036'),
 (21,'app','0004_remove_kycdetailsnew_created_at_and_more','2025-07-01 06:14:43.970849'),
 (22,'app','0005_kycdetailsnew_bond','2025-07-01 06:14:43.989248'),
 (23,'app','0006_alter_kycdetailsnew_bond','2025-07-01 06:14:44.002158'),
 (24,'app','0007_bondimage','2025-07-01 06:14:44.027779'),
 (25,'app','0008_delete_bondimage','2025-07-01 06:14:44.034446'),
 (26,'app','0009_bondimage','2025-07-01 06:14:44.050847'),
 (27,'app','0010_user_is_sub_mainuser','2025-07-01 06:14:44.072716'),
 (28,'app','0011_remove_kycdetailsnew_bond','2025-07-01 06:14:44.088609'),
 (29,'app','0012_user_parent','2025-07-01 06:14:44.105260'),
 (30,'app','0013_remove_user_parent','2025-07-01 06:14:44.125375'),
 (31,'app','0014_user_parent','2025-07-01 06:14:44.144548'),
 (32,'app','0015_remove_user_parent','2025-07-01 06:14:44.164866'),
 (33,'app','0016_subuserkyc','2025-07-01 06:14:44.181349'),
 (34,'app','0017_delete_subuserkyc','2025-07-01 06:14:44.192217'),
 (35,'app','0018_kycdetailstable1_kycdetailstable2','2025-07-01 06:14:44.234250'),
 (36,'app','0019_remove_kycdetailstable2_bonds_and_more','2025-07-01 06:14:44.320216'),
 (37,'app','0020_delete_kycdetailstable2','2025-07-01 06:14:44.328741'),
 (38,'app','0021_kycdetailsnew_data_for_user','2025-07-01 06:14:44.350394'),
 (39,'app','0022_alter_kycdetailsnew_data_for_user','2025-07-01 06:14:44.363517'),
 (40,'app','0023_rename_data_for_user_kycdetailsnew_created_by','2025-07-01 06:14:44.380025'),
 (41,'app','0024_alter_kycdetailsnew_created_by','2025-07-01 06:14:44.394091'),
 (42,'app','0025_user_parent_user','2025-07-01 06:14:44.415191'),
 (43,'sessions','0001_initial','2025-07-01 06:14:44.429939'),
 (44,'token_blacklist','0001_initial','2025-07-01 06:14:44.455940'),
 (45,'token_blacklist','0002_outstandingtoken_jti_hex','2025-07-01 06:14:44.471590'),
 (46,'token_blacklist','0003_auto_20171017_2007','2025-07-01 06:14:44.490658'),
 (47,'token_blacklist','0004_auto_20171017_2013','2025-07-01 06:14:44.517131'),
 (48,'token_blacklist','0005_remove_outstandingtoken_jti','2025-07-01 06:14:44.535760'),
 (49,'token_blacklist','0006_auto_20171017_2113','2025-07-01 06:14:44.553973'),
 (50,'token_blacklist','0007_auto_20171017_2214','2025-07-01 06:14:44.588343'),
 (51,'token_blacklist','0008_migrate_to_bigautofield','2025-07-01 06:14:44.624457'),
 (52,'token_blacklist','0010_fix_migrate_to_bigautofield','2025-07-01 06:14:44.655354'),
 (53,'token_blacklist','0011_linearizes_history','2025-07-01 06:14:44.667529'),
 (54,'token_blacklist','0012_alter_outstandingtoken_user','2025-07-01 06:14:44.682731'),
 (55,'app','0026_remove_bondimage_kyc_alter_bondimage_image_mykyc_and_more','2025-07-01 09:13:57.047678'),
 (56,'app','0027_remove_mykyc_created_at_remove_subkyc_data_for_user_and_more','2025-07-01 09:23:41.432281'),
 (57,'app','0028_alter_bondimage_image','2025-07-01 09:28:18.515359'),
 (58,'app','0029_subkyc_is_hidden','2025-07-01 10:21:34.762496'),
 (59,'app','0002_alter_bondimage_companyname_and_more','2025-07-08 06:41:09.659801'),
 (60,'app','0003_alter_bondimage_amount','2025-07-08 07:02:41.485413'),
 (61,'app','0004_remove_bondimage_amount','2025-07-08 08:42:02.226439'),
 (62,'app','0002_bondimage_amount','2025-07-08 09:00:14.788123'),
 (63,'app','0003_rename_pan_image_mykyc_aadhar_back_image_and_more','2025-07-10 04:35:14.487718'),
 (64,'app','0004_rename_pan_image_subkyc_aadhar_back_image_and_more','2025-07-10 04:44:12.504453'),
 (65,'app','0005_alter_mykyc_aadhar_number','2025-07-10 12:54:49.222639'),
 (66,'app','0006_alter_bondimage_companyname_and_more','2025-07-12 04:51:03.775812'),
 (67,'app','0007_alter_bondimage_investment_date','2025-07-12 04:51:51.548319');
INSERT INTO "django_content_type" ("id","app_label","model") VALUES (1,'admin','logentry'),
 (2,'auth','permission'),
 (3,'auth','group'),
 (4,'contenttypes','contenttype'),
 (5,'sessions','session'),
 (6,'app','user'),
 (7,'app','kycdetailsnew'),
 (8,'app','bondimage'),
 (9,'token_blacklist','blacklistedtoken'),
 (10,'token_blacklist','outstandingtoken'),
 (11,'app','mykyc'),
 (12,'app','subkyc');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (1,1,'add_logentry','Can add log entry'),
 (2,1,'change_logentry','Can change log entry'),
 (3,1,'delete_logentry','Can delete log entry'),
 (4,1,'view_logentry','Can view log entry'),
 (5,2,'add_permission','Can add permission'),
 (6,2,'change_permission','Can change permission'),
 (7,2,'delete_permission','Can delete permission'),
 (8,2,'view_permission','Can view permission'),
 (9,3,'add_group','Can add group'),
 (10,3,'change_group','Can change group'),
 (11,3,'delete_group','Can delete group'),
 (12,3,'view_group','Can view group'),
 (13,4,'add_contenttype','Can add content type'),
 (14,4,'change_contenttype','Can change content type'),
 (15,4,'delete_contenttype','Can delete content type'),
 (16,4,'view_contenttype','Can view content type'),
 (17,5,'add_session','Can add session'),
 (18,5,'change_session','Can change session'),
 (19,5,'delete_session','Can delete session'),
 (20,5,'view_session','Can view session'),
 (21,6,'add_user','Can add user'),
 (22,6,'change_user','Can change user'),
 (23,6,'delete_user','Can delete user'),
 (24,6,'view_user','Can view user'),
 (25,7,'add_kycdetailsnew','Can add kyc details new'),
 (26,7,'change_kycdetailsnew','Can change kyc details new'),
 (27,7,'delete_kycdetailsnew','Can delete kyc details new'),
 (28,7,'view_kycdetailsnew','Can view kyc details new'),
 (29,8,'add_bondimage','Can add bond image'),
 (30,8,'change_bondimage','Can change bond image'),
 (31,8,'delete_bondimage','Can delete bond image'),
 (32,8,'view_bondimage','Can view bond image'),
 (33,9,'add_blacklistedtoken','Can add blacklisted token'),
 (34,9,'change_blacklistedtoken','Can change blacklisted token'),
 (35,9,'delete_blacklistedtoken','Can delete blacklisted token'),
 (36,9,'view_blacklistedtoken','Can view blacklisted token'),
 (37,10,'add_outstandingtoken','Can add outstanding token'),
 (38,10,'change_outstandingtoken','Can change outstanding token'),
 (39,10,'delete_outstandingtoken','Can delete outstanding token'),
 (40,10,'view_outstandingtoken','Can view outstanding token'),
 (41,11,'add_mykyc','Can add my kyc'),
 (42,11,'change_mykyc','Can change my kyc'),
 (43,11,'delete_mykyc','Can delete my kyc'),
 (44,11,'view_mykyc','Can view my kyc'),
 (45,12,'add_subkyc','Can add sub kyc'),
 (46,12,'change_subkyc','Can change sub kyc'),
 (47,12,'delete_subkyc','Can delete sub kyc'),
 (48,12,'view_subkyc','Can view sub kyc');
INSERT INTO "django_admin_log" ("id","object_id","object_repr","action_flag","change_message","content_type_id","user_id","action_time") VALUES (1,'2','prasanth',2,'[{"changed": {"fields": ["Is main user"]}}]',6,1,'2025-07-01 06:17:48.787592'),
 (2,'3','pranesh',2,'[{"changed": {"fields": ["Is sub mainuser"]}}]',6,1,'2025-07-01 06:18:30.224384'),
 (3,'40','BondImage (bonds/Footer_logo_6XaPK9o.png)',3,'',8,1,'2025-07-08 09:45:37.249019'),
 (4,'39','BondImage (bonds/Ganesh_Traders_logo_QCcKe4T.png)',3,'',8,1,'2025-07-08 09:45:37.249019'),
 (5,'38','BondImage (bonds/Footer_logo_bBB88zO.png)',3,'',8,1,'2025-07-08 09:45:37.249019'),
 (6,'37','BondImage (bonds/Footer_logo_dmYEBIK.png)',3,'',8,1,'2025-07-08 09:45:44.090227'),
 (7,'36','BondImage (bonds/Footer_logo_c7LHXFS.png)',3,'',8,1,'2025-07-08 09:45:44.090227'),
 (8,'31','BondImage (bonds/Footer_logo_TfrtHNj.png)',3,'',8,1,'2025-07-08 09:45:44.090227'),
 (9,'30','BondImage (bonds/Ganesh_Traders_logo_tIv6Mer.png)',3,'',8,1,'2025-07-08 09:45:44.090227'),
 (10,'29','BondImage (bonds/Ganesh_Traders_logo_OocjIqJ.png)',3,'',8,1,'2025-07-08 09:45:44.090227'),
 (11,'28','BondImage (bonds/Ganesh_Traders_logo_CoJg3Hh.png)',3,'',8,1,'2025-07-08 09:45:44.090227'),
 (12,'27','BondImage (bonds/Footer_logo_MOuZnCE.png)',3,'',8,1,'2025-07-08 09:45:44.091223'),
 (13,'26','BondImage (bonds/Ganesh_Traders_logo_JwOeKrX.png)',3,'',8,1,'2025-07-08 09:45:44.091223'),
 (14,'25','BondImage (bonds/Footer_logo_I7fsnku.png)',3,'',8,1,'2025-07-08 09:45:44.091223'),
 (15,'24','BondImage (bonds/Footer_logo_qdg1IYh.png)',3,'',8,1,'2025-07-08 09:45:44.091223'),
 (16,'23','BondImage (bonds/Footer_logo_zXlKL68.png)',3,'',8,1,'2025-07-08 09:45:44.091223'),
 (17,'17','BondImage (bonds/Ganesh_Traders_logo_02GlIF4.png)',3,'',8,1,'2025-07-08 09:45:44.091223'),
 (18,'16','BondImage (bonds/Footer_logo.png)',3,'',8,1,'2025-07-08 09:45:44.091223'),
 (19,'15','BondImage (bonds/Ganesh_Traders_logo_1_cfjgF9W.png)',3,'',8,1,'2025-07-08 09:45:44.091223'),
 (20,'14','BondImage (bonds/Ganesh_Traders_logo_Fsy4QNS.png)',3,'',8,1,'2025-07-08 09:45:44.091223'),
 (21,'13','BondImage (bonds/Ganesh_Traders_logo_PtOHxSm.png)',3,'',8,1,'2025-07-08 09:45:44.091223'),
 (22,'12','BondImage (bonds/Ganesh_Traders_logo_1_aE57n8y.png)',3,'',8,1,'2025-07-08 09:45:44.091223'),
 (23,'10','BondImage (bonds/Ganesh_Traders_logo_r6oogod.png)',3,'',8,1,'2025-07-08 09:45:44.091223'),
 (24,'9','BondImage (bonds/Ganesh_Traders_logo_X55E8uw.png)',3,'',8,1,'2025-07-08 09:45:44.091223'),
 (25,'3','BondImage (kyc/bonds/Ganesh_Traders_logo_1D1oPDZ.png)',3,'',8,1,'2025-07-08 09:45:44.091223'),
 (26,'2','BondImage (kyc/bonds/Ganesh_Traders_logo_eGnz0dU.png)',3,'',8,1,'2025-07-08 09:45:44.091223'),
 (27,'1','BondImage (kyc/bonds/Footer_logo_bVysylI.png)',3,'',8,1,'2025-07-08 09:45:44.091223'),
 (28,'15','SubKYC: sam',3,'',12,1,'2025-07-10 04:24:52.172809'),
 (29,'13','SubKYC: aaksh',3,'',12,1,'2025-07-10 04:24:52.172809'),
 (30,'12','SubKYC: kumar prasanth',3,'',12,1,'2025-07-10 04:24:52.172809'),
 (31,'11','SubKYC: vicky',3,'',12,1,'2025-07-10 04:24:52.172809'),
 (32,'10','SubKYC: kumar prasanth',3,'',12,1,'2025-07-10 04:24:52.172809'),
 (33,'6','SubKYC: vignesh',3,'',12,1,'2025-07-10 04:24:52.172809'),
 (34,'5','SubKYC: vicky',3,'',12,1,'2025-07-10 04:24:52.172809'),
 (35,'4','SubKYC: ram',3,'',12,1,'2025-07-10 04:24:52.172809'),
 (36,'7','sam',3,'',6,1,'2025-07-10 11:18:45.775648'),
 (37,'49','BondImage (bonds/Footer_logo_gQi3Kot.png)',3,'',8,1,'2025-07-12 04:56:46.336567'),
 (38,'48','BondImage (bonds/Footer_logo_qoHATJg.png)',3,'',8,1,'2025-07-12 04:56:46.336567'),
 (39,'47','BondImage (bonds/Footer_logo_STO7oCf.png)',3,'',8,1,'2025-07-12 04:56:46.336567'),
 (40,'50','BondImage (bonds/Footer_logo_rYSeOPE.png)',3,'',8,1,'2025-07-12 05:08:25.893145'),
 (41,'51','BondImage (bonds/Footer_logo_FfrzZhl.png)',3,'',8,1,'2025-07-12 05:09:32.090346'),
 (42,'52','BondImage (bonds/Footer_logo_pv2oS5f.png)',3,'',8,1,'2025-07-12 05:18:28.602146');
INSERT INTO "app_user" ("id","password","last_login","is_superuser","username","first_name","last_name","email","is_staff","is_active","date_joined","phone_number","jwt_token","is_main_user","is_sub_mainuser","parent_user_id") VALUES (1,'pbkdf2_sha256$870000$OMPFjkAhB0z4rohObJc48K$eX4oU06TW2ShvBZDVH2o4+ffwuzDEYiS5TYwO+dP718=','2025-07-19 12:42:06.344957',1,'admin','','','',1,1,'2025-07-01 06:15:56.781085','',NULL,0,0,NULL),
 (2,'!Y90Vhxe39ENgADZvCXySV8PMDxgey1T9i0GrPvhE','2025-07-16 04:35:04.903333',0,'prasanth','','','prasanth@gmail.com',0,1,'2025-07-01 06:17:26','9080406241','eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzUxMzU0MjQ2LCJpYXQiOjE3NTEzNTA2NDYsImp0aSI6ImExNDVjM2M5YWIyYzQzZTViODY5MjZkMzdmNjJlNDU2IiwidXNlcl9pZCI6Mn0.T1EDoT831vIlbASeftLOxY5jO3_VUyNAsOXD0O_pap8',1,0,NULL),
 (3,'!zgCWYFZRGMIbDBHYBTxgyDvW1HZkEGX0hlZOHsna','2025-07-14 11:29:43.974720',0,'pranesh','','','pranesh@gmail.com',0,1,'2025-07-01 06:18:06','9566798742','eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzUxMzU0Mjg2LCJpYXQiOjE3NTEzNTA2ODYsImp0aSI6ImQ0NjI3ZTE0ZGRlNDRmYWViMmY3Y2FiYjljZDk5ZjkxIiwidXNlcl9pZCI6M30.0KnJeMmryeTEYhcBzFdHOcSe38P7Ob3J2Y0z7AmLfr0',0,1,NULL),
 (4,'!zMbYk4HIYxfi5QQbe1H2LIygUwzz4IWSFqlXVMWx','2025-07-10 09:59:39.722978',0,'kumar','','','kumar@gmail.com',0,1,'2025-07-01 06:20:11.042369','7845124512','eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzUxMzU0NDExLCJpYXQiOjE3NTEzNTA4MTEsImp0aSI6ImNkY2EwOWQ1ZmQxYzQzMDY4MGFjODczMGZkMGE2N2MwIiwidXNlcl9pZCI6NH0.lue-VByVAZxX-j-GxAg_DyGI8RSfWC74HGbpu8c4jRY',0,0,NULL),
 (5,'!eeEvHf4yFcMWAujPaxylgVVCESYg5QtsHnrbGBpZ','2025-07-19 12:41:15.382595',0,'vignesh','','','vignesh@gmail.com',0,1,'2025-07-01 12:35:32.260464','9566798442','eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzUxMzc2OTMyLCJpYXQiOjE3NTEzNzMzMzIsImp0aSI6IjFjN2M1OWZiY2MwOTQ5MDliZGRhMzY1ZGY1OGFmZTkyIiwidXNlcl9pZCI6NX0.yJ8GYTY028lTwDxT1czD-VBgIruZ0mtnVmy1msOPN8k',0,0,NULL),
 (6,'!mITWSoJCQJHbMp2ALhcgLeuCCpp65QLsaKW7NNxF','2025-07-09 04:28:39.311603',0,'ram','','','',0,1,'2025-07-09 04:28:23.817340','8056407730','eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzUyMDM4OTAzLCJpYXQiOjE3NTIwMzUzMDMsImp0aSI6ImFhZjRjNjBiMWQyYzQ5YTQ4MDdiMDFmNDhiMGQxZjhlIiwidXNlcl9pZCI6Nn0.L1Bs_dblkx9IaL_fgBHoQztox6pXhunI8nH_1GhESXQ',0,0,NULL);
INSERT INTO "django_session" ("session_key","session_data","expire_date") VALUES ('kjgg5eb2lig9rnd6lsbd119xc148trni','.eJxVjDEOwjAMAP-SGUWNWxKHkb1viOzYkAJqpaadEH9HkTrAene6t0m0byXtVdc0ibkYZ06_jCk_dW5CHjTfF5uXeVsnti2xh612XERf16P9GxSqpW0dgRACDz73LOyCYkf9OXvuBkTREHIPjIK3jArquwhRKYLTQAOD-XwB7oc4Kw:1uWUHl:H2kI89yuq-lxTNvMgZ6Up4RzJert0wHsu-oUh_6TKKY','2025-07-15 06:16:05.573281'),
 ('xt2y0npzhg7zbd4suhwn99axeo4uuis7','.eJxVjstygjAUht-FdcsEAijdqbSdYIl3RTZObpggtxqtSqfv3jjjol2e__L959vakfNJ7s5aHHeKWy-Wbz391ShhB1HfDV6Qet_YrKlPR0Xte8R-uNpOGi7K4SP7DyCJlqZNXCcHTu4B5oWccY94QPDQo0EAPA8GThj0gSA59Hs-8SHlJHCdoOeGkEDTo9BACWNC692pMSOGKG6xpO9MTVSMVh1ysEIa1XOfjVCADm26HsWhbUKAuqeSliEQ6bBERaO2G1xkKe6QuqgslRejXXG3uuEuuSXFzPsYxe02nalJ8QrxEsGk2Ls42mtUtYAsDLyKi-1m5uBOVpNlLLNobu65zDazaxK9lclSVlk0AFnE5X2Dp7hkZdhm5jGcAjuio3iYVPnn83QsJ0vYi6Pi6wyek1yTxbY_zsaOXk-rgSOY9fMLOUCJ7Q:1ucGmv:n3DUaALchQBxSaQOHO376WuLPxDUJR-QCnN5qKBJ2aU','2025-07-31 05:04:09.511529'),
 ('3pni6t54puzxss31dbrxlstct88px8xh','.eJxVjk1z2jAURf-L161HliXAXUIzjDyxqFunkdl49PGIJITtYiiJM_3vFTPZZHvPefe-92S0Qw9dfz0pOCffkgKtEEELTLLkS9LJ68V21wnOnTMR0s-ZkvoI_R0YL_uXIdVDfzk7ld6V9INOaTUYCOsP91OBlZON1xhDdqAqA5DFwmSYyAMA5EriJaIoz5YaU7MEBAUlqkBKK4XhkIEhi9VBURJLpdYwTd1liCOxEd5Kq7ba7VzJnmaWcccm1v-kesMW7DiK35uySKOEFL4EFQoEYh2YH1z7zP1e8Jm5m9sLe4vZK5-f3nYNo1Wjs8dNObaidjv_kPN75l9I5BM7jUj-iuU-2PZUk-p7nUf_1s51vt8y0s428OhWs_F8W7_umnC8bxjBgw7FuI-PcYHSBtbFaYBn8Zf9qVZg2Ch-DN5QvBbeXr8aOvLSIHdrliz59x9Qj5Qp:1udmK6:AdHqoKkDxCbBxUrhed1KQWtDhphLdnuM0Lks23EQ6o0','2025-08-04 08:56:38.520694'),
 ('sw0tys9yr9rocp49jp8ggdihx4w5ax8a','.eJxVjMsOwiAQRf-FtSG0MDxcuvcbyDADUjU0Ke3K-O_apAvd3nPOfYmI21rj1vMSJxZnMYjT75aQHrntgO_YbrOkua3LlOSuyIN2eZ05Py-H-3dQsddvTcHZgKBsShqAizMZjHGMRStrqXCggZIlVKCDxwyEQbEnPxogq0fx_gDrqDgO:1ud6tC:RTz03BNUDb-1KbG4jykseTzhLWABVmIHk847pGZkyys','2025-08-02 12:42:06.344957');
INSERT INTO "token_blacklist_outstandingtoken" ("token","created_at","expires_at","user_id","jti","id") VALUES ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MTQzNzA0NiwiaWF0IjoxNzUxMzUwNjQ2LCJqdGkiOiIxZmE3YWNlMWM2ZTY0OTJlYTczYzJjMzk3ZjA5MThjMiIsInVzZXJfaWQiOjJ9.cDRKPTfWxwpNjnIGD7B58tc9VkU-rpAH5XIxJkpbq3I','2025-07-01 06:17:26.070980','2025-07-02 06:17:26',2,'1fa7ace1c6e6492ea73c2c397f0918c2',1),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MTQzNzA1NywiaWF0IjoxNzUxMzUwNjU3LCJqdGkiOiI5MWRmMWE0MzY3OTM0OWJhYTI3NzRhNDg2YmRmOTMzZiIsInVzZXJfaWQiOjJ9.QZJA8h-iB4GujD7WAs09__1EfnWjuFstRxDKUgAPVFA','2025-07-01 06:17:37.540109','2025-07-02 06:17:37',2,'91df1a43679349baa2774a486bdf933f',2),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MTQzNzA4NiwiaWF0IjoxNzUxMzUwNjg2LCJqdGkiOiIwNjUyYjQxNTAwNzM0MzE3OGFmMDlhNmE0NGNiZmNlZiIsInVzZXJfaWQiOjN9.0tVZ-waZaeijwpkOmQSjVxEK260Ok3Fz59T2-9Jenns','2025-07-01 06:18:06.761054','2025-07-02 06:18:06',3,'0652b415007343178af09a6a44cbfcef',3),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MTQzNzA5NywiaWF0IjoxNzUxMzUwNjk3LCJqdGkiOiIxMTYwYzc5ZGYxYjQ0YWIxYTg5ZDc3MWNhY2VmYWU4OCIsInVzZXJfaWQiOjN9.OkZz4ZCBA_2CV1I0vY79YXRdSJlG63aBDrG-uios-ZU','2025-07-01 06:18:17.660217','2025-07-02 06:18:17',3,'1160c79df1b44ab1a89d771cacefae88',4),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MTQzNzIxMSwiaWF0IjoxNzUxMzUwODExLCJqdGkiOiJjNmI3NWNhYjZjOTY0YzgzOWEzYzllZmRmZWYxZjAzMSIsInVzZXJfaWQiOjR9.f2IfAZiLfzY_InjBQAzYX6ht4G2azUsLWsmxTYb5J_k','2025-07-01 06:20:11.055001','2025-07-02 06:20:11',4,'c6b75cab6c964c839a3c9efdfef1f031',5),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MTQzNzIyNCwiaWF0IjoxNzUxMzUwODI0LCJqdGkiOiJlZDYxYTQ4ZWZmZjU0NThkYWI2YmI3ODBmMTdjYzk1MCIsInVzZXJfaWQiOjR9.Lztt0n5IaiOeuZK2vWVkONlKV2jjUOB8fhhM5a2UgRo','2025-07-01 06:20:24.682707','2025-07-02 06:20:24',4,'ed61a48efff5458dab6bb780f17cc950',6),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MTQ1NzcyNCwiaWF0IjoxNzUxMzcxMzI0LCJqdGkiOiJmYjQwYzJjZGJiZDc0OGZhODliMTMyYjUzN2M0ZmNlZCIsInVzZXJfaWQiOjJ9.Xo0-5kitnc3rUpnvWruUSq2kx8-CG7qefrG74PhKfwE','2025-07-01 12:02:04.978752','2025-07-02 12:02:04',2,'fb40c2cdbbd748fa89b132b537c4fced',7),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MTQ1OTczMiwiaWF0IjoxNzUxMzczMzMyLCJqdGkiOiJiYjM0ODY2MjJmYWE0ZGE5OTUyOTllODRmZTRhYzJmNCIsInVzZXJfaWQiOjV9.Fd4i1XlRDo-0DM1WdJzsbfslNpZHZlt5mB_643sZuSg','2025-07-01 12:35:32.264819','2025-07-02 12:35:32',5,'bb3486622faa4da995299e84fe4ac2f4',8),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MTQ2MTA1NiwiaWF0IjoxNzUxMzc0NjU2LCJqdGkiOiI2NDVlMjU4OGMzMjY0Y2RlYTkxYTc2MDRkZjQ2NmNhNyIsInVzZXJfaWQiOjV9.CTnExLlOmthdcx6FJTzXzrqn8L8hbMuMnMdo7wAe8IM','2025-07-01 12:57:36.028856','2025-07-02 12:57:36',5,'645e2588c3264cdea91a7604df466ca7',9),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MTQ2MTc3NywiaWF0IjoxNzUxMzc1Mzc3LCJqdGkiOiI2OGYxMTMzOTRkNjI0YzkzOWRlMWFmZjBlZjU5NWU5ZiIsInVzZXJfaWQiOjJ9.NzIsm03LMHCxYqHtO35iDkC56-79OrQXp6-aaDY7mfU','2025-07-01 13:09:37.379710','2025-07-02 13:09:37',2,'68f113394d624c939de1aff0ef595e9f',10),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MTQ2MTc5MywiaWF0IjoxNzUxMzc1MzkzLCJqdGkiOiJhOTliNTQxMWRmMjc0MDY4OWU0ZjU0ZDkyMDZmODg1MiIsInVzZXJfaWQiOjJ9.SjkA5aOsQQ3PCb8LNu8W3FyPlRiJhjbJVmieWLUQv-8','2025-07-01 13:09:53.970284','2025-07-02 13:09:53',2,'a99b5411df2740689e4f54d9206f8852',11),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MTQ2MTgwOCwiaWF0IjoxNzUxMzc1NDA4LCJqdGkiOiI1NThiZGFlMDRiMTM0MjBmODNiNTc0MTk0OWI1ZGRhMSIsInVzZXJfaWQiOjV9.LuYOhPH71Plokq1GiN-8ClQCXoRz4HzlZ0k31JYNrGw','2025-07-01 13:10:08.531237','2025-07-02 13:10:08',5,'558bdae04b13420f83b5741949b5dda1',12),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MTQ2MTgyMiwiaWF0IjoxNzUxMzc1NDIyLCJqdGkiOiIwYzgyY2Y2YTVhMzk0M2FkYWUzZDllNzBkMDFkZmY0YyIsInVzZXJfaWQiOjJ9.OsOrqJaV63ZRTssucvRBU4S-j4S5joH9T3ouIHV-6pY','2025-07-01 13:10:22.154574','2025-07-02 13:10:22',2,'0c82cf6a5a3943adae3d9e70d01dff4c',13),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MTQ2MjMyOCwiaWF0IjoxNzUxMzc1OTI4LCJqdGkiOiIyOThmYzRmOTBlM2E0ZWIzYTkyYjI3OGU2NzhkM2NmMCIsInVzZXJfaWQiOjN9.i8FrXHqllm4qvxyyI3nfxGY4prZU4APlgx8O5-4IaH8','2025-07-01 13:18:48.095916','2025-07-02 13:18:48',3,'298fc4f90e3a4eb3a92b278e678d3cf0',14),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MTQ2MjM5MywiaWF0IjoxNzUxMzc1OTkzLCJqdGkiOiJhYzc0MzFkMzkyM2Q0MzU3YTAyNTg1MGNhN2Q0ZWQzMiIsInVzZXJfaWQiOjV9.aWLf0XFSpvhsLAf-Dxqu7GCnoUn4B0leyjs7uHxsFWU','2025-07-01 13:19:53.831991','2025-07-02 13:19:53',5,'ac7431d3923d4357a025850ca7d4ed32',15),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MTUxODIzOCwiaWF0IjoxNzUxNDMxODM4LCJqdGkiOiI4YTg5OWQ4YWM5MDg0ZmZiYWFmMDY0MjY4ZTg4NjgxMiIsInVzZXJfaWQiOjV9.4-31yTKSIelfEb2Dk2r2fP33tNOf1b6wAui7tkfU4Xo','2025-07-02 04:50:38.292390','2025-07-03 04:50:38',5,'8a899d8ac9084ffbaaf064268e886812',16),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MTc3NjIwMiwiaWF0IjoxNzUxNjg5ODAyLCJqdGkiOiIwY2M1YTRmNThmMWE0ZDU4YWRkYzkyYTQ0ZjlkZjA2NSIsInVzZXJfaWQiOjJ9.aCyEBq9z7CJdhTXU0jM81rhLJKXCpb0yWVidcS3AzS4','2025-07-05 04:30:02.932957','2025-07-06 04:30:02',2,'0cc5a4f58f1a4d58addc92a44f9df065',17),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MTk1Mzg2MSwiaWF0IjoxNzUxODY3NDYxLCJqdGkiOiIxMTJjZDliNjY3ZmQ0NWFiYmIzNGVmNzY2ODVkZDFhMyIsInVzZXJfaWQiOjJ9.kmDB7YbaPykNgHObyQchFCspJQZdJIXE866ko-Skotw','2025-07-07 05:51:01.395067','2025-07-08 05:51:01',2,'112cd9b667fd45abbb34ef76685dd1a3',18),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MTk1NDA1MywiaWF0IjoxNzUxODY3NjUzLCJqdGkiOiJkNTJhNTY5Nzk5NjM0NmE4ODlhODc5NzdkMDg3NDljNiIsInVzZXJfaWQiOjN9.jgTzzsMTeh-6Dx5ZILvJHffXSeMtRi0dmXz_ZBVxBiA','2025-07-07 05:54:13.851861','2025-07-08 05:54:13',3,'d52a5697996346a889a87977d08749c6',19),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MTk1NDIwMywiaWF0IjoxNzUxODY3ODAzLCJqdGkiOiIxZjRmNzQ3YmViNTk0NDAzYjdlMjM1YTg0YzgwZGRmNSIsInVzZXJfaWQiOjR9.51Ga4HkeX_ulsRcXz9RdLPklzF_HBAdJnmDfPFSfD-Q','2025-07-07 05:56:43.276345','2025-07-08 05:56:43',4,'1f4f747beb594403b7e235a84c80ddf5',20),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MTk1NDY1MCwiaWF0IjoxNzUxODY4MjUwLCJqdGkiOiIyZmFiYmM1MzNmZGU0YjY0ODdkYmY4ODY4ODA4YzUzOSIsInVzZXJfaWQiOjJ9.bpf9rqzadxQIiCZwsDaCTerUpv1_EHiFjA2UItQAirk','2025-07-07 06:04:10.626263','2025-07-08 06:04:10',2,'2fabbc533fde4b6487dbf8868808c539',21),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MTk1NDc0OSwiaWF0IjoxNzUxODY4MzQ5LCJqdGkiOiI5M2E3NjM0N2MyMGM0NmJkYmU0MTVjODdjNDM1NmI2YyIsInVzZXJfaWQiOjN9.-PFXdfHRZfGjTj4QwKxeizICcjH5subZPRfRgHCKz3I','2025-07-07 06:05:49.882467','2025-07-08 06:05:49',3,'93a76347c20c46bdbe415c87c4356b6c',22),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MTk1NTQyMywiaWF0IjoxNzUxODY5MDIzLCJqdGkiOiIyYTAwYmY4MTZlNjk0Yjk5YTRjZWYzYjk5ODY2OWViNCIsInVzZXJfaWQiOjJ9.vdsv24dod29GYKCYSxlT4QrvvS--CfpcMolK-eYV15M','2025-07-07 06:17:03.520123','2025-07-08 06:17:03',2,'2a00bf816e694b99a4cef3b998669eb4',23),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MTk1NTU5MCwiaWF0IjoxNzUxODY5MTkwLCJqdGkiOiIwNGQ5ODAwZjQwNDI0OTQ2ODFmZmFmY2NjOGViMTFmYSIsInVzZXJfaWQiOjN9.rHdKLK3Tg3FefaguqtMiecrUajXjsFsCZ5J33c0Y9JE','2025-07-07 06:19:50.289129','2025-07-08 06:19:50',3,'04d9800f4042494681ffafccc8eb11fa',24),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MTk1NTY0MywiaWF0IjoxNzUxODY5MjQzLCJqdGkiOiJmOTViNGI0ZDZiNmM0NWQ2OTYwZjQ1YTUwNzA5ZTBmZiIsInVzZXJfaWQiOjR9.MLtB3mnw5UEVDIWkkCpyBGqFn8Cmy8dVsxU29LRQZrA','2025-07-07 06:20:43.973445','2025-07-08 06:20:43',4,'f95b4b4d6b6c45d6960f45a50709e0ff',25),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MTk1NTkyNiwiaWF0IjoxNzUxODY5NTI2LCJqdGkiOiI2NjBkZjBjMWRmZmY0ZTRiYjUzM2IyNjcwMGE4MTE2NSIsInVzZXJfaWQiOjJ9.BlnwB9uj5cDqs4iAKRQkOGJk5OigfBX7z3LyEApRjEc','2025-07-07 06:25:26.193352','2025-07-08 06:25:26',2,'660df0c1dfff4e4bb533b26700a81165',26),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MTk1NjU0MiwiaWF0IjoxNzUxODcwMTQyLCJqdGkiOiI4ZDI1OWZjMDBlYTU0OGU3YmYwOWU5OTYxMmQwMDhjZiIsInVzZXJfaWQiOjV9.qmHfPJhtfAfIsRZ3E9tS9NatzP5uX5d_cguxKbtczU8','2025-07-07 06:35:42.435189','2025-07-08 06:35:42',5,'8d259fc00ea548e7bf09e99612d008cf',27),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MTk1ODI0NiwiaWF0IjoxNzUxODcxODQ2LCJqdGkiOiJkZmUxYTlmZDlhODI0YWRhODI0NzJhY2VhYzRlZTRkYSIsInVzZXJfaWQiOjJ9.01mkBshOk0NTxL1l_OVoJBRYjU7C6_oVQUkBcCTWurc','2025-07-07 07:04:06.426960','2025-07-08 07:04:06',2,'dfe1a9fd9a824ada82472aceac4ee4da',28),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MTk1ODk0NSwiaWF0IjoxNzUxODcyNTQ1LCJqdGkiOiJiY2JiMTRkNGE2YzU0Zjg2YjEzNmUwZmE2ZmE5MGI5ZCIsInVzZXJfaWQiOjR9.tKA_MPi5r4QTpFsN36yt16n0CuqJ6aACw3BVbKr1ZAg','2025-07-07 07:15:45.495459','2025-07-08 07:15:45',4,'bcbb14d4a6c54f86b136e0fa6fa90b9d',29),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MTk1OTI2MSwiaWF0IjoxNzUxODcyODYxLCJqdGkiOiI1OTAxYWJlNDg2NzA0OTUzOTJjNjgwOTczMDA4YmM0OSIsInVzZXJfaWQiOjJ9.lYh9b0q24WSTadSciv1q-itSqWQSI7miJBWSZKvu0AI','2025-07-07 07:21:01.773659','2025-07-08 07:21:01',2,'5901abe48670495392c680973008bc49',30),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MTk2NDIzNiwiaWF0IjoxNzUxODc3ODM2LCJqdGkiOiIyNzFiZTRmYmViMDU0ZjFjOWI2MWJlMTQyNzQ1ZjIzMyIsInVzZXJfaWQiOjV9.WBNmFmG-iiNASdl5lM_3FbJTsx2EgowC40-BcivmKy8','2025-07-07 08:43:56.599233','2025-07-08 08:43:56',5,'271be4fbeb054f1c9b61be142745f233',31),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MTk2NDI5MSwiaWF0IjoxNzUxODc3ODkxLCJqdGkiOiIzYzJiYjM3NTQ0Y2U0ODkyYTgyZjExNTMxNjMxZTk4YSIsInVzZXJfaWQiOjJ9.iu9OkCzcmCWV7hLL1ChM8XL7aEk7OQIxuWAFpj2H27s','2025-07-07 08:44:51.735375','2025-07-08 08:44:51',2,'3c2bb37544ce4892a82f11531631e98a',32),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MTk2NDQ4NSwiaWF0IjoxNzUxODc4MDg1LCJqdGkiOiJhY2IzMmVhZDI1ZWQ0YjU2ODY3NTIyZTcyZjgzMGI4NCIsInVzZXJfaWQiOjV9.prg5j0e6R3sA0t99BjYj9dy1Z04mrJqD8fwgU5dJvEQ','2025-07-07 08:48:05.660532','2025-07-08 08:48:05',5,'acb32ead25ed4b56867522e72f830b84',33),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MTk3NjQ1OCwiaWF0IjoxNzUxODkwMDU4LCJqdGkiOiI1YmFhMDY5MDA0ODE0N2IwODU5NmNjNDZkMDNhMGZmYSIsInVzZXJfaWQiOjJ9.yJZ0vCgTALowJl_9eBnpzdXz0f9J4I1rDMetQLSzOEk','2025-07-07 12:07:38.400786','2025-07-08 12:07:38',2,'5baa0690048147b08596cc46d03a0ffa',34),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MTk3NjU5OCwiaWF0IjoxNzUxODkwMTk4LCJqdGkiOiJiZGM5MzA0M2E2NDk0ZTNlODI5ZjVjY2QxNDVmMmM0NCIsInVzZXJfaWQiOjV9.sGpHqtTv1YR-conk3yxnUdunsYF_DokxEEXNrfOHkko','2025-07-07 12:09:58.588624','2025-07-08 12:09:58',5,'bdc93043a6494e3e829f5ccd145f2c44',35),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MTk3NzU2OSwiaWF0IjoxNzUxODkxMTY5LCJqdGkiOiIwOTcxNmRjMGEyMTc0YWM5OGZkMmU4YmQyNzI4Y2VlOCIsInVzZXJfaWQiOjJ9.1YzbobslfzbzfVTjwCyBn8bUBJi9TBcrNN0UsE2Y9SI','2025-07-07 12:26:09.546009','2025-07-08 12:26:09',2,'09716dc0a2174ac98fd2e8bd2728cee8',36),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MTk4MDc3MSwiaWF0IjoxNzUxODk0MzcxLCJqdGkiOiI3NGU5ZWY0N2I3MDg0MDNhOWFjNDMwODk2YjBjM2ZjMyIsInVzZXJfaWQiOjR9.bCelCpaWifx0GwPZ1NXrXtXTyPqvYFavAdi_dEB7f0c','2025-07-07 13:19:31.902674','2025-07-08 13:19:31',4,'74e9ef47b708403a9ac430896b0c3fc3',37),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MTk4MTEzMSwiaWF0IjoxNzUxODk0NzMxLCJqdGkiOiIzNTQ1MjExZDA5N2I0ZmI0OTZhZTI4MzcwMjY4MWYxYiIsInVzZXJfaWQiOjJ9.k6eSboXJUGpUU-CJ6RGrKf0ItUwyQa72nz2W7E-A9FA','2025-07-07 13:25:31.111095','2025-07-08 13:25:31',2,'3545211d097b4fb496ae283702681f1b',38),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjAzNTYwNCwiaWF0IjoxNzUxOTQ5MjA0LCJqdGkiOiI1NGJjOGExMWU2MGQ0ODg3OTkyMWJiYmFhMGU4OWNkYiIsInVzZXJfaWQiOjJ9.EwItJuziDS8VisdqdpzJPFVVgRTDm05LeqxvE2hgOZg','2025-07-08 04:33:24.451749','2025-07-09 04:33:24',2,'54bc8a11e60d48879921bbbaa0e89cdb',39),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjAzNjQ0OSwiaWF0IjoxNzUxOTUwMDQ5LCJqdGkiOiI1YTE2NDA5YmRjNjM0OTgzYmRiY2RiYmRhMzhlZTBmZSIsInVzZXJfaWQiOjV9.AnfrVaPXRcW4yjkWeLu7iKGJKxDTUoUy_X_u_S0yxnE','2025-07-08 04:47:29.166064','2025-07-09 04:47:29',5,'5a16409bdc634983bdbcdbbda38ee0fe',40),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjAzNjQ3NCwiaWF0IjoxNzUxOTUwMDc0LCJqdGkiOiI2Y2IyODcyMTFkNGM0YzQ3YTVjY2UwMDk2ZTFjOGQ1MCIsInVzZXJfaWQiOjJ9.0Bs7favrs1k4jFUT4TPm0S5WVBxir3deIPBSJfg6SNg','2025-07-08 04:47:54.627704','2025-07-09 04:47:54',2,'6cb287211d4c4c47a5cce0096e1c8d50',41),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjAzODQzMCwiaWF0IjoxNzUxOTUyMDMwLCJqdGkiOiJkZWQxNzA1NGZmZmI0NTJmOWJlOTVhZmI4NjQwNDQxZiIsInVzZXJfaWQiOjV9.RB151lKdU-2QbCV7476WbHIt-a33fnJV-tWqBNQ3Bco','2025-07-08 05:20:30.328486','2025-07-09 05:20:30',5,'ded17054fffb452f9be95afb8640441f',42),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjA2MDg0MiwiaWF0IjoxNzUxOTc0NDQyLCJqdGkiOiI3MGVhMWQ5ZGVkOTA0Y2I4ODliOTI1ZDFmZDk5N2ExMCIsInVzZXJfaWQiOjJ9.YAlQLCjHXtgjqeeeGKGtzhLe7QjvD1ryH2WuM9HkHZc','2025-07-08 11:34:02.300056','2025-07-09 11:34:02',2,'70ea1d9ded904cb889b925d1fd997a10',43),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjA2MTEyMCwiaWF0IjoxNzUxOTc0NzIwLCJqdGkiOiJlNmNmNjY3NDE0ZWU0YmNiYTYyZDFiNWZjNzU0YWRkNSIsInVzZXJfaWQiOjV9.dT2dLAqTlcYFjOYtSVJZsocjHHXCqjdMAdjgdUi9B9Y','2025-07-08 11:38:40.104309','2025-07-09 11:38:40',5,'e6cf667414ee4bcba62d1b5fc754add5',44),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjEyMTcwMywiaWF0IjoxNzUyMDM1MzAzLCJqdGkiOiIyOWIzMjc0MDM2ZWU0NTg3YjVlNDk3MmY3ZDlmMGVmNyIsInVzZXJfaWQiOjZ9.3JSaixPmG6x9MVKAKhQmei-ZhN3gxyRdOz-HbMdCmsk','2025-07-09 04:28:23.828045','2025-07-10 04:28:23',6,'29b3274036ee4587b5e4972f7d9f0ef7',45),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjEyMTcxOSwiaWF0IjoxNzUyMDM1MzE5LCJqdGkiOiJhMDMwOThiNGI5MGI0Y2ZjYmZhZTJiNzkwMjA3MTU0NyIsInVzZXJfaWQiOjZ9.W50Qg5DJC1ODj8XFUisr3SLgRgW4ouG7DPpCyXp3LLk','2025-07-09 04:28:39.319758','2025-07-10 04:28:39',6,'a03098b4b90b4cfcbfae2b7902071547',46),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjEyMTczOSwiaWF0IjoxNzUyMDM1MzM5LCJqdGkiOiIxYmNiZjAyY2Q3ODE0MDQ1YTdmMWZmMmFjZGE5NTQ4NyIsInVzZXJfaWQiOjJ9.F25FvdIrdOWEl5T_lpchExLH3RcbwizqfniGvgChfUg','2025-07-09 04:28:59.107530','2025-07-10 04:28:59',2,'1bcbf02cd7814045a7f1ff2acda95487',47),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjEyMjIxMSwiaWF0IjoxNzUyMDM1ODExLCJqdGkiOiIzMDYwMDUyNmJkYmE0NzVkYWEwOGEyMGFjMDU1NDAwNCIsInVzZXJfaWQiOjV9.EDWyGbnBDc80EUABcO2z8TsoupiHS04u8QSbkW8n1To','2025-07-09 04:36:51.893971','2025-07-10 04:36:51',5,'30600526bdba475daa08a20ac0554004',48),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjEyNDE3OCwiaWF0IjoxNzUyMDM3Nzc4LCJqdGkiOiI0OWFkOGViOWVjN2Q0MzNiODYxY2Q1MTA3MWQ3NjZhZCIsInVzZXJfaWQiOjJ9.15KPINawuF7Sl9MgbIN9we9MPvaNXq_VD7i6GxWnmKQ','2025-07-09 05:09:38.314331','2025-07-10 05:09:38',2,'49ad8eb9ec7d433b861cd51071d766ad',49),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjEyNDI0OSwiaWF0IjoxNzUyMDM3ODQ5LCJqdGkiOiJlNzZiYzJjZGVmNjE0MGRhOTlhNGI4NWNjNjJlN2VjZCIsInVzZXJfaWQiOjV9._BTCOk2X4cY0pWeEqOXHYtj-iZr3gg8yD16ePjx6sYM','2025-07-09 05:10:49.269127','2025-07-10 05:10:49',5,'e76bc2cdef6140da99a4b85cc62e7ecd',50),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjEyNTUxNywiaWF0IjoxNzUyMDM5MTE3LCJqdGkiOiI0MDQ4MTcyNWZlN2M0NDY5YTEwMDkzNWFlNDM2ZjI3YSIsInVzZXJfaWQiOjV9.-4XBawNTOrWISpKClcaUUmCfIXC3siNVIwhIszfhXsg','2025-07-09 05:31:57.924793','2025-07-10 05:31:57',5,'40481725fe7c4469a100935ae436f27a',51),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjEyNTU4NSwiaWF0IjoxNzUyMDM5MTg1LCJqdGkiOiIxOTU3YzA1NmI0NDQ0OGMwOGZlYTViMzcxYzNkMGYwOSIsInVzZXJfaWQiOjJ9.7UTvasg8gJDXtvRY236UEEDe7j8Ay6s8O2ydb7BQ8yM','2025-07-09 05:33:05.876319','2025-07-10 05:33:05',2,'1957c056b44448c08fea5b371c3d0f09',52),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjEyNTU5OSwiaWF0IjoxNzUyMDM5MTk5LCJqdGkiOiI5OGVjZDQ1Y2UxOTY0YmM5YjdjMTIxYzAwNGZiOGYzZiIsInVzZXJfaWQiOjV9.yDw6Hti1OUXY-6csvSTeS5sEGV1jn5Al1IeDzmZMido','2025-07-09 05:33:19.908706','2025-07-10 05:33:19',5,'98ecd45ce1964bc9b7c121c004fb8f3f',53),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjEyNzg0OCwiaWF0IjoxNzUyMDQxNDQ4LCJqdGkiOiIwODk5Y2QzMGJiYWI0ZWE4ODIyMDU4NmU2MTAwMjA4NiIsInVzZXJfaWQiOjJ9.2rBBRMhlHdO9BlVPx_T9SEeGZiVxzypWOVhufr-k9Fo','2025-07-09 06:10:48.292274','2025-07-10 06:10:48',2,'0899cd30bbab4ea88220586e61002086',54),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjEyNzg2MCwiaWF0IjoxNzUyMDQxNDYwLCJqdGkiOiJmZjc0MmEzMDk0MmQ0YzQzYTMzZjVhNGIwYWQ0NjgxZiIsInVzZXJfaWQiOjV9.t5xbSIx58fWWc4RjeIe_9izbPWgdZdMUnKXDTUtdPFk','2025-07-09 06:11:00.026634','2025-07-10 06:11:00',5,'ff742a30942d4c43a33f5a4b0ad4681f',55),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjEyODAzNSwiaWF0IjoxNzUyMDQxNjM1LCJqdGkiOiJjNWUzYjlhZDk2Nzc0MDhkODAzODFjNWVkZDBkNTg0MCIsInVzZXJfaWQiOjJ9._WqR-4V92gKpBCNs2r3wqhSWeEkOSZJe_k4MzDzRxg8','2025-07-09 06:13:55.794123','2025-07-10 06:13:55',2,'c5e3b9ad9677408d80381c5edd0d5840',56),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjEyODA2OCwiaWF0IjoxNzUyMDQxNjY4LCJqdGkiOiIwNTMzOGNjMDQ5YmY0NWI0YmUwNWVkMDFiMTU5ODQ3YyIsInVzZXJfaWQiOjV9.D5fm6aJ3wE28YW2B6gPtor6dgJHfjDpuHVeBQHRpm1A','2025-07-09 06:14:28.267423','2025-07-10 06:14:28',5,'05338cc049bf45b4be05ed01b159847c',57),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjEyODc5NCwiaWF0IjoxNzUyMDQyMzk0LCJqdGkiOiJhNzJiODY4ODQ0YmQ0YjIwYjEyYjg0MDE3ZmYzMDg1ZCIsInVzZXJfaWQiOjJ9.Msz2zJ1IOq2inuAutMY8Ud3WCKfpTrh3Rw1A2ktE0oE','2025-07-09 06:26:34.979088','2025-07-10 06:26:34',2,'a72b868844bd4b20b12b84017ff3085d',58),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjEyODgwOCwiaWF0IjoxNzUyMDQyNDA4LCJqdGkiOiJkZDlmZDdkYzExZmQ0Y2IxOGJlZGIyMDYxNDViN2MxYiIsInVzZXJfaWQiOjV9.sTojFMC3ocRxjHQ4uvZeYDB8uWPxrfIozUAtmNNBSoY','2025-07-09 06:26:48.214880','2025-07-10 06:26:48',5,'dd9fd7dc11fd4cb18bedb206145b7c1b',59),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjEyOTMwOSwiaWF0IjoxNzUyMDQyOTA5LCJqdGkiOiJiNGM5ZDEzMjQ2OWE0YWZlYTdiNGI3NDFkMGU2OTQ2NSIsInVzZXJfaWQiOjV9.x_6N01JoME1KWLQFkM86ApukpP4i6BGTXdzc4hPHK6E','2025-07-09 06:35:09.790315','2025-07-10 06:35:09',5,'b4c9d132469a4afea7b4b741d0e69465',60),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjEyOTMzMCwiaWF0IjoxNzUyMDQyOTMwLCJqdGkiOiI0ZmE5OWQ0ZDY2NTY0NTMyYWM0Y2VhYjYzNTNlOGVjNiIsInVzZXJfaWQiOjJ9.Rl5ok9XSKXCZYfzMbEL_M9FvghMOXOq2GNdCmC9cIq8','2025-07-09 06:35:30.408119','2025-07-10 06:35:30',2,'4fa99d4d66564532ac4ceab6353e8ec6',61),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjEyOTM0NiwiaWF0IjoxNzUyMDQyOTQ2LCJqdGkiOiI2MTk4NGQ3MjQ1MTY0NDlmODBkODMyZjhiZDdkMGZhOSIsInVzZXJfaWQiOjV9.z9sn8h36dcaI9_dIo90KpMfrtD8oE6vYfZxlWbVW6To','2025-07-09 06:35:46.461547','2025-07-10 06:35:46',5,'61984d724516449f80d832f8bd7d0fa9',62),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjEzMDY5MCwiaWF0IjoxNzUyMDQ0MjkwLCJqdGkiOiJmOTkxYWJjODExYzU0MzZmYTRkOTZhYTI2MTM5ZDA5NyIsInVzZXJfaWQiOjJ9.izfEaxmxHg934MHTG8P5Lh5kn4u67l9NICDUtnWW-_U','2025-07-09 06:58:10.527603','2025-07-10 06:58:10',2,'f991abc811c5436fa4d96aa26139d097',63),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjEzMDc1MCwiaWF0IjoxNzUyMDQ0MzUwLCJqdGkiOiI1OTcyNDVmNzA0NjE0MzhlODIzN2ZlNjkwOTlhMDQxMiIsInVzZXJfaWQiOjV9.bOq6QhUO7j9-PxxxGCGlWgiXL8u6iDLtD764tEFhVOY','2025-07-09 06:59:10.041426','2025-07-10 06:59:10',5,'597245f70461438e8237fe69099a0412',64),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjEzMjMwMywiaWF0IjoxNzUyMDQ1OTAzLCJqdGkiOiJiMWNmZTY1YjU1NTg0MzY4OTE2Mzc0NDQyNWEwZDc4NCIsInVzZXJfaWQiOjJ9.jwsYWntdnh7A5u75IBkn2eJIufSmACRiL2UkoPd3uW4','2025-07-09 07:25:03.181075','2025-07-10 07:25:03',2,'b1cfe65b555843689163744425a0d784',65),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjEzMjMxOCwiaWF0IjoxNzUyMDQ1OTE4LCJqdGkiOiIyNjUwZTc3ZWFkNDc0NjU0OTMxOGY4OTI3Y2UxYmU2NiIsInVzZXJfaWQiOjV9.Yw67hID206b5zHixZGIyCefKkz6-prfAh27HyKerwaI','2025-07-09 07:25:18.687408','2025-07-10 07:25:18',5,'2650e77ead4746549318f8927ce1be66',66),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjEzNjU0NSwiaWF0IjoxNzUyMDUwMTQ1LCJqdGkiOiI1MzIxMzIwMjFkYmM0ZDJjOTk3YzlhMzNjNzU5ZWE3OSIsInVzZXJfaWQiOjJ9.MBE21R8rgoyj3mn1aYgK8PT6ipQgjUehizgPoaaxuHg','2025-07-09 08:35:45.697989','2025-07-10 08:35:45',2,'532132021dbc4d2c997c9a33c759ea79',67),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjEzNjU2OCwiaWF0IjoxNzUyMDUwMTY4LCJqdGkiOiJjMWY1ZGQ4ZjYxZjI0M2E2ODc3Nzc1MzFhMTQyYWNmMyIsInVzZXJfaWQiOjV9.GiiXdkiXkzauhjDQV55Fffv8f9F4HLFM7usZfdZGNvo','2025-07-09 08:36:08.601852','2025-07-10 08:36:08',5,'c1f5dd8f61f243a687777531a142acf3',68),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjEzNzY2MCwiaWF0IjoxNzUyMDUxMjYwLCJqdGkiOiI4NjA4YmEyM2U0NjU0NjZmYjcyNzQ5MzNmZTRmOTMyYyIsInVzZXJfaWQiOjJ9.Wl0k9s14lhfFxoslHTPoxCEg4Ro4dxOHVplUArLf4y8','2025-07-09 08:54:20.149207','2025-07-10 08:54:20',2,'8608ba23e465466fb7274933fe4f932c',69),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjEzNzY3OCwiaWF0IjoxNzUyMDUxMjc4LCJqdGkiOiI4MzBkMjMwY2M1Yzg0OGM3YTQ4OWUzODIxY2RmYzNjNyIsInVzZXJfaWQiOjJ9.8pkKVF1qPHvXgxlrxxN0RvlwrvFB1HolgHKDtTVqYeE','2025-07-09 08:54:38.530476','2025-07-10 08:54:38',2,'830d230cc5c848c7a489e3821cdfc3c7',70),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjEzNzY5MiwiaWF0IjoxNzUyMDUxMjkyLCJqdGkiOiJlNTVlMjM0ODU5ZWY0ZjQ5YjM4MzA2ZWFlYzU3MzNlMCIsInVzZXJfaWQiOjV9.uzcKKVSedtNMM9P-l3h9aAhN-mlwzsi57wLSQfjVMUg','2025-07-09 08:54:52.964464','2025-07-10 08:54:52',5,'e55e234859ef4f49b38306eaec5733e0',71),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjEzODAwMSwiaWF0IjoxNzUyMDUxNjAxLCJqdGkiOiI3OWE4M2Y4NDYxNTQ0MGI2YmI2YzU2NDExMDQ5ODkxMCIsInVzZXJfaWQiOjJ9.SsuxKhHrabc1TSsph5LT9mWA1BpQuIZSTWp0ORNIYn4','2025-07-09 09:00:01.755372','2025-07-10 09:00:01',2,'79a83f84615440b6bb6c564110498910',72),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjEzODAyNywiaWF0IjoxNzUyMDUxNjI3LCJqdGkiOiIzZGM0NDA1MjFmOTQ0YzI4YWE5MzA2NDJlYmRlMjk5MiIsInVzZXJfaWQiOjV9.fFGKb6v7mGaNNu6zEu826CsiVQc-Y0dpfR1CeOD5B0Q','2025-07-09 09:00:27.621450','2025-07-10 09:00:27',5,'3dc440521f944c28aa930642ebde2992',73),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjEzODA2NywiaWF0IjoxNzUyMDUxNjY3LCJqdGkiOiIwNjYzNmRjMDFmOTM0NzQ0OWYwMDhlYjcwMjg3MzI3OSIsInVzZXJfaWQiOjJ9.mqtMZS-hljW2zM9om3pYzIH4vjlVm-Y8rcTfrOVCWjM','2025-07-09 09:01:07.700983','2025-07-10 09:01:07',2,'06636dc01f9347449f008eb702873279',74),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjEzODEwNiwiaWF0IjoxNzUyMDUxNzA2LCJqdGkiOiIwMmJjYmRjY2IxZWY0NDQ3YjMyNjAyNzhhYmFlOGJmYyIsInVzZXJfaWQiOjV9.1xZQJ43UMAQ35TDxBClw5UbQMo9AfrLtWkwNBCm9FmI','2025-07-09 09:01:46.103048','2025-07-10 09:01:46',5,'02bcbdccb1ef4447b3260278abae8bfc',75),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjEzODEzMiwiaWF0IjoxNzUyMDUxNzMyLCJqdGkiOiI5MWFmY2U0NjU4MDE0NzZmOTNiYzMyYmQ0YzhjZDM5MCIsInVzZXJfaWQiOjJ9.Y88t12-XtppMKU6J3tJZ6m_TZX5nxmJE4quv8AZVrac','2025-07-09 09:02:12.596434','2025-07-10 09:02:12',2,'91afce465801476f93bc32bd4c8cd390',76),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjEzODE0NCwiaWF0IjoxNzUyMDUxNzQ0LCJqdGkiOiJjNTU0ZTMwYzBmMzc0YjAwOGJjZmIyYmZhYzE2MjM0ZiIsInVzZXJfaWQiOjV9.OcSHDVZsSj5Y9cqn4RM8_pTCsJXqVezPdJsVy4ZEAF8','2025-07-09 09:02:24.036101','2025-07-10 09:02:24',5,'c554e30c0f374b008bcfb2bfac16234f',77),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjEzODQzOSwiaWF0IjoxNzUyMDUyMDM5LCJqdGkiOiIyZmI0YjNlM2YxMGM0MWI4OTgzNTEwNGYzMDJhNWI3OSIsInVzZXJfaWQiOjJ9.bYs7A-hg7uV6808TatCrg5upEveQ2vJdFb-27f4uKwo','2025-07-09 09:07:19.760458','2025-07-10 09:07:19',2,'2fb4b3e3f10c41b89835104f302a5b79',78),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjEzODQ2MiwiaWF0IjoxNzUyMDUyMDYyLCJqdGkiOiIwYjY0NDhmZTNiNWU0OTcwOGQ1ZjE0MDgxYzliY2I4YSIsInVzZXJfaWQiOjV9.oKPgS-ImxD3MIO-VVv50eCZmt5w1hHzBuHRVavjg1nY','2025-07-09 09:07:42.656503','2025-07-10 09:07:42',5,'0b6448fe3b5e49708d5f14081c9bcb8a',79),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjE0Njc4MCwiaWF0IjoxNzUyMDYwMzgwLCJqdGkiOiI2Y2M3ODU3NWRlODE0NDZlODAzNzM0MjIyZTM3NWZkOSIsInVzZXJfaWQiOjN9.ejcwNtQQGOHZ-9JOCmfsPdOch-ZBBRF2nkVc_Et0FqA','2025-07-09 11:26:20.063683','2025-07-10 11:26:20',3,'6cc78575de81446e803734222e375fd9',80),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjE0NjgwMSwiaWF0IjoxNzUyMDYwNDAxLCJqdGkiOiI1NDczMGI5NjI5ZjU0OWI1ODZmMzExMTU4NmU0NzVjMSIsInVzZXJfaWQiOjV9.wx-cKfK8NLFgcQCEXcZ3EugjpQuoZQOh8kbfj-m7dL8','2025-07-09 11:26:41.426666','2025-07-10 11:26:41',5,'54730b9629f549b586f3111586e475c1',81),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjE1MTAzOSwiaWF0IjoxNzUyMDY0NjM5LCJqdGkiOiJiYzkzMzY0ZGQ1NjY0MWQ3ODliNTljNmUzZmJjOGZlYiIsInVzZXJfaWQiOjJ9.oT0qe_vnl4Ot8mt_jccFoDeE30IsughRvyNG1eVhrpc','2025-07-09 12:37:19.685164','2025-07-10 12:37:19',2,'bc93364dd56641d789b59c6e3fbc8feb',82),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjE1MTg0MCwiaWF0IjoxNzUyMDY1NDQwLCJqdGkiOiI5ZjZiN2NjMTAxYzI0MDU5YTVhOGExZDFlNGI2NzBjZSIsInVzZXJfaWQiOjV9.cfi3EYrB42C6Y8sLmWrahFMR5pKjmqFQc7vtf7grV-A','2025-07-09 12:50:40.016019','2025-07-10 12:50:40',5,'9f6b7cc101c24059a5a8a1d1e4b670ce',83),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjIwNzk0NywiaWF0IjoxNzUyMTIxNTQ3LCJqdGkiOiIyMWFhZTI1OTVlOWM0OWIyOGViYTU3MjdjOWFlNWU1ZCIsInVzZXJfaWQiOjd9.7Q-GIf3q3ShSfnt6Mt2OyVGH8BdfwzGwqLRADoL4Gk4','2025-07-10 04:25:47.026049','2025-07-11 04:25:47',NULL,'21aae2595e9c49b28eba5727c9ae5e5d',84),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjIwOTI0OSwiaWF0IjoxNzUyMTIyODQ5LCJqdGkiOiJjMTYwMDhiNjFlZDU0YTkzYmUyMTE0N2YyM2FmMTRjMCIsInVzZXJfaWQiOjV9.Zv0tb-UbYzu7sNiwv62cju9WtxxBePQPJeC-ow2T3TM','2025-07-10 04:47:29.202861','2025-07-11 04:47:29',5,'c16008b61ed54a93be21147f23af14c0',85),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjIxMjU0NSwiaWF0IjoxNzUyMTI2MTQ1LCJqdGkiOiIxMWRmYjFjZDIzZWY0MzVjYjc2MTAwYWQ0M2ViMGIyYyIsInVzZXJfaWQiOjJ9.w23x2HUjwuyZHaHZ1RoxdlSgzNiqtUvDh3qVHsvaRIY','2025-07-10 05:42:25.505980','2025-07-11 05:42:25',2,'11dfb1cd23ef435cb76100ad43eb0b2c',86),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjIyNDUyNywiaWF0IjoxNzUyMTM4MTI3LCJqdGkiOiJjYzc1YzMwNTM5OWQ0OTc1YjE5NmU4OGVhM2MyMTYyMCIsInVzZXJfaWQiOjR9.mq7YMFTJtmHoFoGgbVqlQr8s453ts8vNoJ194EkA3Yc','2025-07-10 09:02:07.796831','2025-07-11 09:02:07',4,'cc75c305399d4975b196e88ea3c21620',87),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjIyNTQ4NywiaWF0IjoxNzUyMTM5MDg3LCJqdGkiOiJmYzNjMTQ4YTFhZTk0ZDgxYTUxOTYxMDI0OTk0ZGFhNSIsInVzZXJfaWQiOjJ9.RL7IRVsurnnUEB0At7si5NJZJXL5eDhKbiJfMaRrMxQ','2025-07-10 09:18:07.491389','2025-07-11 09:18:07',2,'fc3c148a1ae94d81a51961024994daa5',88),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjIyNTg2NCwiaWF0IjoxNzUyMTM5NDY0LCJqdGkiOiJkNzMyNjg0MGVmZGM0MTQ2OGQ4YmY2MjUwMGVmMzA4YyIsInVzZXJfaWQiOjN9.8TL9ImAs4o0J3a61LTMyonB-mn20bQcfYeSXrgvs63M','2025-07-10 09:24:24.678774','2025-07-11 09:24:24',3,'d7326840efdc41468d8bf62500ef308c',89),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjIyNTg3NywiaWF0IjoxNzUyMTM5NDc3LCJqdGkiOiIxNzk0ZGU2YWI2NTY0ZGUyYjFiYzFkZjk1NDU5YmM4ZSIsInVzZXJfaWQiOjV9.B12qMaOvLHAnsx_3qVTFbtYpL1O6l63dJiWHK9RC-b8','2025-07-10 09:24:37.624917','2025-07-11 09:24:37',5,'1794de6ab6564de2b1bc1df95459bc8e',90),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjIyNzk3OSwiaWF0IjoxNzUyMTQxNTc5LCJqdGkiOiI4NTI4MjQ4NzJlZmU0YzE5YThhMDdiMTAwNzg1NjM0MiIsInVzZXJfaWQiOjR9.2TbvJM3KuXnoQXQSjUHmvaseeVzw2cWncAKhpq_IdOA','2025-07-10 09:59:39.726425','2025-07-11 09:59:39',4,'852824872efe4c19a8a07b1007856342',91),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjIzMjYzNSwiaWF0IjoxNzUyMTQ2MjM1LCJqdGkiOiI4N2M2YjVmOTRjMDE0OTRiYWUwMGFkMzIxMTQ0M2FlOCIsInVzZXJfaWQiOjJ9.4FppCRJinMyTOtRDS3ngY_MFyGQXT7BXrHRRAIu2K6Q','2025-07-10 11:17:15.358966','2025-07-11 11:17:15',2,'87c6b5f94c01494bae00ad3211443ae8',92),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjIzMzU1OCwiaWF0IjoxNzUyMTQ3MTU4LCJqdGkiOiI0NDc2ZDdmOTg4Njk0NTQwOGZlNmQ1YzA0MjI4NTIyMiIsInVzZXJfaWQiOjV9.1n_l452_n1-l9zZnqLpHsRECJ9pE1l3kvNuiZz1gatw','2025-07-10 11:32:38.552647','2025-07-11 11:32:38',5,'4476d7f9886945408fe6d5c042285222',93),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjI5NTk5NiwiaWF0IjoxNzUyMjA5NTk2LCJqdGkiOiIzMDFkNTFlNDhjODU0MDI4YWFlNTk2MDVhN2UyZWYwMyIsInVzZXJfaWQiOjV9.uVPJlz4sY3XxMU70-UVRhrByAL5Mc06QD0l-HC6NfUc','2025-07-11 04:53:16.524643','2025-07-12 04:53:16',5,'301d51e48c854028aae59605a7e2ef03',94),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjI5ODE1NywiaWF0IjoxNzUyMjExNzU3LCJqdGkiOiI2OTQwYjIwNGQ3NDQ0NGYxYjRiZDMzNzgxOTM5MDk1ZSIsInVzZXJfaWQiOjJ9.5i11_mtZkYivL1EKyA1EPLs1gZdzSNASom-2Hg3Lxuw','2025-07-11 05:29:17.001838','2025-07-12 05:29:17',2,'6940b204d74444f1b4bd33781939095e',95),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjI5ODMzNywiaWF0IjoxNzUyMjExOTM3LCJqdGkiOiI1ZjM5ZDEzNWVjOWI0MjRmOGY3MDM2ODY0YWZkNGEzNSIsInVzZXJfaWQiOjV9.1MSICYBnFYubk3Ijl9ypg8aE74MpzJHg44oObSnhKOE','2025-07-11 05:32:17.287794','2025-07-12 05:32:17',5,'5f39d135ec9b424f8f7036864afd4a35',96),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjMwMzAzNCwiaWF0IjoxNzUyMjE2NjM0LCJqdGkiOiI4Mzk0NDk3MmFlOGI0NWZmODkyNmJjMzU0MGQ3NmVhYyIsInVzZXJfaWQiOjJ9.KjfLe0w9bHf-KHkCMPFfFZazcMDBATYjpAd36MBN_Ek','2025-07-11 06:50:34.971876','2025-07-12 06:50:34',2,'83944972ae8b45ff8926bc3540d76eac',97),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjMwMzA1MiwiaWF0IjoxNzUyMjE2NjUyLCJqdGkiOiJmZDdiODhlYWJmZTc0NjEwOGE5MzY2ZWM1NDRjZWZhZCIsInVzZXJfaWQiOjV9.723rQcH_ZRbuZJWj2WwE4ia6EhMK9NL_-BlIv0wRsuY','2025-07-11 06:50:52.250850','2025-07-12 06:50:52',5,'fd7b88eabfe746108a9366ec544cefad',98),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjM4MDgxNiwiaWF0IjoxNzUyMjk0NDE2LCJqdGkiOiJkZjRlNzM1MGU5ZDk0ZjNhYTA5NDcxMjgyOGY2NGFmYSIsInVzZXJfaWQiOjV9.dLIj7afWfUABgdL634lhDKPomaHQA0x_Hb8SMO02YMs','2025-07-12 04:26:56.245269','2025-07-13 04:26:56',5,'df4e7350e9d94f3aa094712828f64afa',99),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjM4MzQzMSwiaWF0IjoxNzUyMjk3MDMxLCJqdGkiOiI3NzQ2OWQ3NDFlYjE0YTMyYWYyMjBkYTA3ZTFhOTBiMiIsInVzZXJfaWQiOjV9.PHY1APm24-rH6G34nXdianpzgFPygAoHxhat27nCFdo','2025-07-12 05:10:31.493032','2025-07-13 05:10:31',5,'77469d741eb14a32af220da07e1a90b2',100),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjM4NDE0NywiaWF0IjoxNzUyMjk3NzQ3LCJqdGkiOiIyNmE3MjViYTRkZDU0MmZkODY5ZDBmYWYwZTYzZjMzZCIsInVzZXJfaWQiOjJ9.KkUYjpd9B4tDQuCge-UqvAlRtJRisUVZaGMq7Vg5zKM','2025-07-12 05:22:27.808459','2025-07-13 05:22:27',2,'26a725ba4dd542fd869d0faf0e63f33d',101),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjM4NDI5OSwiaWF0IjoxNzUyMjk3ODk5LCJqdGkiOiI3ZTdkZjBlZWM5MGQ0NTkyYjRiNmZjOWQyZDQ0MmM0NyIsInVzZXJfaWQiOjV9.OrleBwnSU8DwZdLHzx-sP-XGogbJ8xMYt4jqp0hkstE','2025-07-12 05:24:59.066132','2025-07-13 05:24:59',5,'7e7df0eec90d4592b4b6fc9d2d442c47',102),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjM4NDQxMCwiaWF0IjoxNzUyMjk4MDEwLCJqdGkiOiI3M2RkNWJhM2U2ODM0YThiODY1ZWNlZjNhMjgyZTQyMyIsInVzZXJfaWQiOjJ9.q_-VY6dDvKDyM77ZtnvkspKHCvnaNa1fhbg9i_4mDks','2025-07-12 05:26:50.057274','2025-07-13 05:26:50',2,'73dd5ba3e6834a8b865ecef3a282e423',103),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjM4NDQzMiwiaWF0IjoxNzUyMjk4MDMyLCJqdGkiOiI2ZmZlNTQwNzk2ODQ0MTRhODBkMGI4YTgxNWJkODZkOSIsInVzZXJfaWQiOjV9.NsrXJ-gVE4zKxphdWcfuYM5ZcL5JI2wBNUBVLedak7k','2025-07-12 05:27:12.272102','2025-07-13 05:27:12',5,'6ffe54079684414a80d0b8a815bd86d9',104),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjM4NTE0NywiaWF0IjoxNzUyMjk4NzQ3LCJqdGkiOiIyYjM3MDQyMjY2NWM0MjJmYmNhNzUxZTMzZGZiNzc0MyIsInVzZXJfaWQiOjJ9.3ieO23ed7hGK3lt6BnPge2_fp46ruBBDTiK7WlAyibI','2025-07-12 05:39:07.054898','2025-07-13 05:39:07',2,'2b370422665c422fbca751e33dfb7743',105),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjU3ODk4MywiaWF0IjoxNzUyNDkyNTgzLCJqdGkiOiIxNzViYzQzOGNhOTE0OGIzYmFjNTU3OTI0M2QzZjk1ZiIsInVzZXJfaWQiOjN9.OXafJElHmZJdWoBkYN0nwA2tkrL_9e5ldWQjH6k4XRE','2025-07-14 11:29:43.980988','2025-07-15 11:29:43',3,'175bc438ca9148b3bac5579243d3f95f',106),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjU3OTAwMywiaWF0IjoxNzUyNDkyNjAzLCJqdGkiOiJlNTFhM2M3Nzg3MDU0MjlkYmQxYmRkZDRlYmYxMGNiNiIsInVzZXJfaWQiOjV9.dQSXhyUjvTNcFmBp65X0ubAZIT0beoWY-n6kFvxWwqM','2025-07-14 11:30:03.881696','2025-07-15 11:30:03',5,'e51a3c778705429dbd1bddd4ebf10cb6',107),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjU3OTAzNywiaWF0IjoxNzUyNDkyNjM3LCJqdGkiOiJhMWNlNTljYjJhZTQ0YmQxYTZhYzE5MzBhOTlmZTdhMyIsInVzZXJfaWQiOjJ9.QYCQZ-DrtrPDeRhSozlhgMtlOSIhTUvy806-PpM_o4E','2025-07-14 11:30:37.428360','2025-07-15 11:30:37',2,'a1ce59cb2ae44bd1a6ac1930a99fe7a3',108),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjY0MTc2OCwiaWF0IjoxNzUyNTU1MzY4LCJqdGkiOiI2NWJiZmFmM2UwNmY0ZDI2ODAwZWM3OWRkNDU5OWM5MCIsInVzZXJfaWQiOjJ9.vtDtT1MyWkrILSDre-6w6tixBtJFMvoalLQMdg6XHJg','2025-07-15 04:56:08.127386','2025-07-16 04:56:08',2,'65bbfaf3e06f4d26800ec79dd4599c90',109),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjcyNjYzMSwiaWF0IjoxNzUyNjQwMjMxLCJqdGkiOiI1MGI3NzgyNjRjYTE0YjBhODhhMzlkMWM0YzExN2JmOSIsInVzZXJfaWQiOjV9.syD82v2VvhAemYAHlRCDAGmQvZOfkqdvTgWUfm3byTo','2025-07-16 04:30:31.649317','2025-07-17 04:30:31',5,'50b778264ca14b0a88a39d1c4c117bf9',110),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjcyNjc5MSwiaWF0IjoxNzUyNjQwMzkxLCJqdGkiOiI2YWE4MDQ3NzQxOWY0ZDFmYTYwYjE3YTdjMTU5N2IyMSIsInVzZXJfaWQiOjJ9.fsecOMsnfy2tIUFV-02iTwQzm_pTWoxQgh24f9rGy3k','2025-07-16 04:33:11.918874','2025-07-17 04:33:11',2,'6aa80477419f4d1fa60b17a7c1597b21',111),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjcyNjg4NywiaWF0IjoxNzUyNjQwNDg3LCJqdGkiOiIwYmJhOWY3ZDg2ZmE0YTQ4YjI5ZjNmZjY1ZmUyOTgxNyIsInVzZXJfaWQiOjV9.LEk4W_3h3ToIb5wPsa1SeNuIV6XZAT8BzsZUW1Zy488','2025-07-16 04:34:47.549697','2025-07-17 04:34:47',5,'0bba9f7d86fa4a48b29f3ff65fe29817',112),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjcyNjkwNCwiaWF0IjoxNzUyNjQwNTA0LCJqdGkiOiIwMjkzYjc1MGMyMmQ0NGJhOTBiMGIwMmZmNTZlOWU5MCIsInVzZXJfaWQiOjJ9.UhRVlpiyx27aNMxv3P00kAkdIpfyu0isXCTPDcOXrgU','2025-07-16 04:35:04.910559','2025-07-17 04:35:04',2,'0293b750c22d44ba90b0b02ff56e9e90',113),
 ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjgxNTA0OCwiaWF0IjoxNzUyNzI4NjQ4LCJqdGkiOiJjYzY3Mjc0MjcxZmM0MTEyOTBjMmVjODNlZTViMDIzOCIsInVzZXJfaWQiOjV9.sBPsFAF3sdZZzNn6UR__csUdFPNE4vjB7m5IaqjJjaY','2025-07-17 05:04:08.728209','2025-07-18 05:04:08',5,'cc67274271fc411290c2ec83ee5b0238',114);
INSERT INTO "app_mykyc" ("id","name","age","fathername","mobile_number","address","profession","contactSH","nameSH","investmentamt","passportphoto","is_hidden","created_by_id","user_id","aadhar_back_image","aadhar_front_image","aadhar_number") VALUES (3,'prasanthh',26,'fathernameeee','7845124513','ADDRESSsss','PROFESSIONss','CONTACT SHss','NAME SHss',784,'passport/Ganesh_Traders_logo.png',1,4,4,'pan/Footer_logo_Tgoklv7.png','aadhar/Ganesh_Traders_logo.png','6666 6666 6666'),
 (5,'testing name',45,'testing father name','8956235623','Address','Profession','Contact SH','Name sh',785000,'passport/Footer_logo_TjB1HrC.png',0,2,2,'pan/Ganesh_Traders_logo_TrJ21Tt.png','aadhar/Footer_logo_i8GrT2d.png','7777 7777 7777'),
 (9,'sam',25,'father name','7845124512','address','profession','contact','name',758000,'passport/Footer_logo_1k6ug64.png',0,2,2,'pan/Footer_logo_zPqmpy6.png','aadhar/Footer_logo_TWkJvGv.png','4444'),
 (10,'sam',25,'father name','7845124512','address','profession','contact sh','name sh',758000,'passport/Footer_logo_TG7YMH8.png',0,2,4,'pan/Footer_logo_9uAtZpH.png','aadhar/Footer_logo_zLuWmpi.png','5454'),
 (12,'ram vigneshhh',27,'father nameeeee','7845124513','addresssss','professionnnnn','7845124512','name shsss',400012,'passport/Ganesh_Traders_logo_hmIKFwJ.png',0,5,5,'pan/Ganesh_Traders_logo_igAldss.png','aadhar/Ganesh_Traders_logo_2OTKXPf.png','9999 9999 9999'),
 (13,'sam',22,'fathername','7845124512','address','profession','7845124522','name',45000,'passport/Footer_logo_4YVTuxP.png',0,5,5,'pan/Footer_logo_nyplJeI.png','aadhar/Footer_logo_2mBNAaV.png','4444'),
 (14,'Kumar',24,'Father name','7845124512','address','profession','7845124512','name',75000,'passport/Footer_logo_LqPycMD.png',0,4,4,'pan/Footer_logo_7DJ9hFD.png','aadhar/Footer_logo_5V8giov.png','4444 4444 4444'),
 (24,'Pranesh',22,'Father Name','7845124512','Address','Profession','7845124512','Name of the Leader',100000,'passport/Ganesh_Traders_logo_INaoEDo.png',0,5,5,'pan/Footer_logo_UZ8ZqKj.png','aadhar/Footer_logo_4LE8w5n.png','8888 8888 8888'),
 (25,'pranesh kumar',35,'Father pranesh','7845124512','Address','profession','7845124512','Name of the Leader',40000,'passport/Footer_logo_TmWH1Iq.png',0,5,5,'pan/Footer_logo_EHYZ75t.png','aadhar/Footer_logo_6lAma2Q.png','4444 4444 4444');
INSERT INTO "app_bondimage" ("id","image","companyname","projectname","customer_id","my_kyc_id","sub_kyc_id","amount","investment_date") VALUES (44,'bonds/Footer_logo_t7G103i.png','Company namee','project nameee','112',12,NULL,20012,'2025-07-10'),
 (45,'bonds/Footer_logo_xWnB6lU.png','company name','project name','1234',13,NULL,4000,'2025-07-09'),
 (46,'bonds/Footer_logo_CtX25aR.png','Company','project','45',14,NULL,75000,'2025-07-10'),
 (54,'bonds/Ganesh_Traders_logo_PNQat34.png','Company Nameeeee','Project Nameeeee','3',24,NULL,5000,'2025-07-12'),
 (55,'bonds/Ganesh_Traders_logo_ecmTU6C.png','Company Nameeee 2','Project Nameee 2','02',24,NULL,2500,'2025-07-10'),
 (56,'bonds/Ganesh_Traders_logo_XZxt9rk.png','Company Nameee 1','Project Nameee 1','03',24,NULL,2500,'2025-07-10'),
 (57,'bonds/Footer_logo_v8QqMYb.png','phoenix','project','11',25,NULL,20000,'2025-07-16'),
 (58,'bonds/Footer_logo_9jo5cHW.png','Phoneix 22','Project 22','22',25,NULL,20000,'2025-07-15');
CREATE UNIQUE INDEX IF NOT EXISTS "django_content_type_app_label_model_76bd3d3b_uniq" ON "django_content_type" (
	"app_label",
	"model"
);
CREATE UNIQUE INDEX IF NOT EXISTS "auth_group_permissions_group_id_permission_id_0cd325b0_uniq" ON "auth_group_permissions" (
	"group_id",
	"permission_id"
);
CREATE INDEX IF NOT EXISTS "auth_group_permissions_group_id_b120cbf9" ON "auth_group_permissions" (
	"group_id"
);
CREATE INDEX IF NOT EXISTS "auth_group_permissions_permission_id_84c5c92e" ON "auth_group_permissions" (
	"permission_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "auth_permission_content_type_id_codename_01ab375a_uniq" ON "auth_permission" (
	"content_type_id",
	"codename"
);
CREATE INDEX IF NOT EXISTS "auth_permission_content_type_id_2f476e4b" ON "auth_permission" (
	"content_type_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "app_user_groups_user_id_group_id_73b8e940_uniq" ON "app_user_groups" (
	"user_id",
	"group_id"
);
CREATE INDEX IF NOT EXISTS "app_user_groups_user_id_e6f878f6" ON "app_user_groups" (
	"user_id"
);
CREATE INDEX IF NOT EXISTS "app_user_groups_group_id_e774d92c" ON "app_user_groups" (
	"group_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "app_user_user_permissions_user_id_permission_id_7c8316ce_uniq" ON "app_user_user_permissions" (
	"user_id",
	"permission_id"
);
CREATE INDEX IF NOT EXISTS "app_user_user_permissions_user_id_24780b52" ON "app_user_user_permissions" (
	"user_id"
);
CREATE INDEX IF NOT EXISTS "app_user_user_permissions_permission_id_4ef8e133" ON "app_user_user_permissions" (
	"permission_id"
);
CREATE INDEX IF NOT EXISTS "django_admin_log_content_type_id_c4bce8eb" ON "django_admin_log" (
	"content_type_id"
);
CREATE INDEX IF NOT EXISTS "django_admin_log_user_id_c564eba6" ON "django_admin_log" (
	"user_id"
);
CREATE INDEX IF NOT EXISTS "app_user_parent_user_id_81d2dd74" ON "app_user" (
	"parent_user_id"
);
CREATE INDEX IF NOT EXISTS "django_session_expire_date_a5c62663" ON "django_session" (
	"expire_date"
);
CREATE INDEX IF NOT EXISTS "token_blacklist_outstandingtoken_user_id_83bc629a" ON "token_blacklist_outstandingtoken" (
	"user_id"
);
CREATE INDEX IF NOT EXISTS "app_subkyc_created_by_id_ba735361" ON "app_subkyc" (
	"created_by_id"
);
CREATE INDEX IF NOT EXISTS "app_subkyc_user_id_7035a348" ON "app_subkyc" (
	"user_id"
);
CREATE INDEX IF NOT EXISTS "app_mykyc_created_by_id_098b0686" ON "app_mykyc" (
	"created_by_id"
);
CREATE INDEX IF NOT EXISTS "app_mykyc_user_id_c325d8c0" ON "app_mykyc" (
	"user_id"
);
CREATE INDEX IF NOT EXISTS "app_bondimage_my_kyc_id_f8ce6f5f" ON "app_bondimage" (
	"my_kyc_id"
);
CREATE INDEX IF NOT EXISTS "app_bondimage_sub_kyc_id_a038dbc1" ON "app_bondimage" (
	"sub_kyc_id"
);
COMMIT;
