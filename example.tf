variable "emails" {
  description = "Email Addresses of the Subscribers"
}
variable "bedtime" {
  description = "Instances Stop Time Cron"
}
variable "waketime" {
  description = "Instances Start Time Cron"
}

module "lambda-eventbridge" {
  source   = "./lambda-eventbridge-module"
  waketime = var.waketime
  bedtime  = var.bedtime
  emails   = toset(var.emails)
}
