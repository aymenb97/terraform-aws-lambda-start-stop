variable "emails" {
  description = "Email Addresses of the Subscribers"
}

module "lambda-eventbridge" {
  source   = "./lambda-eventbridge-module"
  waketime = "55 15 * * ? *"
  bedtime  = "59 15 * * ? *"
  emails   = toset(var.emails)
}
