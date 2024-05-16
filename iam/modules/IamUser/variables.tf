variable "devuser" {
   description = "Role for developers"
   type = bool
   default = false
}

variable "qauser" {
   description = "Role for Testing team"
   type = bool
   default = false
}

variable "name" {
   description = "IAM User Name"
   type = string
   default = "testuser"
}

variable "path" {
   description = "Home Folder for IAM User"
   type = string
   default = "/home/"
}

variable "force_destory" {
   description = " Enable force destroy"
   type = bool
   default = true
}


