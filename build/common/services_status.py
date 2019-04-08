from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError
import psycopg2
import redis
import os
import time
import sys


def database_status():
    try:
        psycopg2.connect(
            dbname=os.environ['PG_NAME'],
            user=os.environ['PG_USER'],
            password=os.environ['PG_PASS'],
            host=os.environ['PG_HOST'],
            port=os.environ['PG_PORT'],
        )
    except psycopg2.OperationalError:
        time.sleep(3)
        return False
    else:
        return True


def dashboard_status():
    req = Request(os.environ['OPENWISP_DASHBOARD_PROTOCOL'] + "://" + os.environ['OPENWISP_DASHBOARD_HOST'] +
                  ":" + os.environ['OPENWISP_DASHBOARD_PORT'])
    try:
        _ = urlopen(req)
    except (URLError, HTTPError):
        time.sleep(3)
        return False
    else:
        return True


def redis_status():
    rs = redis.Redis(os.environ['REDIS_HOST'])
    try:
        rs.ping()
    except redis.ConnectionError:
        time.sleep(3)
        return False
    else:
        return True

    
if __name__ == "__main__":
    arguments = sys.argv[1:]
    # Database Connection
    if "database" in arguments:
        print("Waiting for database to become available...")
        connected = False
        while not connected:
            connected = database_status()
        print("Connection with database established.")    
    # OpenWISP Dashboard Connection
    if "dashboard" in arguments:
        print("Waiting for OpenWISP dashboard to become available...")
        connected = False
        while not connected:
            connected = dashboard_status()
        print("Connection with OpenWISP dashboard established.")
    # Redis Connection
    if "redis" in arguments:
        print("Waiting for redis to become available...")
        connected = False
        while not connected:
            connected = redis_status()
        print("Connection with redis established.")

