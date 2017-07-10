# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "zulip/map.jinja" import zulip with context %}
{% if zulip.enabled %}
include:
  - zulip.install
  - zulip.config
  - zulip.service
{% else %}
'zulip-formula disabled':
  test.succeed_without_changes
{% endif %}
