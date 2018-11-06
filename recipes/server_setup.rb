#
# Cookbook:: hms
# Recipe:: server_setup
#
# Copyright:: 2018, Jonathan Sloan, GPL-3.0.

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

services_list = %w(atopd smartd hddtemp httpd)
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
# end

user node['hms']['media_user_name'] do
  comment node['hms']['comment']
  uid 'uid'
  gid 'gid'
  home node['hms']['homedir_path']
  shell node['hms']['default_shell']
  system node['hms']['sysuser']
  password 'password'
  action :create
end

group node['hms']['media_group_name'] do
  members node['hms']['mediagroupies']
  system node['hms']['sysgrp']
  action :create
end

media_directory_list = node['hms']['mediadirlist']
media_directory_list.each do |mdir_list|
  directory mdir_list do
    owner 'plex'
    group node['hms']['media_group_name']
    mode '0755'
    action :create
  end
end

transmission_directory_list = node['hms']['transmissiondirlist']
transmission_directory_list.each do |tdir_list|
  directory tdir_list do
    owner node['hms']['media_user_name']
    group node['hms']['media_group_name']
    mode '0755'
    action :create
  end
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

ups_package_list = %w(apcupsd apcupsd-cgi)
ups_package_list.each do |pkg|
  package pkg
end

template '/etc/apcupsd/apcupsd.conf' do
  source 'apcupsd.conf.erb'
  owner 'root'
  group 'root'
  mode '644'
  action :create
end

service 'apcupsd' do
  action [:enable, :start]
end
