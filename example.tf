variable "emails" {
  description = "Email Addresses of the Subscribers"
}

module "lambda-eventbridge" {
  source   = "./lambda-eventbridge-module"
  waketime = "0 8 * * ? *"
  bedtime  = "0 10 * * ? *"
  emails   = toset(var.emails)
}
