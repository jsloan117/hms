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

yumgroup 'Development tools' do
  action :install
end

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

package 'docker'

service 'docker' do
  action [:enable, :start]
end

docker_image_list = node['hms']['docker']['images']
docker_image_list.each do |image|
  docker_image image
end
