from django.apps import AppConfig


class HomePageConfig(AppConfig):
    name = "test_app.homepage"
    verbose_name = "Homepage"

    def ready(self):
        import sys

        print(f'python: {sys.version}')

        import django

        print(f'django: {django.__version__}')

        import asgiref

        print(f'asgiref: {asgiref.__version__}')

        import channels

        print(f'channels: {channels.__version__}')
