from django.db import models

import django_extensions.db.fields


class MyModel(models.Model):
    title = models.CharField(max_length=255)
