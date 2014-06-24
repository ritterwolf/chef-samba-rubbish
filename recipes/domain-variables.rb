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

if ! node.domain.nil?
  node.default['samba']['globals']['realm'] = node.domain.upcase unless node.domain.nil?
  node.default['samba']['globals']['workgroup'] = node.samba.globals.realm.split('.').first
else
  node.default['samba']['globals']['workgroup'] = 'WORKGROUP'
end

node.default['samba']['globals']['winbind_normalize_names'] = true
node.default['samba']['globals']['winbind_use_default_domain'] = true
node.default['samba']['globals']['winbind_enum_users'] = true
node.default['samba']['globals']['winbind_enum_groups'] = true
node.default['samba']['globals']['template_homedir'] = '/home/%D/%U'
node.default['samba']['globals']['template_shell'] = '/bin/bash'

node.default['samba']['idmap']['*']['backend'] = 'rid'
node.default['samba']['idmap']['*']['range'] = '1000000 - 1999999'

node.default['samba']['idmap'][node.samba.globals.workgroup]['backend'] = 'rid'
node.default['samba']['idmap'][node.samba.globals.workgroup]['range'] = '2000000 - 2999999'
