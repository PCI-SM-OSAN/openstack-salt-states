{% set qpidsaslauth = pillar['qpid_use_sasl_auth'] %}
{% set qpidssl = pillar['qpid_use_ssl_encryption'] %}
include:
  - qpid.package
  - qpid.configuration
  - qpid.file-limits
{% if qpidsaslauth|lower == 'true' %}
  - qpid.sasl
{% endif %}
{% if qpidssl|lower == 'true' %}
  - qpid.ssl
{% endif %}

qpid-broker-service:
  service:
    - running
    - name: qpidd
    - enable: true
    - require:
      - sls: qpid.package
      - sls: qpid.configuration
{% if qpidsaslauth|lower == 'true' %}
      - sls: qpid.sasl
{% endif %}
{% if qpidssl|lower == 'true' %}
      - sls: qpid.ssl
{% endif %}

restart-qpid:
  module:
    - wait
    - name: service.restart
    - m_name: qpidd
    - watch:
      - sls: qpid.package
      - sls: qpid.configuration
{% if qpidsaslauth|lower == 'true' %}
      - sls: qpid.sasl
{% endif %}
{% if qpidssl|lower == 'true' %}
      - sls: qpid.ssl
{% endif %}
