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

node.default['samba']['globals']['dns_forwarder'] = '192.168.121.1'

include_recipe 'samba-test::default'
include_recipe 'samba::domain-controller'

node.override['resolver']['search'] = 'chef.lan'
node.override['resolver']['nameservers'] = [ node.ipaddress ]

include_recipe 'resolver'

execute 'Create test user' do
  command 'samba-tool user add testuser Test4me --given-name Test --surname User'
  not_if 'samba-tool user list | grep testuser'
end