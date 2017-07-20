require 'rake'
require 'rspec/core/rake_task'

hosts = [
  {
    name: 'uc1404',
    roles: %w(controller)
  },
  {
    name: 'uw1404',
    roles: %w(member winbind)
  }
]

hosts = hosts.map do |host|
  {
    name: host[:name],
    short_name: host[:name].split('.')[0],
    roles: host[:roles]
  }
end

class ServerspecTask < RSpec::Core::RakeTask

  attr_accessor :target

  def spec_command
    cmd = super
    "env TARGET_HOST=#{target} #{cmd}"
  end

end

namespace :berks do
  task :update do
    sh 'berks update'
    sh 'berks vendor zero/cookbooks'
  end

  task :clean do
    sh 'rm -r zero/cookbooks'
  end
end

namespace :serverspec do
  task all: hosts.map { |h| 'serverspec:' + h[:short_name] }
  hosts.each do |host|
    desc "Run serverspec to #{host[:name]}"
    ServerspecTask.new(host[:short_name].to_sym) do |t|
      t.target = host[:name]
      t.pattern = 'spec/{' + host[:roles].join(',') + '}/*_spec.rb'
    end
  end
end

namespace :vagrant do
  task :destroy do
    sh 'vagrant destroy -f'
  end

  task provision: %w(vagrant:up berks:update) do
    sh 'vagrant provision'
  end

  task :up do
    sh 'vagrant up --no-parallel --no-provision'
  end
end

desc 'Start VMs, provision, and run serverspec'
task default: %w(vagrant:provision serverspec:all)

desc 'Destroy VMs and perform other cleanup'
task clean: %w(vagrant:destroy berks:clean)

desc 'Run serverspec to all hosts'
task spec: 'serverspec:all'

desc 'Start and provision VMs'
task vagrant: 'vagrant:provision'
