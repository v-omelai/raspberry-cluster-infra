variable "sleep" {
  type = number
}

variable "agents" {
  type = list(object({
    user = string
    host = string
    key  = string
  }))
}
