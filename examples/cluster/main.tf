module "k8s" {
  source        = "../../"
  
  cluster_name  = "test-1"
  app_subnets   = [
    "subnet-031f1747e0dc09701",
    "subnet-0c7f08b4371c4c922",
    "subnet-02615788a527fee46",
  ]

  safelist      = [
    "67.244.67.94/32",
    "207.38.160.58/32",
  ]
}
