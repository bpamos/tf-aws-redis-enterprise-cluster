# # DNS Record for Redis Cluster

# # DNS record set from existing hosted zone
# # uses aws_eip (elastic ips assocated with each RS instance)

# # Get a Hosted Zone from zone id
# data "aws_route53_zone" "selected" {
#   zone_id = var.dns_hosted_zone_id
#   private_zone = true
# }

# # create A records
# resource "aws_route53_record" "A_record_1" {
#   zone_id = data.aws_route53_zone.selected.zone_id
#   name    = format("%s-%s-node1.${data.aws_route53_zone.selected.name}", var.base_name, var.region)
#   type    = "A"
#   ttl     = "300"
#   records = [
#             aws_eip.rs_cluster_instance_1.public_ip
#             ]
#   depends_on    = [aws_eip.rs_cluster_instance_1,aws_eip.rs_cluster_instance_2,aws_eip.rs_cluster_instance_3]
# }

# resource "aws_route53_record" "A_record_2" {
#   zone_id = data.aws_route53_zone.selected.zone_id
#   name    = format("%s-%s-node2.${data.aws_route53_zone.selected.name}", var.base_name, var.region)
#   type    = "A"
#   ttl     = "300"
#   records = [
#             aws_eip.rs_cluster_instance_2.public_ip
#             ]
#   depends_on    = [aws_eip.rs_cluster_instance_1,aws_eip.rs_cluster_instance_2,aws_eip.rs_cluster_instance_3]
# }

# resource "aws_route53_record" "A_record_3" {
#   zone_id = data.aws_route53_zone.selected.zone_id
#   name    = format("%s-%s-node3.${data.aws_route53_zone.selected.name}", var.base_name, var.region)
#   type    = "A"
#   ttl     = "300"
#   records = [
#             aws_eip.rs_cluster_instance_3.public_ip
#             ]
#   depends_on    = [aws_eip.rs_cluster_instance_1,aws_eip.rs_cluster_instance_2,aws_eip.rs_cluster_instance_3]
# }

# # create NS record. Requires an existing R53 zone.
# resource "aws_route53_record" "NS_record" {
#   zone_id = data.aws_route53_zone.selected.zone_id
#   name    = format("%s-%s.${data.aws_route53_zone.selected.name}", var.base_name, var.region)
#   type    = "NS"
#   ttl     = "300"
#    records = [
#             format("%s-%s-node1.${data.aws_route53_zone.selected.name}", var.base_name, var.region),
#             format("%s-%s-node2.${data.aws_route53_zone.selected.name}", var.base_name, var.region),
#             format("%s-%s-node3.${data.aws_route53_zone.selected.name}", var.base_name, var.region)
#              ]         
# }