#!/usr/bin/python3
import argparse
import hashlib
from getpass import getpass


def parse_args():
    p = argparse.ArgumentParser()
    p.add_argument("-l", default=60, type=int, help="Length")
    return p.parse_args()


def main(args):
    print(hashlib.sha256(getpass().encode("utf-8")).hexdigest()[:args.l])


if __name__ == "__main__":
    main(parse_args())
