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

package 'samba'

puts "winbind.configure = #{node.samba.winbind.configure}"

if node.samba.winbind.configure
  %w( libnss-winbind libpam-winbind ).each do |pkg|
    package pkg
  end
end

service 'smbd' do
  provider Chef::Provider::Service::Upstart
  if node.samba.globals['server_role'] == 'dc'
    action [ :disable, :stop ]
  else
    action [ :enable, :start ]
    subscribes :restart, 'template[/etc/samba/smb.conf]'
  end
end

service 'nmbd' do
  provider Chef::Provider::Service::Upstart
  action [ :enable, :start ]
  subscribes :restart, 'template[/etc/samba/smb.conf]'
end

service 'samba-ad-dc' do
  provider Chef::Provider::Service::Upstart
  if node.samba.globals['server_role'] == 'dc'
    action [ :enable, :start ]
    subscribes :restart, 'template[/etc/samba/smb.conf]'
  else
    action [ :disable, :stop ]
  end
end

if node.samba.winbind.configure
  service 'winbind' do
    provider Chef::Provider::Service::Upstart
    if node.samba.globals['server_role'] == 'dc'
      action [ :disable, :stop ]
    else
      action [ :enable, :start ]
      subscribes :restart, 'template[/etc/samba/smb.conf]'
    end
  end
end
