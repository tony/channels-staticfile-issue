import os
from pathlib import Path

PROJECT_DIR = Path(__file__).resolve().parent

BASE_DIR = PROJECT_DIR.parent
PROJECT_STATIC_DIR = PROJECT_DIR / 'static'

SECRET_KEY = os.getenv(
    'SECRET_KEY', 'django-insecure-m9oab3i8ic!wbuqmrxe61sd69mmnq(*=2-65_rn6e^*kd_9bf#'
)

USE_TZ = False
STATIC_URL = '/static/'
STATIC_ROOT = os.getenv('STATIC_ROOT', PROJECT_STATIC_DIR)

STATICFILES_DIRS = []
DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

TRUTHY = [
    True,
    'True',
    'true',
    '1',
    'on',
]

DEBUG = os.getenv('DEBUG', True) in TRUTHY
APPEND_STATICFILES_URLPATTERN = (
    os.getenv('APPEND_STATICFILES_URLPATTERN', True) in TRUTHY
)

ALLOWED_HOSTS = ["*"]

INSTALLED_APPS = ['test_app.homepage']
INSTALLED_APPS.append('django.contrib.staticfiles')

USE_WHITENOISE = os.getenv('USE_WHITENOISE') in TRUTHY


MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

if USE_WHITENOISE:
    MIDDLEWARE.append('whitenoise.middleware.WhiteNoiseMiddleware')

ROOT_URLCONF = 'test_app.urls'

LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',
        },
    },
    'root': {
        'handlers': ['console'],
        'level': 'WARNING',
    },
    'loggers': {
        'django': {
            'handlers': ['console'],
            'level': os.getenv('DJANGO_LOG_LEVEL', 'INFO'),
            'propagate': False,
        },
    },
}
