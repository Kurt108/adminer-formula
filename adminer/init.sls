{% from "adminer/map.jinja" import adminer, sls_block with context %}

include:
  - nginx.ng.config
  - nginx.ng.service
  - nginx.ng.vhosts




{{ adminer.base_dst }}:
  file.directory:
    - name: {{ adminer.base_dst }}/
    - user: {{ adminer.user }}


index.php:
  file.managed:
    - name: {{ adminer.base_dst }}/index.php
    - source: salt://adminer/files/index.php
    - user: {{ adminer.user }}
    - require:
      - file: {{ adminer.base_dst }}

adminer-4.2.1-mysql.php:
  file.managed:
    - name: {{ adminer.base_dst }}/adminer-4.2.1-mysql.php
    - source: salt://adminer/files/adminer-4.2.1-mysql.php
    - user: {{ adminer.user }}
    - require:
      - file: {{ adminer.base_dst }}

adminer-plugins.php:
  file.managed:
    - name: {{ adminer.base_dst }}/adminer-plugins.php
    - source: salt://adminer/files/adminer-plugins.php
    - user: {{ adminer.user }}
    - require:
      - file: {{ adminer.base_dst }}

{% macro vhost_curpath(vhost) -%}
  {{ vhost_path(vhost, nginx.vhosts.managed.get(vhost).get('available')) }}
{%- endmacro %}



{% for vhost, settings in adminer.connections.managed.items() %}

{% set conf_state_id = 'adminer_conf_' ~ loop.index0 %}


{{ conf_state_id }}-adminer.php:
  file.managed:
    - name: {{ adminer.base_dst }}/adminer.php
    - source: salt://adminer/files/adminer-config.php.tmpl
    - user: {{ adminer.user }}
    - template: jinja
    - context:
        adminer: {{ settings.config }}
    - require:
      - file: {{ adminer.base_dst }}


{{ conf_state_id }}-adminer.sql:
  file.copy:
    - name: {{ adminer.base_dst }}/adminer.sql
    - source: {{ salt['pillar.get']('adminer:lookup:adminer_sql_import', 'adminer.sql') }}
    - force: true
    - user: {{ adminer.user }}
    - require:
      - file: {{ adminer.base_dst }}


{% endfor %}