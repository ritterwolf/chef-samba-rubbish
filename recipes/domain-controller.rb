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

node.default['samba']['globals']['server_role'] = 'dc'
node.default['samba']['winbind']['configure'] = false

include_recipe 'samba::install'

node.default['samba']['shares']['sysvol']['path'] = '/var/lib/samba/sysvol'
node.default['samba']['shares']['netlogon']['path'] = "#{node.samba.shares.sysvol.path}/#{node.samba.globals.realm.downcase}/scripts"

directory node.samba.shares.sysvol.path do
  action :create
end

directory node.samba.shares.netlogon.path do
  recursive true
  action :create
end

include_recipe 'samba::configuration'

admin = search(:samba, 'id:Administrator').first

execute 'create domain' do
  command "samba-tool domain provision --adminpass #{admin['password']} --realm #{node.samba.globals.realm} --domain #{node.samba.globals.workgroup}"
  creates '/var/lib/samba/private/krb5.conf'
  only_if { search(:node, "NOT name:#{node.name} AND samba_globals_domain:#{node.samba.globals.realm}").empty? }
  # TODO check DNS as well, in case the server isn't managed by Chef (Windows AD?)
end
