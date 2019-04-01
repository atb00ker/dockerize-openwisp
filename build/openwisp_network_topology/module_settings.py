import os

INSTALLED_APPS = [
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'openwisp_utils.admin_theme',
    # all-auth
    'django.contrib.sites',
    'allauth',
    'allauth.account',
    'allauth.socialaccount',
    # openwisp2 modules
    'openwisp_users',
    'openwisp_network_topology',
    # admin
    'django.contrib.admin',
    # rest framework
    'rest_framework'
]

EXTENDED_APPS = ['django_netjsongraph']

TEST_RUNNER = 'django_netjsongraph.tests.utils.LoggingDisabledTestRunner'

OPENWISP_ORGANIZATON_USER_ADMIN = True
OPENWISP_ORGANIZATON_OWNER_ADMIN = True
