provider "google" {
 credentials = "${file("_CREDENTIAL.json")}"
 project     = "${var.progetto}"
 region      = "${var.region}"
}
resource "google_compute_network" "default" {
  name = "classroom-network"
}

resource "google_compute_firewall" "default" {
  name    = "classroom-firewall"
  network = "${google_compute_network.default.name}"
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_tags = ["ssh"]
}

resource "google_compute_instance" "default" {
 count = "${var.n_studenti}"
 name         = "studente-${count.index}"
 machine_type = "${var.server_instance_type}"
 zone         = "${var.zone}"
 tags         = ["ssh"]

 boot_disk {
   initialize_params {
     image = "${var.server_image_os}"
     size = "${var.server_size_disk}"
   }
 }


 network_interface {
   network = "default"

   access_config {
     // Include this section to give the VM an external ip address
   }
 }
depends_on = ["google_compute_firewall.default"] 
} /* FINE INSTANZA */


