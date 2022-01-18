variable "token" {
  description = "YC OAuth token"
  type        = string
  sensitive   = true
}
variable "cloud_id" {
  description = "YC Cloud id"
  type        = string
}
variable "folder_id" {
  description = "YC folder id"
  type        = string
}

