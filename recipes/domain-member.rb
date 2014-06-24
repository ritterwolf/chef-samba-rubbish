# Copyright 2014 Lyle Dietz
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#   http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_recipe 'samba::domain-variables'

node.default['samba']['globals']['server_role'] = 'member' if node.samba.globals.server_role.nil?
node.default['samba']['globals']['security'] = 'ads'

include_recipe 'samba::install'

include_recipe 'samba::configuration'

include_recipe 'nsswitch::default'

nsswitch_source :passwd do
  param "winbind"
end

nsswitch_source :group do
  param "winbind"
end

joiner = search(:samba, "id:#{node.samba.winbind.join_user}").first

execute 'Join AD' do
  command "net ads join -U #{joiner['id']}%#{joiner['password']}"
  # This looks funky, but it stops it waiting for input if we aren't 
  # joined to the domain, and has no effect if we are
  not_if 'echo | net ads testjoin'
  notifies :restart, 'service[winbind]'
end

execute 'Update PAM' do
  command 'pam-auth-update --package'
  action :nothing
end

template '/usr/share/pam-configs/chef-mkhomedir' do
  cookbook 'samba'
  notifies :run, 'execute[Update PAM]'
end