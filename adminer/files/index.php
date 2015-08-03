{%- macro print_name(identifier, key) -%}
{%- if 'name' in key  -%}
{{ key['name'] }}
{%- else -%}
{{ identifier }}
{%- endif -%}
{%- endmacro -%}

{%- for identifier,keys in connections.iteritems() -%}
  {% for key in keys %}
    {% if 'present' in key %}
<li><a href="./{{ print_name(identifier, key) }}/adminer.php?username={{ key['db_user'] }}">open adminer {{ print_name(identifier, key) }} (database: {{ key['db_name'] }} as user {{ key['db_user'] }})</a></li>
    {% endif %}
  {% endfor %}
{% endfor %}
