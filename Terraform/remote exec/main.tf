provider "null" {}

resource "null_resource" "docker" {
  // Déclencheur pour forcer l'exécution du provisioner
  triggers = {
    always_run = "${timestamp()}"
  }

  // Connexion SSH
  connection {
    type        = "ssh"
    host        = "10.0.10.70"
    user        = "vagrant"
    private_key = file("/home/nsviattseva/.ssh/id_rsa")
  }

  // Exécution des commandes sur la machine distante
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get upgrade -y",
      "sudo apt-get install -y docker docker-compose"
    ]
  }
}
