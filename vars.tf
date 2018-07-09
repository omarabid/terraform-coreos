variable "file_done" {
	type = "string"
	default = <<EOF
	Setup Completed
EOF
}

data "ignition_file" "setup" {
	filesystem = "root"
	path       = "/done"
	mode = 420

	content {
		content = "${var.file_done}"
	}
}

data "ignition_config" "central" {
	files = [
		"${data.ignition_file.setup.id}",
	],
}
