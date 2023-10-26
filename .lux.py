#! python3

import argparse
import os
import subprocess
import json
import re
import tempfile


_LUX = os.path.expanduser("~/go/bin/lux")
_FFMPEG = os.path.expanduser("ffmpeg")

_WHITELIST = '[^a-zA-Z0-9\-\ ]+'
_BLACKLIST = [  # don't put descriptions in the title :sigh:
    "most epic",
    "music ever",
    "music mix",
    "orchestral music",
    "official music video",
    "instrumental",
    "cinematic",
    "ultimate",
    "soundtrack",
    "official",
    "worlds most",
    "worlds best",
    "best epic",
    "uplifting",
    "powerful",
    "beautiful",
    "inspirational",
    "inspiring",
]

_VERBOSE = False


_CHOICE_SMALL = 'smallest'
_CHOICE_LARGE = 'largest'


def parser():
    ps = argparse.ArgumentParser()
    ps.add_argument('url', help='url to download')
    ps.add_argument('-v', '--verbose', action='store_true', help='verbose output')
    ps.add_argument(
        '--choose',
        choices=[
            _CHOICE_SMALL,
            _CHOICE_LARGE,
        ],
        default=_CHOICE_LARGE,
        help='how to choose a stream to download',
    )
    ps.add_argument('--output-dir', default=os.getcwd(), help='output directory')
    ps.add_argument('--audio-only', action='store_true', help='drop video')
    return ps.parse_args()


def find_stream(url, choose):
    print("Fetching info for %s" % url)
    info = json.loads(subprocess.check_output([_LUX, '--info', '--json', url]))
    info = info[0] # we only ever get one result
    if _VERBOSE:
        print(json.dumps(info, indent=4))

    size = None
    choice = None

    for id, data in info['streams'].items():
        if choice is None:
            size = data['size']
            choice = data
        elif choose == _CHOICE_SMALL and data['size'] < size:
            size = data['size']
            choice = data
        elif choose == _CHOICE_LARGE and data['size'] > size:
            size = data['size']
            choice = data

    if choice is None:
        print("No streams found")
        return

    return info, choice


def fix_title(title):
    # remove special chars
    title = re.sub(_WHITELIST, '', title)

    # remove black listed words
    tokens = {t.lower(): t for t in title.split(' ')}
    title = title.lower()
    for token in _BLACKLIST:
        t = token.lower()
        title = title.replace(t, '')

    # remove double spaces
    while "  " in title:
        title = title.replace("  ", " ")

    # finally, rebuild the title with correct case
    title = '_'.join([tokens.get(t, '') for t in title.split(' ') if t])

    return title


def download(url, stream, outfile):
    print("Downloading %s (%d) -> %s.%s" % (url, stream['size'], outfile, stream['ext']))
    subprocess.check_output([
        _LUX,
        '--output-name', os.path.basename(outfile),
        '--output-path', os.path.dirname(outfile),
        '-f', stream['id'],
        url,
    ])


def convert(infile, outfile):
    print("Converting %s -> %s" % (infile, outfile))
    subprocess.check_output([
        _FFMPEG,
        '-i', infile,
        outfile,
    ])


def main():
    args = parser()

    global _VERBOSE
    _VERBOSE = args.verbose

    info, stream = find_stream(args.url, args.choose)
    title = fix_title(info['title'])

    if not args.audio_only:
        download(args.url, stream, os.path.join(args.output_dir, title))
        return

    tempfilename = os.path.join(tempfile.gettempdir(), title)
    download(args.url, stream, tempfilename)
    tempfilename = tempfilename + '.' + stream['ext'] # lux add ext automatically

    # convert to audio only
    outfile = os.path.join(args.output_dir, f"{title}.mp3")
    convert(tempfilename, outfile)


if __name__ == "__main__":
    main()
