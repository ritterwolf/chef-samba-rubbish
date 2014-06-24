# -*- mode: ruby -*-
# vi: set ft=ruby :

missing_plugs = []
%w(vagrant-berkshelf vagrant-chef-zero vagrant-libvirt vagrant-omnibus).each do |plug|
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
  config.vm.box = "opscode-ubuntu-14.04"
  config.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-14.04_chef-provisionerless.box"

  config.chef_zero.chef_repo_path = 'zero'
  config.omnibus.chef_version = :latest

  #config.vm.synced_folder '.', '/vagrant', type: '9p'

  config.vm.define 'uc1404' do |dc|
    dc.vm.hostname = 'uc1404.chef.lan'

    dc.vm.provision 'chef_client' do |chef|
      chef.json = config_controller.merge override
      chef.add_recipe 'samba-test::controller'
    end
  end

  config.vm.define 'uw1404' do |dc|
    dc.vm.hostname = 'uw1404.chef.lan'

    dc.vm.provision 'chef_client' do |chef|
      chef.json = config_workstation.merge override
      chef.add_recipe 'samba-test::workstation'
    end
  end

end
