#
# Cookbook:: hms
# Recipe:: server_setup
#
# Copyright:: 2018, Jonathan Sloan, GPL v3.
timezone 'set_timezone' do
  timezone node['hms']['timezone']
  action :set
end

hostname 'set_hostname' do
  hostname node['hms']['hostname']
  action :set
end

# may just need to do a service chronyd check/start
execute 'configure_ntp' do
  command 'timedatectl set-ntp true'
  action :run
end

execute 'yum_update_all' do
  command 'yum update -y'
end

data_bag_item('secret', 'VyprVPN')

package_list = node['hms']['package_list']
package_list.each do |pkg|
  yum_package pkg do
    action :install
    options '--quiet'
  end
end

template '/etc/apcupsd/apcupsd.conf' do
  source 'apcupsd.conf.erb'
  owner 'root'
  group 'root'
  mode '644'
  action :create
end

services_list = %w(atopd smartd hddtemp httpd vnstat apcupsd)
services_list.each do |services|
  service services do
    action [:enable, :start]
  end
end

yumgroup 'Development tools' do
  action :install
end

# May or may not be needed?
# execute 'recreate_raid' do
#  command 'mdadm -Ds > /etc/mdadm.conf'
#  action :run
#  only_if { File.zero?('/etc/mdadm.conf') }
# end

user 'jsloan' do
  comment 'Jonathan Sloan'
  home '/home/jsloan'
  shell '/bin/bash'
  password 'password'
  action :create
end

user node['hms']['media_user_name'] do
  comment node['hms']['comment']
  manage_home false
  home node['hms']['homedir_path']
  shell node['hms']['default_shell']
  system node['hms']['sysuser']
  password 'password'
  action :create
end

group node['hms']['media_group_name'] do
  members ["node['hms']['mediagroupies']", 'jsloan']
  system node['hms']['sysgrp']
  append true
  action :create
end

media_directory_list = node['hms']['mediadirlist']
media_directory_list.each do |mdir_list|
  directory mdir_list do
    owner 'plex'
    group node['hms']['media_group_name']
    mode '0770'
    action :create
  end
end

transmission_directory_list = node['hms']['transmissiondirlist']
transmission_directory_list.each do |tdir_list|
  directory tdir_list do
    owner node['hms']['media_user_name']
    group node['hms']['media_group_name']
    mode '0770'
    action :create
  end
end

remote_file '/usr/local/bin/ctop' do
  source 'https://github.com/bcicen/ctop/releases/download/v0.7.1/ctop-0.7.1-linux-amd64'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

package 'docker'

service 'docker' do
  action [:enable, :start]
end

docker_image_list = node['hms']['docker']['images']
docker_image_list.each do |image|
  docker_image image
end

docker_network node['hms']['docker']['network_name'] do
  action :create
end

docker_volume_list = node['hms']['docker']['volumes']
docker_volume_list.each do |volume|
  docker_volume volume do
    action :create
  end
end

docker_container node['hms']['transmission-openvpn']['container_name'] do
  host_name node['hms']['transmission-openvpn']['hostname']
  network_mode node['hms']['transmission-openvpn']['network_mode']
  repo node['hms']['transmission-openvpn']['repo']
  env_file node['hms']['transmission-openvpn']['env_file']
  volumes node['hms']['transmission-openvpn']['volumes']
  restart_policy node['hms']['transmission-openvpn']['restart_policy']
  port node['hms']['transmission-openvpn']['ports']
  dns node['hms']['docker']['dns_servers']
  action :run
end

docker_container node['hms']['sabnzbd']['container_name'] do
  host_name node['hms']['sabnzbd']['hostname']
  network_mode node['hms']['sabnzbd']['network_mode']
  repo node['hms']['sabnzbd']['repo']
  env_file node['hms']['sabnzbd']['env_file']
  volumes node['hms']['sabnzbd']['volumes']
  restart_policy node['hms']['sabnzbd']['restart_policy']
  port node['hms']['sabnzbd']['ports']
  dns node['hms']['docker']['dns_servers']
  action :run
end

docker_container node['hms']['watchtower']['container_name'] do
  host_name node['hms']['watchtower']['hostname']
  command node['hms']['watchtower']['command']
  network_mode node['hms']['watchtower']['network_mode']
  repo node['hms']['watchtower']['repo']
  volumes node['hms']['watchtower']['volumes']
  restart_policy node['hms']['watchtower']['restart_policy']
  dns node['hms']['docker']['dns_servers']
  action :run
end
