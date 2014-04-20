include:
  - mysql-server.packages
  - mysql-server.minion-credentials

mysqld:
  service:
    - running
    - enable: true
    - require:
      - sls: mysql-server.packages
      - sls: mysql-server.minion-credentials

mysql-server-service:
  module:
    - wait
    - name: service.restart
    - m_name: mysqld
    - watch:
      - sls: mysql-server.packages

