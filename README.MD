# NGINX Unit Multi-app Demo

### requirements
- [Docker Desktop](https://www.docker.com/products/docker-desktop)

### build
```
docker build --tag=unit-webapp .
```

### run
```
export UNIT=$(docker run -d --mount type=bind,src="$(pwd)/config",dst=/config \
                       --mount type=bind,src="$(pwd)/log/unit.log",dst=/var/log/unit.log \
                       --mount type=bind,src="$(pwd)/state",dst=/var/lib/unit \
                       --mount type=bind,src="$(pwd)/pythonapp",dst=/pythonapp \
                       --mount type=bind,src="$(pwd)/nodeapp",dst=/nodeapp \
                                   -p 8242:8242 -p 8243:8243 unit-webapp)
```

### config 
```
docker exec -ti $UNIT curl -X PUT --data-binary @/config/config.json http://localhost:9090/config
```

### demo
- navigate to the python flask app at http://localhost:8242
- navigate to the node express app at http://localhost:8242/admin
- navigate to the running unit config fetched by node express at http://localhost:8242/admin/config

If you need to make a configuration change, update the [config/config.json](config/config.json) file and run the docker exec command in the "config" section above


## supplemental

### open a bash shell into container if needed
```
docker exec -ti $UNIT bash
```

### in container, to see running processes
```
ps aufx
```

### removing and cleaning up existing containers and images
```
docker ps -a -q --filter=ancestor=unit-webapp | xargs -I {} docker rm -f {}
docker rmi -f unit-webapp
```