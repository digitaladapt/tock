#!/bin/sh

# on each boot of this container, we build the crontab
echo '--- building combined cron ---'
cat /tock/crons/* | tee '/tmp/tock/combined'
crontab /tmp/tock/combined
rm /tmp/tock/combined
echo '--- starting cron ---'

exec crond -f && tail -f /var/log/cron.log

