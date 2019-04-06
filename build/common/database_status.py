import psycopg2
import time
import os


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
        database_status()


if __name__ == "__main__":
    print("Waiting for Database to respond...")
    database_status()
    print("Connection with database establised, migrating...")
