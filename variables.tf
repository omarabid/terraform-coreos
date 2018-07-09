variable "file_done" {
	type = "string"
	default = <<EOF
	Setup Completed
EOF
}

variable "coreos_setup" {
	type = "string"
	default = <<EOF
	#!/bin/bash

	# Install Consul
	sudo mkdir -p /opt/bin
	wget https://releases.hashicorp.com/consul/1.0.7/consul_1.0.7_linux_amd64.zip
	unzip consul_*.zip
	sudo mv consul /opt/bin/consul
	sudo useradd -m consul
	sudo usermod -aG sudo consul
	sudo mkdir -p /etc/consul.d/server
	sudo mkdir /var/consul
	sudo chown consul: /var/consul

	# Install Nomad
	wget https://releases.hashicorp.com/nomad/0.8.3/nomad_0.8.3_linux_amd64.zip 
	unzip nomad_*.zip
	sudo mv nomad /opt/bin/nomad
	sudo useradd -m nomad
	sudo usermod -aG sudo nomad
	sudo mkdir -p /etc/nomad.d
	sudo mkdir /var/nomad
	sudo chown nomad: /var/nomad

	# Install Vault
	wget https://releases.hashicorp.com/vault/0.10.1/vault_0.10.1_linux_amd64.zip 
	unzip vault_*.zip
	sudo mv vault /opt/bin/vault
	sudo useradd -m vault
	sudo usermod -aG sudo vault
	sudo mkdir -p /etc/vault.d
	sudo mkdir /var/vault
	sudo chown vault: /var/vault
EOF
}

data "ignition_file" "done" {
	filesystem = "root"
	path       = "/done"
	mode = 420

	content {
		content = "${var.file_done}"
	}
}

data "ignition_file" "setup" {
	filesystem = "root"
	path       = "/setup.sh"
	mode = 420

	content {
		content = "${var.coreos_setup}"
	}
}

data "ignition_config" "central" {
	files = [
		"${data.ignition_file.setup.id}",
	],
}
