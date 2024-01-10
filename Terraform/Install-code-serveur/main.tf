provider "null" {}

resource "null_resource" "linux" {
  // Déclencheur pour forcer l'exécution du provisioner
  triggers = {
    always_run = "${timestamp()}"
  }

  // Exécution des commandes localement
  provisioner "local-exec" {
    command = <<-EOT
      sudo apt update
      sudo apt upgrade -y
    EOT
  }
}
