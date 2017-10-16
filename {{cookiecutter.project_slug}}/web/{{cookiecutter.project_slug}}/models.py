# -*- coding: utf-8 -*-
"""Models"""
from django.db import models
from django.utils.translation import ugettext, ugettext_lazy as _

from cms.models import CMSPlugin

from filer.fields.image import FilerImageField
from django.utils.encoding import python_2_unicode_compatible

# @python_2_unicode_compatible
# class ExampleModel(CMSPlugin):
#     """Renders a card with a team member."""
#     name = models.CharField(
#         max_length=100,
#         verbose_name=_('Name'),
#         blank=True,
#         help_text=_('Provide a name of the team member.')
#     )
