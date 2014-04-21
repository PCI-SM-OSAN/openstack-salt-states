{% set hosts = salt['pillar.get']('openstack:hosts') %}
{% set publicgateway = pillar['openstack']['infrastructure']['public_network']['gateway'] %}
{% set publicnetmask = pillar['openstack']['infrastructure']['public_network']['netmask'] %}
{% set publicnetdev = pillar['openstack']['infrastructure']['public_network']['network_device'] %}
{% set mgmntgateway = pillar['openstack']['infrastructure']['management_network']['gateway'] %}
{% set mgmntnetmask = pillar['openstack']['infrastructure']['management_network']['netmask'] %}
{% set mgmntnetdev = pillar['openstack']['infrastructure']['management_network']['network_device'] %}

{% for host, value in hosts.iteritems() %}
{% if value['management_fqdn']==grains['id'] %}
system:
  network:
    - system
    - enabled: true
    - hostname: {{value['management_fqdn']}}
    - gateway: {{mgmntgateway}}
    - gatewaydev: {{mgmntnetdev}}
    - nozeroconf: true

{{mgmntnetdev}}:
  network:
    - managed
    - enabled: true
    - type: eth
    - proto: none
    - ipaddr: {{value['management_ip']}}
    - netmask: {{mgmntnetmask}}

{{publicnetdev}}:
  network:
    - managed
    - enabled: true
    - type: eth
    - proto: none
    - ipaddr: {{value['public_ip']}}
    - netmask: {{publicnetmask}}

restart-network:
  module:
    - wait
    - name: service.restart
    - m_name: network
    - order: last
    - watch:
      - network: {{mgmntnetdev}}
      - network: {{publicnetdev}}
{% break %}{% endif %}{% endfor %}

restart-system:
  module:
    - wait
    - name: system.reboot
    - order: last
    - watch:
      - network: system

