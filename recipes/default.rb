#
# Cookbook Name:: mms-agent
# Recipe:: default
#
# Copyright 2011, Treasure Data, Inc.
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'python'

require 'fileutils'

# munin-node for hardware info
package 'munin-node'

# download
package 'unzip'
remote_file node[:mms_agent][:tmp_file] do
  source node[:mms_agent][:source]
  not_if { File.exist?(node[:mms_agent][:tmp_file]) }
end

# unzip
bash 'unzip 10gen-mms-agent' do
  code "unzip -o -d #{node[:mms_agent][:parent_path]} #{node[:mms_agent][:tmp_file]}"
  not_if { File.exist?(node[:mms_agent][:install_path]) }
end

# install pymongo
python_pip 'pymongo' do
  action :install
end

api_key, secret_key = if node[:mms_agent][:use_secrets]
  values = Chef::EncryptedDataBagItem.load(node[:mms_agent][:data_bag_name],
                                           node[:mms_agent][:data_bag_item])
  [ values[node[:mms_agent][:api_key_key]], values[node[:mms_agent][:secret_key_key]] ]
else
  [ node[:mms_agent][:api_key], node[:mms_agent][:secret_key] ]
end

# modify settings.py
ruby_block 'modify settings.py' do
  block do
    settings_path = node[:mms_agent][:settings_file_path]
    orig_s = ''
    open(settings_path) { |f|
      orig_s = f.read
    }
    s = orig_s
    s = s.gsub(/mms\.10gen\.com/, 'mms.10gen.com')
    s = s.gsub(/@API_KEY@/, api_key)
    s = s.gsub(/@SECRET_KEY@/, secret_key)
    if s != orig_s
      open(settings_path,'w') { |f|
        f.puts(s)
      }
    end
  end
end



template "startup" do
  mode   node['mms_agent']['init_template_mode']
  group  node['mms_agent']['init_template_group']
  owner  node['mms_agent']['init_template_owner']
  path   node['mms_agent']['template_path']
  source node['mms_agent']['init_template']
end



case node['platform']

when "ubuntu"
  service "mms-agent" do
    provider Chef::Provider::Service::Upstart
    supports :status => true, :start => true, :stop => true
    action [ :enable, :start ]
  end
end