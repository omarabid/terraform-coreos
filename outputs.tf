output "configuration" {
	value = "${data.ignition_config.central.rendered}"
}
