data "aws_route53_zone" "test-zone" {
  name         = "cmcloudlab1657.info"
  private_zone = false
}
resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.test-zone.zone_id
  name    = data.aws_route53_zone.test-zone.name
  type    = "A"

  alias {
    name                   = aws_lb.test.dns_name
    zone_id                = aws_lb.test.zone_id
    evaluate_target_health = false
  }
}