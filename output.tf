# Control Plane
 output "endpoint" {
  value = aws_eks_cluster.workhorse.endpoint
}


output "cert" {
  value = aws_eks_cluster.workhorse.certificate_authority[0].data
}


output "arn" {
  value = aws_kms_key.workhorse.arn
}


output "ver" {
  value = aws_eks_cluster.workhorse.platform_version
}


output "status" {
  value = aws_eks_cluster.workhorse.status
}


output "name" {
  value = aws_eks_cluster.workhorse.id
}


output "vpc" {
  value = aws_eks_cluster.workhorse.vpc_config
}


# Node Group -- Stable
output "ng_stable_arn" {
  value = aws_eks_node_group.stable.arn
}


output "ng_stable_id" {
  value = aws_eks_node_group.stable.id
}


output "ng_stable_resources" {
  value = aws_eks_node_group.stable.resources
}


output "ng_stable_status" {
  value = aws_eks_node_group.stable.status
}


# Node Group -- Auction
output "ng_auction_arn" {
  value = aws_eks_node_group.auction.arn
}


output "ng_auction_id" {
  value = aws_eks_node_group.auction.id
}


output "ng_auction_resources" {
  value = aws_eks_node_group.auction.resources
}


output "ng_auction_status" {
  value = aws_eks_node_group.auction.status
}
