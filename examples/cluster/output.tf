# Control Plane
 output "endpoint" {
  value = module.k8s.endpoint
}


output "cert" {
  value = module.k8s.cert
}


output "arn" {
  value = module.k8s.arn
}


output "ver" {
  value = module.k8s.ver
}


output "status" {
  value = module.k8s.status
}


output "name" {
  value = module.k8s.name
}


output "vpc" {
  value = module.k8s.vpc
}


# Node Group -- Stable
output "ng_stable_arn" {
  value = module.k8s.ng_stable_arn
}


output "ng_stable_id" {
  value = module.k8s.ng_stable_id
}


output "ng_stable_resources" {
  value = module.k8s.ng_stable_resources
}


output "ng_stable_status" {
  value = module.k8s.ng_stable_status
}


# Node Group -- Auction
output "ng_auction_arn" {
  value = module.k8s.ng_auction_arn
}


output "ng_auction_id" {
  value = module.k8s.ng_auction_id
}


output "ng_auction_resources" {
  value = module.k8s.ng_auction_resources
}


output "ng_auction_status" {
  value = module.k8s.ng_auction_status
}
