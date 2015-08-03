{% from "adminer/map.jinja" import adminer with context %}

{%- macro print_name(identifier, key) -%}
{%- if 'name' in key  %}
{{ key['name'] }}
{%- else %}
{{ identifier }}
{%- endif %}
{%- endmacro -%}

{%- macro print_file(identifier, key) -%}
      {%- if 'name' in key  %}
    - name: {{ adminer.base_dst }}/{{ key['name'] }}-adminer.php
      {%- else %}
    - name: {{ adminer.base_dst }}/{{ identifier }}-adminer.php
      {%- endif %}
      {%- if 'present' in key %}
    - user: {{ adminer.user }}
    - source: salt://adminer/files/test
    - template: jinja
      {%- endif %}
{%- endmacro -%}







include:
  - nginx.ng.config
  - nginx.ng.service
  - nginx.ng.vhosts




{{ adminer.base_dst }}:
  file.directory:
    - name: {{ adminer.base_dst }}/
    - user: {{ adminer.user }}


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

adminer.sql:
  file.copy:
    - name: {{ adminer.base_dst }}/adminer.sql
    - source: {{ salt['pillar.get']('adminer:lookup:adminer_sql_import', 'adminer.sql') }}
    - force: true
    - user: {{ adminer.user }}
    - require:
      - file: {{ adminer.base_dst }}





{%- set adminer_pillar = pillar.get('adminer', {}) -%}
{%- set connections = adminer_pillar.get('connections', {}) -%}



index.php:
  file.managed:
    - name: {{ adminer.base_dst }}/index.php
    - source: salt://adminer/files/index.php
    - user: {{ adminer.user }}
    - require:
      - file: {{ adminer.base_dst }}
    - template: jinja
    - context:
        adminer: {{ connections }}





{%- for identifier,keys in connections.iteritems() -%}
  {%- for key in keys -%}
    {% if 'present' in key %}
{{ print_name(identifier, key) }}:
  file.managed:
    {{ print_file(identifier, key) }}
    - require:
        - file: {{ adminer.base_dst }}
    - context:
        adminer: {{ connections }}
    {%- else %}
{{ print_name(identifier, key) }}:
  file.absent:
    {{ print_file(identifier, key) }}
    {%- endif -%}
  {%- endfor -%}
{%- endfor -%}


