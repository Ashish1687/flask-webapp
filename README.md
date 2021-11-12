# flask-webapp
To develop python flask apps

install python
pip install flask

#### create Dockerfile

build doker image. - docker build -t flask-app:latest .

Run doker image- docker run -d -p 5000:5000 flask-app

Checkrunnung status - docker ps

## it should be accessible thru browser on 127.0.0.0:5000

push docker image to docker Hub
By re-tagging an existing local image docker tag <existing-image> <hub-user>/<repo-name>[:<tag>]
docker tag flask-app ashish18/flask_python3_application:flask_webapp

  ## to provision the info- crated terraform files for to provision 2 EC2 instance with load balancer
  
  ## configure Ansible inventories (hosts) and playbook to install docker engine, pull falsk image from docker hub and configure server on EC2 servers
  
  ## have to create jenkins pipeline to automate the process -
