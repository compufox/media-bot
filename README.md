# media-bot
### _a. fox_

a mastodon bot that will post provided media files at specified days and times

## Usage

```
Usage: media-bot [-c|--config ARG] [-h|--help] [-a|--alt-text ALT-TEXT]
                 [-m|--media MEDIA] [-d|--day DAY] [-t|--time TIME] [-v|--visibility VISIBILITY]
                 [-s|--sensitive] [--version]

Available options:
  -c, --config ARG            config file to use
  -h, --help                  prints this help
  -a, --alt-text ALT-TEXT     alt text to post for supplied media
  -m, --media MEDIA           media to post
  -d, --day DAY               day to make the post
  -t, --time TIME             time to make the post in the format HH:MM
  -v, --visibility VISIBILITY
                              visibility of post (defaults to unlisted)
  -s, --sensitive             if provided, the media will be marked as sensitive when posted
  --version                   prints the version
```

## Example Usage 

To post a video with alt text every thursday at 11:00am:

`$ ./media-bot -c your.config --day thursday --time 11:00 --media video.mp4 --alt-text "this is the media alt text"`

To post a photo publically, but mark it sensitive: 

`$ ./media-bot -c your.config -d Sunday -t 20:00 -m photo.png --visibility public --sensitive`

## Building

1. Install [roswell](https://github.com/roswell/roswell)
2. `$ mkdir ~/common-lisp && git clone https://dev.focks.website/focks/media-bot ~/common-lisp/media-bot`
3. `$ cd ~/common-lisp/media-bot && make`

## License

NVPLv1+

