from django.conf import settings
from django.http import HttpResponse
from django.templatetags.static import static
from django.urls import path


def simple_view(request):
    file = static('apple.svg')
    return HttpResponse(f'<img src="{file}" />')


urlpatterns = [path('', simple_view)]

if (
    'django.contrib.staticfiles' in settings.INSTALLED_APPS
    and settings.APPEND_STATICFILES_URLPATTERN
):
    from django.contrib.staticfiles.urls import staticfiles_urlpatterns

    urlpatterns += staticfiles_urlpatterns()
