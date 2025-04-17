  
# Canasta Open-CSP
This projects aims to integrate Open-CSP 2.0 into CanastaWiki.  

## Getting started

Clone the project and the Docker Compose companion project

~~~bash  
  git clone https://github.com/LarsS88/Canasta_OpenCSP.git
~~~

~~~bash  
  git clone https://github.com/LarsS88/Canasta-DockerCompose.git
~~~

Go to the project directory  

~~~bash  
  cd Canasta_OpenCSP
~~~

Build the image  

~~~bash  
  docker build . -t canasta-opencsp:2.0
~~~

Change to the other project folder  

~~~bash  
  cd ../Canasta-DockerCompose
~~~

Start the Canasta stack

~~~bash  
  docker-compose up -d
~~~

Install a wiki

`Navigate to https://localhost and follow the installation steps`

Copy the now downloaded LocalSettings.php to the config subdir

~~~bash  
  cp <browser download folder>/LocalSettings.php config/
~~~

Restart the stack

~~~bash  
  docker-compose down
  docker-compose up -d
~~~

**OPTIONAL:**
Follow the Open-CSP installation progress

~~~bash  
  docker logs <web container name> --follow
~~~
<mark>If you're just running the one Canasta instance it'll be canasta-dockercompose_web_1. Otherwise you can use 'docker ps' to find it.</mark>

You're done. 🥳
Visit your site.
