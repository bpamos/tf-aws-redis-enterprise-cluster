# DNS Record for Redis Cluster

# DNS record set from existing hosted zone
# uses aws_eip (elastic ips assocated with each re instance)

# Get a Hosted Zone from zone id
data "aws_route53_zone" "selected" {
  zone_id = var.dns_hosted_zone_id
  private_zone = true
}

# create A records
resource "aws_route53_record" "A_record" {
  count   = var.data-node-count
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = format("node-%s.%s.${data.aws_route53_zone.selected.name}", count.index+1, var.vpc_name)
  type    = "A"
  ttl     = "300"
  records = [
            element(var.re-data-node-eips, count.index)
            ]
}


# create NS record. Requires an existing R53 zone.
#formatlist("ns%s.${var.cluster-prefix}.${var.zone-name}", range(1, length(var.node-external-ips) + 1))
resource "aws_route53_record" "NS_record" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = format("%s.${data.aws_route53_zone.selected.name}", var.vpc_name)
  type    = "NS"
  ttl     = "300"
  records = formatlist("node-%s.%s.${data.aws_route53_zone.selected.name}", range(1, var.data-node-count + 1), var.vpc_name)
}
#format("%s-%s-node-%s.${data.aws_route53_zone.selected.name}", var.base_name, var.region,count.index) length(["1","2","3"])
#formatlist("%s-%s-node-%s.${data.aws_route53_zone.selected.name}", var.base_name, var.region, range(1, range(tostring(var.data-node-count))))