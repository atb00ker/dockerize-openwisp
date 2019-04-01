# OPENWISP Dockerization Prototype

1. Tested installation of openwisp-controller, openwisp-network-topology, openwisp-radius & openwisp-dashboard with a redis instance and a postgresql instance.
2. Tested horizontal scaling with docker swarm & kubernetes.

### Testing with kubernetes/terraform:

The sample files for terraform and kubernetes are available in the respective directories.

Images are available in docker hub and can be pulled as:
- OpenWISP Dashboard - `atb00ker/ready-to-run:openwisp-dashboard`
- OpenWISP Radius - `atb00ker/ready-to-run:openwisp-radius`
- OpenWISP Controller - `atb00ker/ready-to-run:openwisp-controller`
- OpenWISP Network Topology - `atb00ker/ready-to-run:openwisp-network-topology`

### How to run:

**Note:** If you are pulling the repository for the first time. Please pull the containers before running the `docker-compose up` command to save yourself sometime because it takes a while to build all the containers from scratch!

Manipulate all the values in the `.env` file as you like, then run `make_secret_key.py` to generate a new secret key.
You can build the containers with `docker-compose build`. 
After that do `docker-compose up`, when the containers are ready, you can test them out by going to: 
- openwisp-controller: `127.0.0.1:8000/admin`
- openwisp-network-topology: `127.0.0.1:8001/admin`
- openwisp-radius: `127.0.0.1:8002/admin`
- openwisp-dashboard: `127.0.0.1:8003/admin`

Default username & password are `admin`.

Note(pipenv users): Remember changing the values in `.env` file does nothing because `.env` is also a special file in pipenv, you need to change the values then reactivate environment to ensure that the changes reflect.
