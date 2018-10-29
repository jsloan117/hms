#
# Cookbook:: hms
# Recipe:: server_setup
#
# Copyright:: 2018, Jonathan Sloan, GPL-3.0.
default['hms']['data_bag_secret_path'] = '/etc/chef/encrypted_data_bag_secret'
default['hms']['media_group_name'] = 'mediaadms'
default['hms']['admin_group_gid'] = '1001'
default['hms']['default_user_shell'] = '/sbin/nologin'
default['hms']['directory_mode'] = '0750'
default['hms']['directory_owner'] = 'root'
default['hms']['file_mode'] = '0640'
default['hms']['file_owner'] = 'root'
default['hms']['timezone'] = 'America/Chicago'

default['hms']['package_list'] = %w(
  atop
  vim
  nano
  conntrack-tools
)

default['hms']['docker']['dns_servers'] = %w(1.1.1.1 1.0.0.1)

default['hms']['watchtower']['container_name'] = 'watchtower'
default['hms']['watchtower']['network_mode'] = 'watchtower'
default['hms']['watchtower']['restart_policy'] = 'always'
default['hms']['watchtower']['command'] = '--cleanup -i 300'
default['hms']['watchtower']['volumes'] = [
  '/var/run/docker.sock:/var/run/docker.sock',
  '/etc/localtime:/etc/localtime:ro',
  '/etc/resolvconf:/etc/resolv.conf:ro',
]

default['hms']['docker']['image_list'] = %w(
  v2tec/watchtower
  haugene/transmission-openvpn
  linuxserver/sabnzbd
  linuxserver/jackett
  linuxserver/tautulli
  splunk/splunk
  linuxserver/deluge
  diaoulael/subliminal
)
