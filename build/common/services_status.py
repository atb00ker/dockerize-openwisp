from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError
import os
import time
import sys


def database_status():
    try:
        psycopg2.connect(
            dbname=os.environ['DB_NAME'],
            user=os.environ['DB_USER'],
            password=os.environ['DB_PASS'],
            host=os.environ['DB_HOST'],
            port=os.environ['DB_PORT'],
        )
    except psycopg2.OperationalError:
        time.sleep(3)
        return False
    else:
        return True


def dashboard_status():
    req = Request(os.environ['OPENWISP_DASHBOARD_PROTOCOL'] + "://" + os.environ['OPENWISP_DASHBOARD_HOST'] +
                  ":" + os.environ['OPENWISP_DASHBOARD_LISTEN_PORT'])
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
        import psycopg2
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
        import redis
        print("Waiting for redis to become available...")
        connected = False
        while not connected:
            connected = redis_status()
        print("Connection with redis established.")
