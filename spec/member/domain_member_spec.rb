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

require 'spec_helper'

describe file '/etc/samba/smb.conf' do
  its(:content) { should match %r(server role = member) }
  its(:content) { should match %r(workgroup = CHEF) }
  its(:content) { should match %r(realm = CHEF.LAN) }
#  its(:content) { should match %r() }
#  its(:content) { should match %r() }
#  its(:content) { should match %r() }
end

# This looks odd, but it stops the command hanging when it should fail.
describe command 'net ads testjoin < /dev/null' do
  it { should return_exit_status 0 }
  it { should return_stdout %r(OK) }
end
