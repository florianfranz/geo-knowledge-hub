"""Frontpage records."""

from __future__ import absolute_import, print_function

from elasticsearch_dsl.query import Q
from invenio_search.api import RecordsSearch


class RecentRecordsSearch(RecordsSearch):
    """Search class for recent records."""

    class Meta:
        """Default index and filter for search."""

        index = "rdmrecords-records"
        default_filter = Q(
            "query_string", query=(
                "access.record:public " "AND versions.is_latest:true"))
