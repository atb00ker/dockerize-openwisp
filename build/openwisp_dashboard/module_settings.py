import os

INSTALLED_APPS = [
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'openwisp_utils.admin_theme',
    'django.contrib.admin',
    'django.contrib.sites',
    'django_extensions',
    'openwisp_users.accounts',  # only needed in test env
    'allauth',
    'allauth.account',
    'allauth.socialaccount',
    'openwisp_users'
]

CORS_ORIGIN_ALLOW_ALL = bool(os.environ['DJANGO_CORS_ORIGIN_ALLOW_ALL'])

OPENWISP_ORGANIZATON_USER_ADMIN = True
OPENWISP_ORGANIZATON_OWNER_ADMIN = True
