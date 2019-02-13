provider "google" {
 credentials = "${file("_CREDENTIAL.json")}"
 project     = "${var.progetto}"
 region      = "${var.region}"
}



resource "google_compute_instance" "default" {
 count = "${var.n_studenti}"
 name         = "studente-${count.index}"
 machine_type = "${var.server_instance_type}"
 zone         = "${var.zone}"
 tags         = ["externalssh"]

 boot_disk {
   initialize_params {
     image = "${var.server_image_os}"
     size = "${var.server_size_disk}"
   }
 }
 
resource "google_compute_firewall" "gh-9564-firewall-externalssh" {
  name    = "gh-9564-firewall-externalssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["externalssh"]
}

 network_interface {
   network = "default"

   access_config {
     // Include this section to give the VM an external ip address
   }
 }
 #metadata_startup_script = "yum install -y ansible "




} /* FINE INSTANZA */


