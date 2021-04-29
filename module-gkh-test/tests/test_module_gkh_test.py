# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 GEO Secretariat.
#
# Module-GKH-Test is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

"""Module tests."""

from flask import Flask

from module_gkh_test import ModuleGKHTest


def test_version():
    """Test version import."""
    from module_gkh_test import __version__
    assert __version__


def test_init():
    """Test extension initialization."""
    app = Flask('testapp')
    ext = ModuleGKHTest(app)
    assert 'module-gkh-test' in app.extensions

    app = Flask('testapp')
    ext = ModuleGKHTest()
    assert 'module-gkh-test' not in app.extensions
    ext.init_app(app)
    assert 'module-gkh-test' in app.extensions


def test_view(base_client):
    """Test view."""
    res = base_client.get("/")
    assert res.status_code == 200
    assert 'Welcome to Module-GKH-Test' in str(res.data)
