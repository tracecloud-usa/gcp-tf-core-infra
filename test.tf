# module "gce-lb-https" {
#   source            = "terraform-google-modules/lb-http/google"
#   version           = "~> 11.0"
#   name              = "test-tracecloud-lb-https"
#   project           = "product-app-prod-01"
#   firewall_networks = [module.network.vpcs["vpc-app-prod"].self_link]
#   create_url_map    = true
#   ssl               = true
#   certificate_map   = module.ssl_certificate_map["tracecloud-us-cert-map"].cert_map.id

#   backends = {
#     default = {
#       protocol    = "HTTP"
#       port        = 80
#       port_name   = "http"
#       timeout_sec = 10
#       enable_cdn  = false

#       health_check = {
#         request_path = "/"
#         port         = 80
#       }

#       log_config = {
#         enable      = true
#         sample_rate = 1.0
#       }

#       groups = []
#       iap_config = {
#         enable = false
#       }
#     }
#   }
# }
