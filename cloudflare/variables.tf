variable "cloudflare_account_id" {
  type        = string
  description = "Cloudflare account ID."
}

variable "cloudflare_zone_id" {
  type        = string
  description = "Cloudflare zone ID for therealrishabh.com."
}

variable "cloudflare_zone" {
  type        = string
  description = "Cloudflare zone name."
  default     = "therealrishabh.com"
}
