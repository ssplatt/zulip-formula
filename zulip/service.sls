# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from "zulip/map.jinja" import zulip with context %}

# zulip-service:
#   service.{{ zulip.service.state }}:
#     - name: {{ zulip.service.name }}
#     - enable: {{ zulip.service.enable }}
#     - reload: {{ zulip.service.reload }}

zulip_service_restart:
  cmd.run:
    - name: /home/zulip/deployments/current/scripts/restart-server
    - runas: zulip
    - onchanges:
      - file: zulip_config
