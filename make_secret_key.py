import random
import re


def update_secret_key(keygen):

    # Read contents from file as a single string
    file_handle = open(".env", 'r')
    file_string = file_handle.read()
    file_handle.close()

    # Use RE package to allow for replacement (also allowing for (multiline) REGEX)
    file_string = re.sub(r'DJANGO_SECRET_KEY=.*',
                         r'DJANGO_SECRET_KEY=' + re.escape(keygen),
                         file_string)

    # Write contents to file.
    # Using mode 'w' truncates the file.
    file_handle = open(".env", 'w')
    file_handle.write(file_string)
    file_handle.close()


def make_secret_key():

    chars = 'abcdefghijklmnopqrstuvwxyz' \
            'ABCDEFGHIJKLMNOPQRSTUVXYZ' \
            '0123456789' \
            '#^[]-_*%&=+/'

    keygen = ''.join([random.SystemRandom().choice(chars)
                      for i in range(50)])

    return keygen


if __name__ == "__main__":
    keygen = make_secret_key()
    update_secret_key(keygen)
