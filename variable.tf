variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
variable "counts" {
  type    = number
  default = "5"

}
variable "web_count" {
  type    = number
  default = "2"

}