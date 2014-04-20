include:
  - selinux.packages

setroubleshoot-enabled:
  service:
    - running
    - names:
      - auditd
      - messagebus
    - enable: true
    - require:
      - sls: selinux.packages

validate-selinux-initial-setup:
  file:
    - managed
    - name:  {{apps_path}}/.saltstack-actions/selinux-filesystem-relabeled
    - makedirs: true
    - contents: "SALTSTACK - LOCK FILE\nIf removed or modified in anyway, the file system will be relabeled for selinux\nand the system will restart."
    - user: root
    - group: root
    - mode: '0644'
    - order: 1

/etc/rc.d/rc.local:
  file:
    - managed
    - source: salt://selinux/templates/rc.local.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: '0755'

set-filesystem-relabel:
  cmd:
    - wait
    - name: 'touch /.autorelabel'
    - watch:
      - file: validate-selinux-initial-setup
    - require:
      - sls: cons3rt.selinux.packages
      - file: /etc/rc.d/rc.local

disable-salt-minion:
  cmd:
    - wait
    - name: '/sbin/chkconfig salt-minion off'
    - watch:
      - file: /etc/rc.d/rc.local

ensure-selinux-permissive:
  module:
    - wait
    - name: file.sed
    - path: /etc/selinux/config
    - before: 'SELINUX=enforcing'
    - after: 'SELINUX=permissive'
    - watch:
      - cmd: set-filesystem-relabel
    - require:
      - sls: cons3rt.selinux.packages

system-reboot-selinux-initialization:
  module:
    - wait
    - name: system.reboot
    - watch:
      - cmd: set-filesystem-relabel
    - require:
      - module: ensure-selinux-permissive
      - cmd: disable-salt-minion
      - service: setroubleshoot-enabled

