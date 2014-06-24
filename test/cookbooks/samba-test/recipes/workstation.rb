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

node.override['resolver']['search'] = 'chef.lan'

nameservers = search(:node, 'samba_globals_server_role:dc AND samba_globals_realm:CHEF.LAN')
ns_ips = []

nameservers.each do |ns|
  ns_ips << ns.ipaddress
end

node.override['resolver']['nameservers'] = ns_ips

include_recipe 'resolver'

include_recipe 'samba-test::default'
include_recipe 'samba::domain-member'
