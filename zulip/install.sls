# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "zulip/map.jinja" import zulip with context %}

{% if grains.oscodename == "xenial" %}
zulip_remove_upstart:
  pkg.purged:
    - name: upstart
{% endif %}

zulip-pkg:
  archive.extracted:
    - name: {{ zulip.archive.name }}
    - source: {{ zulip.archive.source }}
    - source_hash: {{zulip.archive.hash}}
    - archive_format: tar
    - if_missing: {{ zulip.archive.fin_dir }}

zulip_mv_archive:
  cmd.run:
    - name: mv {{zulip.archive.name}}/{{zulip.archive.ext_dir}} {{zulip.archive.fin_dir}}
    - unless: ls {{zulip.archive.fin_dir}}
    - require:
      - archive: zulip-pkg

zulip_cert:
  file.managed:
    - name: {{ zulip.cert_location }}/{{ zulip.cert}}
    - source: salt://zulip/files/{{ zulip.cert}}
    - user: root
    - group: root
    - mode: 0644
    
zulip_key:
  file.managed:
    - name: {{ zulip.key_location }}/{{ zulip.key }}
    - source: salt://zulip/files/{{ zulip.key }}
    - user: root
    - group: root
    - mode: 0600

zulip_install_script:
  cmd.run:
    - name: {{ zulip.archive.fin_dir }}/scripts/setup/install
    - unless: ls /etc/zulip
    - require:
      - cmd: zulip_mv_archive
