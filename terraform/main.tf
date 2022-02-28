data "google_client_config" "default" {}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

variable "project_id" {}
variable "region" {}

terraform {
  backend "gcs" {
    bucket = "devrel-341608-tf-state-dev"
    prefix = "terraform/state"
  }
}

resource "google_cloudbuild_trigger" "filename-trigger" {
  name    = "kube-test"
  project = var.project_id
  github {
    name  = "kube-test"
    owner = "aabedraba"
    push {
      branch = "^main$"
    }
  }

  filename = "cloudbuild.yaml"
}

resource "google_project_service_identity" "cloud_build" {
  provider = google-beta

  project = var.project_id
  service = "cloudbuild.googleapis.com"
}

resource "google_artifact_registry_repository" "kube-test" {
  provider = google-beta
  project  = var.project_id

  location = "asia-south1"

  repository_id = "kube-test"
  format        = "DOCKER"
}

# GKE cluster
resource "google_project_iam_binding" "project" {
  project = var.project_id
  role    = "roles/container.admin"

  members = [
    "serviceAccount:${google_project_service_identity.cloud_build.email}",
    "user:abdallah@kubeshop.io"
  ]
}

resource "google_container_cluster" "primary" {
  name     = "${var.project_id}-gke"
  location = var.region
  project  = var.project_id

  network    = "default"
  subnetwork = "default"
  ip_allocation_policy {}

  resource_labels = {}

  # Enabling Autopilot for this cluster
  enable_autopilot = true
  vertical_pod_autoscaling {
    enabled = true
  }
}
