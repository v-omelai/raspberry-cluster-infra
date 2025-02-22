variable "sleep" {
  type = object({
    initialize = number
    server     = number
    agents     = number
  })
  default = {
    initialize = 60
    server     = 30
    agents     = 5
  }
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
