database-minion-credentials:
  file:
    - managed
    - name: /etc/salt/minion.d/mysql-credentials.conf
    - source: salt://mysql-server/templates/mysql-credentials.conf.jinja
    - template: jinja
    - mkdirs: true
    - user: root
    - group: root
    - mode: '0644'
