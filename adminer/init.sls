{% from "configuration/map.jinja" import configuration with context %}

include:
  - nginx.ng.config
  - nginx.ng.service
  - nginx.ng.vhosts

adminer-4.2.1-mysql.php:
  file.managed:
    - name: {{ configuration.base_dst }}/adminer-4.2.1-mysql.php
    - source: salt://adminer/files/adminer-4.2.1-mysql.php
    - user: {{ configuration.user }}

adminer-plugins.php:
  file.managed:
    - name: {{ configuration.base_dst }}/adminer-plugins.php
    - source: salt://adminer/files/adminer-plugins.php
    - user: {{ configuration.user }}


adminer.php:
  file.managed:
    - name: {{ configuration.base_dst }}/adminer.php
    - source: salt://adminer/files/adminer-config.php.tmpl
    - user: {{ configuration.user }}
    - template: jinja
    - context:
        configuration: {{ configuration }}