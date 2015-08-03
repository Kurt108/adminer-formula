{% for connection in adminer %}
<li><a href="{{ connection.name }}-adminer.php?username={{ connection.db_user  }}">open adminer {{ connection.name }} (database: {{ connection.db_name }} as user {{ connection.db_user }}</a></li>
{% endfor %}
