import os

# When you change the INSTALLED_APPS here
# Ensure that you change the
# openwisp_dashboard/migrate_settings.py
# as well to ensure that correct migrations
# take place.
INSTALLED_APPS = [
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'openwisp_utils.admin_theme',
    'django.contrib.admin',
    'django.contrib.sites',
    'allauth',
    'allauth.account',
    'allauth.socialaccount',
    'openwisp_users'
]

CORS_ORIGIN_ALLOW_ALL = bool(
    os.environ['DJANGO_DASHBOARD_CORS_ORIGIN_ALLOW_ALL'])

OPENWISP_ORGANIZATON_USER_ADMIN = True
OPENWISP_ORGANIZATON_OWNER_ADMIN = True
