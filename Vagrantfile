# -*- mode: ruby -*-
# vi: set ft=ruby :

missing_plugs = []
%w(vagrant-chef-zero vagrant-libvirt vagrant-omnibus).each do |plug|
  missing_plugs << plug unless Vagrant.has_plugin? plug
end

raise "You are missing the following required plugins:\n\t #{missing_plugs.join "\n\t"}" unless missing_plugs.empty?

override = {}
override = JSON.parse(IO.read 'local.json') if File.exists? 'local.json'
config_controller = {}
config_workstation = {}

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # I had to recreate this image so it worked in libvirt. The stable interface
  # naming broke things.
  config.vm.box = "ubuntu-16.04"

  config.chef_zero.chef_repo_path = 'zero'
  config.omnibus.chef_version = '12.19.36'

  config.vm.define 'uc1604' do |dc|
    dc.vm.hostname = 'uc1604.chef.lan'

    dc.vm.provision 'chef_client' do |chef|
      chef.json = config_controller.merge override
      chef.add_recipe 'samba-test::controller'
    end
  end

  config.vm.define 'uw1604' do |dc|
    dc.vm.hostname = 'uw1604.chef.lan'

    dc.vm.provision 'chef_client' do |chef|
      chef.json = config_workstation.merge override
      chef.add_recipe 'samba-test::workstation'
    end
  end

end
