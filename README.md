# yt2mega
This is a bash script to backup whole YouTube channels to mega.nz.

Requires [youtube-dl](https://github.com/rg3/youtube-dl) and [megatools](https://github.com/megous/megatools).

Didn't spend a lot of time ironing things out or adding features, but here it is for anyone who wishes to use it.

Features:
- Resumable/Schedulable (checks mega to see if the video is already backed up, by id grep)
- Chronologically indexed filenames
- Better than doing it manually

Flaws:
- Interrupted uploads don't fix themselves (if a half-uploaded file is on mega.nz, the script will skip it)
- Only supports one folder level deep on mega, i.e., /Root/YouTube-Backups-VSauce
- Only runs on GNU+Linux (There is always Bash on Ubuntu on Windows though)
