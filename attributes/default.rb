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
