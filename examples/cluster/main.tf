module "k8s" {
  source        = "../../"
  
  cluster_name  = "workhorse"
  app_subnets   = [
    "subnet-031f1747e0dc09701",
    "subnet-0c7f08b4371c4c922",
    "subnet-02615788a527fee46",
  ]
}
