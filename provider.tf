provider "google" {
  credentials = file("service-account.json")
  project     = "dev-ops-development-320410"
  region      = "europe-west3"
  zone        = "europe-west3-a"

}