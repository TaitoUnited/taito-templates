resource "google_compute_security_policy" "default_cloud_armor_policy" {
  depends_on       = [ google_project.zone ]

  name    = "default-cloud-armor-policy"
  project = google_project.zone.project_id

  /* ADD RULES HERE */
}
