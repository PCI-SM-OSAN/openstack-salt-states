openstack:
  infrastructure:
    enable_selinux: false
    management_network:
      network_device:
      gateway:
      netmask:
    public_network:
      network_device:
      gateway:
      netmask:
    hosts:
      control.dev.com:
        management_ip:
        public_fqdn:
        public_ip:
        roles:
          - controller
      compute1.dev.com:
        management_ip:
        public_fqdn:
        public_ip:
        roles:
          - compute
      compute2.dev.com:
        management_ip:
        public_fqdn:
        public_ip:
        roles:
          - compute

