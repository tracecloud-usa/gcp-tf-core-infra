resource "google_secret_manager_secret" "this" {
  provider  = google
  secret_id = var.name
  project   = var.project

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_iam_member" "self_access" {
  secret_id = google_secret_manager_secret.this.secret_id
  project   = google_secret_manager_secret.this.project
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${data.google_client_openid_userinfo.this.email}"
}

data "google_client_openid_userinfo" "this" {}

