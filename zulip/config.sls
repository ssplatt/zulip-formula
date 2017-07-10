# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "zulip/map.jinja" import zulip with context %}

zulip_config:
  file.managed:
    - name: /etc/zulip/settings.py
    - source: salt://zulip/files/settings.py.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
    - makedirs: true
    
zulip_init_db:
 cmd.run:
   - name: /home/zulip/deployments/current/scripts/setup/initialize-database
   - runas: zulip
   - unless: psql -d zulip -c "\dt" | grep "(38 rows)"
   - onchanges:
     - cmd: zulip_install_script
