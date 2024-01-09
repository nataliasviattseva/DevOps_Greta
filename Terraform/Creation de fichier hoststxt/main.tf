variable "host_entries" {
  description = "Liste des entrées pour le fichier hosts.txt"
  type = list(object({
    ip   = string
    host = string
  }))
}

resource "local_file" "hosts_file" {
  content  = join("\n", [for entry in var.host_entries : "${entry.ip} ${entry.host}"])
  filename = "${path.module}/hosts.txt"
}