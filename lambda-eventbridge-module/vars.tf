variable "waketime" {
  description = "Cron expression for wake up time"
}
variable "bedtime" {
  description = "Cron Expression for bed time"
}
variable "tag_value" {
  description = "Tag value for the instances"
  default     = "true"
}
variable "tag_key" {
  description = "Only affects instances tagged with this key"
  default     = "scheduled-start-stop"
}
variable "start_event_name" {
  description = "Name of the Start event detail in Event Bridge"
  default     = "start-event"

}
variable "stop_event_name" {
  description = "Name of the Stop event detail in Event Bridge"
  default     = "stop-event"
}
