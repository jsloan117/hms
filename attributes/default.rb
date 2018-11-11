#
# Cookbook:: hms
# Recipe:: server_setup
#
# Copyright:: 2018, Jonathan Sloan, GPL v3.
default['hms']['data_bag_secret_path'] = '/etc/chef/encrypted_data_bag_secret'
default['hms']['media_user_name'] = 'mediaadm'
default['hms']['media_user_comment'] = 'MediaServerServices'
default['hms']['sysuser'] = true
default['hms']['homedir_path'] = '/home/mediaadm'
default['hms']['media_group_name'] = 'mediaadms'
default['hms']['sysgrp'] = true
default['hms']['admin_group_gid'] = '1001'
default['hms']['default_user_shell'] = '/sbin/nologin'
default['hms']['directory_mode'] = '0770'
default['hms']['directory_owner'] = 'root'
default['hms']['file_mode'] = '0640'
default['hms']['file_owner'] = 'root'
default['hms']['hostname'] = 'linda058.macksarchive.com'
default['hms']['timezone'] = 'America/Chicago'
default['hms']['mediadirlist'] = [
  '/data',
  '/data/plexmediaserver',
  '/data/plexmediaserver/movies',
  '/data/plexmediaserver/tvshows',
  '/data/plexmediaserver/music',
  '/data2',
  '/data2/plexmediaserver',
  '/data2/plexmediaserver/movies',
  '/data2/plexmediaserver/tvshows',
]
default['hms']['transmissiondirlist'] = [
  '/data/torrents',
  '/data/torrents/torrents',
  '/data/torrents/downloaded',
  '/data/torrents/downloading',
]

default['hms']['package_list'] = %w(
  atop vim nano conntrack-tools httpd httpd-devel net-tools usbutils bind-utils pciutils yum-utils lm_sensors
  hddtemp smartmontools mc tree psutils ncdu p7zip mdadm wget curl xinetd mlocate vnstat apcupsd apcupsd-cgi
)

default['hms']['docker']['dns_servers'] = %w(1.1.1.1 1.0.0.1)
default['hms']['docker']['network_name'] = 'mediaservices'
default['hms']['docker']['volumes'] = %w(portainer_data openvpn_data)

default['hms']['openvpn_client']['repo'] = 'jsloan117/docker-openvpn-client'
default['hms']['openvpn_client']['container_name'] = 'openvpn_client'
default['hms']['openvpn_client']['hostname'] = 'openvpn_client'
default['hms']['openvpn_client']['network_mode'] = "node['hms']['docker']['network_name'].to_s"
default['hms']['openvpn_client']['restart_policy'] = 'always'
default['hms']['openvpn_client']['cap_add'] = 'NET_ADMIN'
default['hms']['openvpn_client']['devices'] = '/dev/net/tun'
default['hms']['openvpn_client']['env_file'] = '/data2/docker/envfiles/openvpn_client'
default['hms']['openvpn_client']['log_driver'] = 'json-file'
default['hms']['openvpn_client']['log_opts'] = 'max-size=10m'
default['hms']['openvpn_client']['ip_address'] = '172.18.0.2'
default['hms']['openvpn_client']['ports'] = ['7000:8080/tcp', '8112:8112/tcp']
default['hms']['openvpn_client']['volumes'] = [
  'openvpn_data:/etc/openvpn',
  '/etc/localtime:/etc/localtime:ro',
  '/etc/resolvconf:/etc/resolv.conf:ro',
]

default['hms']['deluge']['repo'] = 'binhex/arch-deluge'
default['hms']['deluge']['container_name'] = 'deluge'
default['hms']['deluge']['hostname'] = 'deluge'
default['hms']['deluge']['network_mode'] = "container:#{node['hms']['openvpn_client']['container_name']}"
default['hms']['deluge']['restart_policy'] = 'always'
default['hms']['deluge']['env'] = ['PUID=1000', 'PGID=1000', 'UMASK=022']
default['hms']['deluge']['volumes'] = [
  '/data2/docker/deluge:/config',
  '/data/torrents:/data',
  '/etc/localtime:/etc/localtime:ro',
  '/etc/resolvconf:/etc/resolv.conf:ro',
]

default['hms']['sabnzbd']['repo'] = 'linuxserver/sabnzbd'
default['hms']['sabnzbd']['container_name'] = 'sabnzbd'
default['hms']['sabnzbd']['hostname'] = 'sabnzbd'
default['hms']['sabnzbd']['network_mode'] = "container:#{node['hms']['openvpn_client']['container_name']}"
default['hms']['sabnzbd']['restart_policy'] = 'always'
default['hms']['sabnzbd']['env'] = ['PUID=1000', 'PGID=1000']
default['hms']['sabnzbd']['volumes'] = [
  '/data2/docker/sabnzbd:/config',
  '/data/torrents/downloaded:/downloaded',
  '/data/torrents/downloading:/downloading',
  '/etc/localtime:/etc/localtime:ro',
  '/etc/resolvconf:/etc/resolv.conf:ro',
]

default['hms']['sickchill']['repo'] = 'sickchill/sickchill'
default['hms']['sickchill']['container_name'] = 'sickchill'
default['hms']['sickchill']['hostname'] = 'sickchill'
default['hms']['sickchill']['network_mode'] = "node['hms']['docker']['network_name'].to_s"
default['hms']['sickchill']['restart_policy'] = 'always'
default['hms']['sickchill']['env'] = ['PUID=1000', 'PGID=1000']
default['hms']['sickchill']['ip_address'] = '172.18.0.3'
default['hms']['sickchill']['ports'] = '4443:8081/tcp'
default['hms']['sickchill']['volumes'] = [
  '/data2/docker/sickchill:/data',
  '/data/torrents/downloaded:/downloaded',
  '/data/plexmediaserver/tvshows:/tv',
  '/etc/localtime:/etc/localtime:ro',
  '/etc/resolvconf:/etc/resolv.conf:ro',
]

default['hms']['nzbhydra2']['repo'] = 'theotherp/nzbhydra2'
default['hms']['nzbhydra2']['container_name'] = 'nzbhydra2'
default['hms']['nzbhydra2']['hostname'] = 'nzbhydra2'
default['hms']['nzbhydra2']['network_mode'] = "node['hms']['docker']['network_name'].to_s"
default['hms']['nzbhydra2']['restart_policy'] = 'always'
default['hms']['nzbhydra2']['env'] = ['PUID=1000', 'PGID=1000']
default['hms']['nzbhydra2']['ip_address'] = '172.18.0.4'
default['hms']['nzbhydra2']['ports'] = '5075:5076/tcp'
default['hms']['nzbhydra2']['volumes'] = [
  '/data2/docker/nzbhydra2:/data',
  '/data/torrents/downloading:/torrents',
  '/etc/localtime:/etc/localtime:ro',
  '/etc/resolvconf:/etc/resolv.conf:ro',
]

default['hms']['jackett']['repo'] = 'linuxserver/jackett'
default['hms']['jackett']['container_name'] = 'jackett'
default['hms']['jackett']['hostname'] = 'jackett'
default['hms']['jackett']['network_mode'] = "node['hms']['docker']['network_name'].to_s"
default['hms']['jackett']['restart_policy'] = 'always'
default['hms']['jackett']['env'] = ['PUID=1000', 'PGID=1000']
default['hms']['jackett']['ip_address'] = '172.18.0.5'
default['hms']['jackett']['ports'] = '9117:9117/tcp'
default['hms']['jackett']['volumes'] = [
  '/data2/docker/jackett:/config',
  '/data/torrents/downloading:/downloads',
  '/etc/localtime:/etc/localtime:ro',
  '/etc/resolvconf:/etc/resolv.conf:ro',
]

default['hms']['watchtower']['repo'] = 'v2tec/watchtower'
default['hms']['watchtower']['container_name'] = 'watchtower'
default['hms']['watchtower']['hostname'] = 'watchtower'
default['hms']['watchtower']['network_mode'] = ''
default['hms']['watchtower']['restart_policy'] = 'always'
default['hms']['watchtower']['command'] = '--cleanup -i 300'
default['hms']['watchtower']['volumes'] = [
  '/var/run/docker.sock:/var/run/docker.sock',
  '/etc/localtime:/etc/localtime:ro',
  '/etc/resolvconf:/etc/resolv.conf:ro',
]

default['hms']['portainer']['repo'] = 'portainer/portainer'
default['hms']['portainer']['container_name'] = 'portainer'
default['hms']['portainer']['hostname'] = 'portainer'
default['hms']['portainer']['network_mode'] = ''
default['hms']['portainer']['restart_policy'] = 'always'
default['hms']['portainer']['volumes'] = [
  '/var/run/docker.sock:/var/run/docker.sock',
  'portainer_data:/data',
  '/etc/localtime:/etc/localtime:ro',
  '/etc/resolvconf:/etc/resolv.conf:ro',
]

default['hms']['docker']['image_list'] = %w(
  portainer/portainer
  v2tec/watchtower
  jsloan117/docker-openvpn-client
  binhex/arch-deluge
  linuxserver/sabnzbd
  sickchill/sickchill
  theotherp/nzbhydra2
  linuxserver/jackett
  linuxserver/tautulli
  splunk/splunk
  diaoulael/subliminal
)

default['hms']['apcupsd']['conf']['UPSNAME'] = 'MainUPS'
default['hms']['apcupsd']['conf']['UPSCABLE'] = 'usb'
default['hms']['apcupsd']['conf']['UPSTYPE'] = 'usb'
default['hms']['apcupsd']['conf']['DEVICE'] = ''
default['hms']['apcupsd']['conf']['POLLTIME'] = '60'
default['hms']['apcupsd']['conf']['LOCKFILE'] = '/var/lock'
default['hms']['apcupsd']['conf']['SCRIPTDIR'] = '/etc/apcupsd'
default['hms']['apcupsd']['conf']['PWRFAILDIR'] = '/etc/apcupsd'
default['hms']['apcupsd']['conf']['NOLOGINDIR'] = '/etc'
default['hms']['apcupsd']['conf']['ONBATTERYDELAY'] = '6'
default['hms']['apcupsd']['conf']['BATTERYLEVEL'] = '5'
default['hms']['apcupsd']['conf']['MINUTES'] = '3'
default['hms']['apcupsd']['conf']['TIMEOUT'] = '0'
default['hms']['apcupsd']['conf']['ANNOY'] = '300'
default['hms']['apcupsd']['conf']['ANNOYDELAY'] = '60'
default['hms']['apcupsd']['conf']['NOLOGON'] = 'disable'
default['hms']['apcupsd']['conf']['KILLDELAY'] = '0'
default['hms']['apcupsd']['conf']['NETSERVER'] = 'on'
default['hms']['apcupsd']['conf']['NISIP'] = '0.0.0.0'
default['hms']['apcupsd']['conf']['NISPORT'] = '3551'
default['hms']['apcupsd']['conf']['EVENTSFILE'] = '/var/log/apcupsd/apcupsd.events'
default['hms']['apcupsd']['conf']['EVENTSFILEMAX'] = '10'
default['hms']['apcupsd']['conf']['UPSCLASS'] = 'standalone'
default['hms']['apcupsd']['conf']['UPSMODE'] = 'disable'
default['hms']['apcupsd']['conf']['STATTIME'] = '0'
default['hms']['apcupsd']['conf']['STATEFILE'] = '/var/log/apcupsd/apcupsd.status'
default['hms']['apcupsd']['conf']['LOGSTATS'] = 'off'
default['hms']['apcupsd']['conf']['DATATIME'] = '0'
