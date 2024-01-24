# Intsalling Java
sudo apt update -y
sudo apt install openjdk-11-jre -y
java --version

# Installing Jenkins
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt-get install jenkins -y

# Installing Docker
sudo apt update
sudo apt install docker.io -y
sudo usermod -aG docker jenkins
sudo usermod -aG docker nsviattseva
sudo systemctl restart docker
sudo chmod 777 /var/run/docker.sock

# Installing Sonarqube on Jenkins Server
docker run -d --name sonar -p 9000:9000 sonarqube:lts-community
