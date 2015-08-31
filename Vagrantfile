# -*- mode: ruby -*-
# vi: set ft=ruby :
# start Vagrant config 
Vagrant.configure("2") do |config|
config.vm.box = "ubuntu/trusty64"
  config.vm.define "master" do |master|
    master.vm.hostname = "master1.ceph.cluster"
    master.vm.network "private_network", ip: "10.12.0.5"
    master.vm.provision "shell", path: "headnode.sh"
end
(1..8).each do |x|
  config.vm.define "storage#{x}" do |storage|
    storage.vm.hostname = "storage#{x}.ceph.cluster"
    storage.vm.network "private_network", ip: "10.12.0.#{x+60}"
    storage.vm.provision "shell", path: "nodes.sh"
end
(1..3).each do |i|
  config.vm.define "monitor#{i}" do |monitor|
  monitor.vm.hostname = "monitor#{i}.ceph.cluster"
  monitor.vm.network "private_network", ip: "10.12.0.#{i+40}"
  monitor.vm.provision "shell", path: "nodes.sh"
end
end
end
end
