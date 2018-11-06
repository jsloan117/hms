#
# Cookbook:: hms
# Recipe:: default
#
# Copyright:: 2018, Jonathan Sloan, GPL v3.
error = ''

def recipe_list
  include_recipe 'yum-epel'
  include_recipe 'yumgroup'
  include_recipe 'hms::server_setup'
end

if node['platform'] == 'centos' && node['platform_version'].to_i >= 7
  recipe_list
else
  error = 'Please use a supported OS and version'
end
raise error unless error.empty?
