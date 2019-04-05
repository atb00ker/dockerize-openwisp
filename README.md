# OPENWISP Dockerization Prototype

I've tested installation of openwisp-controller, openwisp-network-topology, openwisp-radius & openwisp-dashboard with a redis instance and a postgresql instance.

I've also tested horizontal scaling with docker swarm & kubernetes.

![kubernetes](https://i.ibb.co/rGpLq4y/ss1.png)

## Testing the Prototype

The sample files for deployment on kubernetes is available in the `kubernetes/` directory. You can also deploy the same using terraform and the relevant files are present in `terraform/`.

Images are available on docker hub and can be pulled from the following links:
- OpenWISP Dashboard - `atb00ker/ready-to-run:openwisp-dashboard`
- OpenWISP Radius - `atb00ker/ready-to-run:openwisp-radius`
- OpenWISP Controller - `atb00ker/ready-to-run:openwisp-controller`
- OpenWISP Network Topology - `atb00ker/ready-to-run:openwisp-network-topology`


### Kubernetes

1. (skip if you have a running cluster) Setup Kubernetes Cluster: A guide for setting up the cluster on bare-metal machines is available [here](https://blog.alexellis.io/kubernetes-in-10-minutes/) and the guide to get started with kubernetes-dashboard (Web UI) is available [here](https://github.com/kubernetes/dashboard).

2. Set external IP: You need to set the external IP for all the services. This is the IP on which you will access your openwisp applications. All the services are in [this file](https://github.com/atb00ker/dockerize-openwisp/blob/master/kubernetes/Service.yml). Please do `ctrl+f` to find `192.168.1.6` and replace with your server's external IP in this file. 

3. (optional) Customization: You can change the settings in the container by changing the environment variables. You can pass the environment variables by changing [this file](https://github.com/atb00ker/dockerize-openwisp/blob/master/kubernetes/ConfigMap.yml). You can add any of the variables from the [list here](https://github.com/atb00ker/dockerize-openwisp/blob/master/.env). 
- The ConfigMap with name `postgres-config` will pass the environment variables only to the postgresql container. 
- The ConfigMap with name `common-config` will pass the environment variables to all the openwisp containers.
- The ConfigMap with name `controller-config` will pass the environment variables to only the openwisp-controller container. If required, new `ConfigMap` can be easily set and added to the service as done [here](https://github.com/atb00ker/dockerize-openwisp/blob/79021ca8ad1d1c083d2822f05143f3c80b0d8077/kubernetes/ReplicationController.yml#L19).

4. Apply to Kubernetes Cluster: You need to apply all the files in the `kubernetes/` directory to your cluster. You can use the Web UI to create new components or you can use `kubectl apply -f <filename>` to apply from CLI. Some `ReplicationControllers` are dependant on other components, so it'll be useful to apply them at last. I recommend to follow this order.
```
$ kubectl apply -f ConfigMap.yml
$ kubectl apply -f PresistentVolume.yml
$ kubectl apply -f ReplicationController.yml
$ kubectl apply -f Service.yml
```

5. Wait for a while. Containers will take a little while to boot up (~1 minute). You can see the status on the Web UI or on CLI by `kubectl get pods` command.


### Terraform

The same can be deployed using terraform.

1. [Install terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)
2. Set the external_ip in `terraform/variables.tf` (Fiddle with other variables if you so desire)
3. (optional) Configure: `terraform/kubes-configmap.tf` can be used to configure ConfigMaps.
4. Execute the following commands:
```
$ terraform init
$ terraform apply
```

Note: You may need to set authentication for your cluster in `terraform/kubes-provider.tf` according to your setup. Find more about authentication from official documentation [here](https://www.terraform.io/docs/providers/kubernetes/index.html#authentication).


### Docker Compose

Testing on docker-compose is relatively less resource and time consuming.

1. Install docker-compose: `pip install docker-compose`
2. (optional) Congfigure: Manipulate all the values in the .env file as you desire & run `make_secret_key.py` to generate a new secret key.
3. Pull all the required images to avoid building them. (which is time consuming task.)

```bash
docker pull atb00ker/ready-to-run:openwisp-dashboard
docker pull atb00ker/ready-to-run:openwisp-radius
docker pull atb00ker/ready-to-run:openwisp-controller
docker pull atb00ker/ready-to-run:openwisp-network-topology
```

4. Run containers: (inside root of the repository) `docker-compose up`
It will take a while for the containers to start up. (~1 minute)

5. When the containers are ready, you can test them out by going to: 
- openwisp-controller: `127.0.0.1:8000/admin`
- openwisp-network-topology: `127.0.0.1:8001/admin`
- openwisp-radius: `127.0.0.1:8002/admin`
- openwisp-dashboard: `127.0.0.1:8003/admin`

Default username & password are `admin`.

**(`pipenv`)Note:** Remember changing the values in `.env` file does nothing because `.env` is also a special file in `pipenv`, you need to change the values in `.env` file then re-activate environment to ensure that the changes reflect.

**Note:** Currently, `openwisp-controller` is not configured with `postGIS` and will not retain data.

### Docker Swarm (Using Docker Machine)

1. Install docker: `sudo snap install docker`
2. Install latest docker-machine: 

```bash
$ base=https://github.com/docker/machine/releases/download/v0.16.0 &&
  curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine &&
  sudo install /tmp/docker-machine /usr/local/bin/docker-machine
```

3. Create docker-machines:

```bash
$ docker-machine create manager1
$ docker-machine create worker1
$ docker-machine create worker2
```

4. Initialize Swarm:

```bash
$ docker-machine ls
$ # Note down the IP of the manager1 node
$ docker-machine ssh manger1
$ docker swarm init --advertise-addr <MANAGER_IP>
$ # Copy the join command from here
$ exit
$ docker-machine ssh worker1
$ docker swarm join --token <OUTPUT_TOKEN> <MANAGER_IP:PORT>
$ exit
$ docker-machine ssh worker2
$ docker swarm join --token <OUTPUT_TOKEN> <MANAGER_IP:PORT>
$ exit
$ docker-machine ssh manger1
```

5. Add files: we need `docker-compose.yml` and `.env` inside the manager1 container. We can simply copy data and use editor `vi` inside container to paste the files.

6. (optional) Change values in `.env` file as you desire.
7. Import environment variable: `export $(grep -v '^#' .env | xargs -0)`
8. Run stack: `docker stack deploy --compose-file docker-compose.yml openwisp`
9. Now, It will take a long while to pull all the images and run all the containers (~30 minutes). You can check the progress using `docker service ls` and `docker service ps openwisp_<module-name>`.
10. After all the containers are ready, you may go to any of the IPs of the swarm and use ports as following to checkout the deployment:

- openwisp-controller: `<NODE_IP>:8000/admin`
- openwisp-network-topology: `<NODE_IP>:8001/admin`
- openwisp-radius: `<NODE_IP>:8002/admin`
- openwisp-dashboard: `<NODE_IP>:8003/admin`

Default username & password are `admin`.

**(`pipenv`)Note:** Remember changing the values in `.env` file does nothing because `.env` is also a special file in `pipenv`, you need to change the values in `.env` file then re-activate environment to ensure that the changes reflect.

**Note:** Currently, `openwisp-controller` is not configured with `postGIS` and will not retain data.

## Build (Developers)

Guide to build images again (with modification or different environment variables).

##### Steps:

1. Install docker-compose: `pip install docker-compose`
2. (optional) Congfigure: Manipulate all the values in the .env file as you desire & run `make_secret_key.py` to generate a new secret key.
3. Make desired changes in the Dockerfiles.
4. You can build the containers with `docker-compose build`. 
5. After that do `docker-compose up`, when the containers are ready, you can test them out by going to(Default username & password are `admin`): 
- openwisp-controller: `127.0.0.1:8000/admin`
- openwisp-network-topology: `127.0.0.1:8001/admin`
- openwisp-radius: `127.0.0.1:8002/admin`
- openwisp-dashboard: `127.0.0.1:8003/admin`
