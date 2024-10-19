data "cloudflare_zone" "this" {
  provider = cloudflare

  name = var.zone
}

resource "cloudflare_record" "this" {
  provider = cloudflare

  zone_id = data.cloudflare_zone.this.zone_id
  name    = var.name
  content = var.content
  type    = var.type
  ttl     = var.ttl
}
