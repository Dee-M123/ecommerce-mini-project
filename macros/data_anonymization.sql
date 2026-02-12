{% macro data_anonymization(input_data) %}
    md5({{ input_data }})
{% endmacro %}
