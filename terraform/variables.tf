variable "sleep" {
  type = number
}

variable "nodes" {
  type = object({
    server = object({
      user = string
      host = string
      key  = string
    })
    agents = list(object({
      user = string
      host = string
      key  = string
    }))
  })
}
