# A lookup table for RPM URLs for various RedHat 6 based releases
{% elif grains['osmajorrelease'][0] == '6' %}
  {% set pkg = {
    'key': 'https://fedoraproject.org/static/0608B895.txt',
    'key_hash': 'md5=eb8749ea67992fd622176442c986b788',
    'rpm': 'http://repos.fedorapeople.org/repos/openstack/openstack-havana/rdo-release-havana-7.noarch.rpm',
  } %}
{% endif %}

# Completely ignore non-RHEL based systems
{% if grains['os_family'] == 'RedHat' %}
openstack_yum_repo_install_rpm:
  pkg:
    - installed
    - sources:
      - epel-release: {{ salt['pillar.get']('epel:rpm', pkg.rpm) }}

{% if salt['pillar.get']('epel:disabled', False) %}
disable_epel:
  file:
    - sed
    - name: /etc/yum.repos.d/epel.repo
    - limit: '^enabled'
    - before: [0,1]
    - after: 0
{% else %}
enable_epel:
  file:
    - sed
    - name: /etc/yum.repos.d/epel.repo
    - limit: '^enabled'
    - before: [0,1]
    - after: 1
{% endif %}
{% endif %}
