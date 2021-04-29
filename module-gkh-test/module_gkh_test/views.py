# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 GEO Secretariat.
#
# Module-GKH-Test is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

"""Invenio test module for the GEO Knowledge Hub"""



from flask import Blueprint, render_template
from flask_babelex import gettext as _

from .search import RecentRecordsSearch

blueprint = Blueprint(
    'module_gkh_test',
    __name__,
    template_folder='templates',
    static_folder='static',
)


@blueprint.route("/module-gkh-test")
def index():
    """Render a basic view."""
    return render_template(
        "module_gkh_test/index.html",
        records=RecentRecordsSearch()[:1].sort("-created").execute(),
    )
