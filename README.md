# yt2mega
This is a bash script to backup whole YouTube channels to mega.nz.

Requires [youtube-dl](https://github.com/rg3/youtube-dl) and [megatools](https://github.com/megous/megatools). 
Optionally, use [aria2](https://github.com/aria2/aria2) to speed up downloads using multiple segments/connections. (See below)

Didn't spend a lot of time ironing things out or adding features, but here it is for anyone who wishes to use it.

Features:
- Resumable/Schedulable (checks mega to see if the video is already backed up, by id grep)
- Serial operation (i.e., download-upload-delete), putting disk space over speed
- Chronologically indexed filenames
- Better than doing it manually

Flaws:
- Interrupted uploads don't fix themselves (if a half-uploaded file is on mega.nz, the script will skip it)
- Only supports one folder level deep on mega, i.e., /Root/YouTube-Backups-VSauce
- Only runs on GNU+Linux (There is always Bash on Ubuntu on Windows though)
- Haven't tested it, but deleted videos might mess up the indexing - Please let me know if you encounter this, and how you fixed it if you did.


### aria2c with youtube-dl (thanks, [tobbez](https://github.com/tobbez))

aria2c allows youtube-dl to optimize download speed with parallel segmented files. To use it, simply run the following either line by line or in a script:

```
mkdir -p ~/.config/youtube-dl/
cat > ~/.config/youtube-dl/config <<EOF
-o "[%(upload_date)s][%(id)s] %(title)s (by %(uploader)s).%(ext)s"
--external-downloader aria2c
--external-downloader-args "-c -j 3 -x 3 -s 3 -k 1M"
EOF
```

--external-downloader-args cheatsheet:
- -c, --continue[=true|false] [🔗](https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-c)
- -j, --max-concurrent-downloads=<N> [🔗](https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-j)
- -s, --split=<N> (number of segments per file) [🔗](https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-s)
- -k, --min-split-size=<SIZE>[🔗](https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-k)
