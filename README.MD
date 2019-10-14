# NGINX Unit Multi-App Demo

### Requirements
- [Docker Desktop](https://www.docker.com/products/docker-desktop) or [Docker Engine](https://www.docker.com/products/container-runtime)

### Build
```
docker build --tag=unit-webapp .
```

### Run
```
export UNIT=$(docker run -d --mount type=bind,src="$(pwd)/config",dst=/config \
                       --mount type=bind,src="$(pwd)/log",dst=/var/log \
                       --mount type=bind,src="$(pwd)/state",dst=/var/lib/unit \
                       --mount type=bind,src="$(pwd)/pythonapp",dst=/pythonapp \
                       --mount type=bind,src="$(pwd)/nodeapp",dst=/nodeapp \
                                   -p 8242:8242 -p 8243:8243 unit-webapp)
```

### Applying Configurations 
Included are 3 different config files to use in your demo. For instance, you can use the command below to configure NGINX Unit with the [config/config.json](config/config.json) file.

```
docker exec -ti $UNIT curl -X PUT --data-binary @/config/config.json http://localhost:9090/config
```

### Demo Flow
- Once the container is up, apply the initial configuration in [config/config.json](config/config.json) using the following command:
```
docker exec -ti $UNIT curl -X PUT --data-binary @/config/config.json http://localhost:9090/config
```
- Navigate to the python flask app at http://localhost:8242 to show that it exists and is taking requests.
- Introduce the node express app by applying the configuration in [config/config-2.json](config/config-2.json) using the following command:
```
docker exec -ti $UNIT curl -X PUT --data-binary @/config/config-2.json http://localhost:9090/config
```
- Navigate to the node express app at http://localhost:8243/admin/
- Show that the python flask app is still running at http://localhost:8242
- Apply a new configuration in [config/config-3.json](config/config-3.json) which demonstrates the 2 applications running on a single port (leveraging routes) with the following command:
```
docker exec -ti $UNIT curl -X PUT --data-binary @/config/config-3.json http://localhost:9090/config
```
- Show the python flask app at http://localhost:8242 as well as the node express app at http://localhost:8242/admin/
- Navigate to the running unit config fetched by node express at http://localhost:8242/admin/config
- The application of [config/config-3.json](config/config-3.json) introduces the concept of scaling processes per application. Use the instructions in the *Supplemental* section below to highlight that there are now 4 node processes running as a result of applying this configuration.

Note: If you need to make a configuration change of your own creation, update json config file of your choosing then run the docker exec command in the "config" section above.


## Supplemental

Open a bash shell into container if needed
```
docker exec -ti $UNIT bash
```

In the Docker container, use the [ps](http://man7.org/linux/man-pages/man1/ps.1.html) command to see running processes running on the system with additional information. For example, if using [config/config-3.json](config/config-3.json), there should be 4 node processes, and only 1 python process active.
```
ps aufx
```

Note: In the above command the `-a` option tells ps to list the processes of all users on the system rather than just those of the current user, `-u` and `-f` options tells `ps` to provide detailed and full information about each process. The `-x` option adds to the list processes that have no controlling terminal, such as daemon.


### Removing and cleaning up existing containers and images on your system
**USE WITH CAUTION!**
```
docker ps -a -q --filter=ancestor=unit-webapp | xargs -I {} docker rm -f {}
docker rmi -f unit-webapp
```