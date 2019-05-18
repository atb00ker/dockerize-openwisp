# TODO

It makes no sense to re-write this part of the program at this stage of development.
We should resume the work under this respository, like updating the README and files after the 
development part is more stable.

### Terraform (outdated)

The same can be deployed using terraform.

1. [Install terraform](https://learn.hashicorp.com/terraform/getting-started/install.html).
2. Set the external_ip in `terraform/variables.tf` (Fiddle with other variables if you so desire but that is optional)
3. (optional) Configure: `terraform/kubes-configmap.tf` can be used to configure ConfigMaps.
4. Execute the following commands:
```
$ terraform init
$ terraform plan
$ terraform apply
```

Note: You may need to set authentication for your cluster in `terraform/kubes-provider.tf` according to your setup. Find more about authentication from official documentation [here](https://www.terraform.io/docs/providers/kubernetes/index.html#authentication).

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

5. Add files: we need `docker-compose.yml` and `.env` inside the `manager1` container. We can simply copy data and use editor `vi` inside container to paste the files.
6. (optional) Change values in `.env` file as you desire.
7. Import environment variable: `export $(grep -v '^#' .env | xargs -0)`
8. Run stack: `docker stack deploy --compose-file docker-compose.yml openwisp`
9. Now, It will take a long while to pull all the images and run all the containers (~30 minutes). You can check the progress using `docker service ls` and `docker service ps openwisp_<module-name>`.
10. After all the containers are ready, you may go to any of the domain name set for the modules.

Note:
   - Default username & password are `admin`.
   - Default domains are: dashboard.openwisp.org, controller.openwisp.org, radius.openwisp.org and topology.openwisp.org.

**Note(`pipenv`):** Remember changing the values in `.env` file does nothing because `.env` is also a special file in `pipenv`, you need to change the values in `.env` file then re-activate environment to ensure that the changes reflect.
