# Tock
Cron in-a-box.

Example docker compose file included, drop your cron files into a volume mounted to `/tock/crons`.

If you'd like your periodic tasks as scripts that the cron calls, mount an extra volume with your scripts
just about anywhere, and make sure your cron file uses the correct path based on your mount point.
I would suggest something like `/scripts`.

If no volume is mounted to `/tock/crons` the default job will run, which simply prints the current time
each minute; both to standard output and `/var/log/cron.log`.

