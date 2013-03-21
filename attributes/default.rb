# == DEPLOY == #
default['mms_agent']['source'] = "https://mms.10gen.com/settings/10gen-mms-agent.zip"
default['mms_agent']['tmp_file'] = "/tmp/10gen-mms-agent.zip"
default['mms_agent']['parent_path'] = "/opt/"
default['mms_agent']['install_path'] = "/opt/mms-agent"
default['mms_agent']['settings_file_path'] = "/opt/mms-agent/settings.py"

# == STARTUP == #
case node['platform']

when "freebsd"

else
  # upstart
  default['mms_agent']['init_template_mode'] = "0644"
  default['mms_agent']['init_template_owner'] = "root"
  default['mms_agent']['init_template_group'] = "root"
  default['mms_agent']['init_template'] = "mms-upstart.erb"
  default['mms_agent']['service_name'] = "mms-agent"
  default['mms_agent']['template_path'] = "/etc/init/mms-agent.conf"
end


# == API KEYS == #
default['mms_agent']['api_key'] = nil
default['mms_agent']['secret_key'] = nil

default['mms_agent']['use_secrets'] = true
# The name of the data bag
default['mms_agent']['data_bag_name'] = "secrets"
# The name of the data bag item containing your mms key values
default['mms_agent']['data_bag_item'] = "mms"
# The name of the key for which you have specified the api key value
default['mms_agent']['api_key_key'] = "api_key"
# The name of the key for which you have specified the secret key value
default['mms_agent']['secret_key_key'] = "secret_key"


