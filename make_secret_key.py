
import random


def make_secret_key():

    chars = 'abcdefghijklmnopqrstuvwxyz' \
            'ABCDEFGHIJKLMNOPQRSTUVXYZ' \
            '0123456789' \
            '#^[]-_*%&=+/'

    SECRET_KEY = ''.join([random.SystemRandom().choice(chars)
                          for i in range(50)])

    with open(".env", "a") as env:
        env.write("\nDJANGO_SECRET_KEY=" + SECRET_KEY)


if __name__ == "__main__":
    make_secret_key()
