variable "sleep" {
  type = number
}

variable "nodes" {
  type = list(object({
    user = string
    host = string
    key  = string
  }))
}
