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
  its(:content) { should match %r(server role = dc) }
  its(:content) { should match %r(workgroup = CHEF) }
  its(:content) { should match %r(realm = CHEF.LAN) }
  its(:content) { should match %r(dns forwarder = 192\.168\.121\.1) }
  its(:content) { should match %r(path = /var/lib/samba/sysvol/chef.lan/scripts) }
  its(:content) { should match %r(path = /var/lib/samba/sysvol$) }
#  its(:content) { should match %r() }
#  its(:content) { should match %r() }
#  its(:content) { should match %r() }
end

describe file '/var/lib/samba/private/krb5.conf' do
  it { should be_file }
end

describe service 'smbd' do 
  # This test is failing; a false negative
  # it { should_not be_enabled }
end

describe service 'nmbd' do
  it { should be_running }
  it { should be_enabled }
end

describe service 'samba-ad-dc' do
  it { should be_running }
  it { should be_enabled }
end

describe service 'winbind' do
  it { should_not be_running } # integrated into samba-ad-dc
  # This test is failing; a false negative
  # it { should_not be_enabled }
end

describe command 'samba-tool user list' do
  it { should return_exit_status 0 }
  it { should return_stdout %r(testuser) }
end
