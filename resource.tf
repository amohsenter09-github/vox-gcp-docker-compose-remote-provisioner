resource "google_compute_network" "vpc_network" {
  name = "vpc-network"
}

# create the network-01 which is auto
resource "google_compute_network" "network-01" {
  name                    = "network-01"
  auto_create_subnetworks = true
}
# Create a firewall rule to allow HTTP, SSH, RDP and ICMP traffic on network-01
resource "google_compute_firewall" "network-01_allow_http_ssh_rdp_icmp" {
  name    = "network-01-allow-http-ssh-rdp-icmp"
  network = google_compute_network.network-01.self_link
allow {
    protocol = "tcp"
    ports    = ["22", "80", "3389"]
  }
allow {
    protocol = "icmp"
  }
}

# Create the network-02 - private-shared - I changer the name of it to be network-02 instead of  network-test-1 for bettering naming convension 
resource "google_compute_network" "network-02" {
  name                    = "network-02"
  auto_create_subnetworks = "false"
}
# Create network-02-subnet-us subnetwork
resource "google_compute_subnetwork" "network-02-subnet-eu" {
  name          = "network-02-subnet-eu"
  region        = var.region_name
  network       = google_compute_network.network-02.self_link
  ip_cidr_range = "192.168.0.0/24"



}

resource "google_compute_address" "internal_with_subnet_and_address" {
  name         = "my-internal-address"
  subnetwork   = google_compute_subnetwork.network-02-subnet-eu.id
  address_type = "INTERNAL"
  address      = "192.168.0.2"
  region       = var.region_name
}

# Add a firewall rule to allow HTTP, SSH, and RDP traffic on network-02
resource "google_compute_firewall" "network-02-allow-http-ssh-rdp-icmp" {
  name    = "network2-allow-http-ssh-rdp-icmp"
  network = google_compute_network.network-02.self_link
allow {
    protocol = "tcp"
    ports    = ["22", "80", "3389"]
  }
allow {
    protocol = "icmp"
  }
}


# create google_compute_instance

resource "google_compute_address" "static" {
  name = "ipv4-address"
}

resource "google_compute_instance" "vm_instance" {
  name         = "vm-ap-test-01"
  zone         = var.zone_name
  machine_type = var.machine_size
  deletion_protection = "true"

  boot_disk {
    initialize_params {
      image = var.image_name
    }
  }

  tags = ["ssh", "http", "icmp"]


  # We connect to our instance via Terraform and remotely executes our script using SSH
  provisioner "remote-exec" {
    script = var.script_path

    connection {
      type        = "ssh"
      host        = google_compute_address.static.address
      user        = var.username
      private_key = file(var.private_key_path)
    }
  }


  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.static.address
    }
  }
}




output "instance_name" {
  value = "${google_compute_instance.vm_instance.name}"
}