variable "region" {
  default = "ap-south-1"
}
variable "key_name" {
  default = "SonarQube"
}
variable "security_id" {
  default = "CaseApp"
}
variable "pvt_key_name" {
  default = "/home/silent/.ssh/SonarQube.pem"
}
variable "instances" {
  default = 2
}