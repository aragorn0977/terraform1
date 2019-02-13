

provider "google" {
 credentials = "${file("CREDENTIAL.json")}"
 project     = "terraform1-230315"
 region      = "europe-north1"
}


resource "random_id" "instance_id" {
 byte_length = 8
}

resource "google_compute_instance" "default" {
 name         = "openshift-worker-${random_id.instance_id.hex}"
 machine_type = "f1-micro"
 zone         = "europe-north1-a"
 count = 9
 boot_disk {
   initialize_params {
     image = "centos-7"
   }
 }

/*
disk {
  source      = "${google_compute_disk.foobar.name}"
  auto_delete = false
  boot        = false
  size = "20"
}
*/



 network_interface {
   network = "default"

   access_config {
     // Include this section to give the VM an external ip address
   }
 }
 #metadata_startup_script = "yum install -y ansible "
}
