#Calling  ./modules/app module for frontend ******************



#Practice/trial code **************************
#module "app2" {
#  source = "./modules/app2"
#  name1 = var.gaurav   #name1 is the key here and Gaurav (declared in the parallel variables.tf folder) is a variable. NOTE the key is passed on to the module and thus the key must be declared inside the module variable.tf file. and lastly the env-dev folder will have the value of this variable
#} ********************************************

#Calling  ./modules/app module for mysql ******************
module "mysql" {
  source = "./modules/app"
  instance_type = var.instance_type
  component     = "mysql"
  ssh_user      = var.ssh_user
  ssh_pass      = var.ssh_pass
  env           = var.env
  zone_id       = var.zone_id
}

#Calling  ./modules/app module for backend ******************
module "backend" {

  depends_on = [module.mysql]   # This is for dependency. Mysql need to launch first and then backend

  source = "./modules/app"
  instance_type = var.instance_type
  component     = "backend"
  ssh_user      = var.ssh_user
  ssh_pass      = var.ssh_pass
  env           = var.env
  zone_id       = var.zone_id
}

module "frontend" {
  source = "./modules/app"
  instance_type = var.instance_type
  component = "frontend"
  ssh_user = var.ssh_user
  ssh_pass = var.ssh_pass
  env = var.env
  zone_id = var.zone_id
}