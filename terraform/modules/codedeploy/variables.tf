variable "service_name" {
  type    = string
  default = "url_sv"
}

variable "cluster_name" {
  type = string
  default = "url-cluster"
}

variable "blue_https_listener" {
  type = string    
}

variable "green_listener_test" {
  type = string  
}

variable "alb_target_blue" {
  type = string
}

variable "alb_target_green" {
  type = string
}