#!/bin/sh

cd /tock

# check that we have some cron files to work with
cron_files=$(find crons -type f)
if [ -z "$cron_files" ]; then
    echo 'no crons files specified, nothing to do, stopping'
    exit 1
fi

# check that we have some cron lines to work with
cat $cron_files | grep -vE '^(#|$)' > /tmp/tock/combined
cron_tasks=$(wc -l /tmp/tock/combined | cut -d ' ' -f 1)
if [ "1" -gt "${cron_tasks:-0}" ]; then
    echo 'no crons tasks specified, nothing to do, stopping'
    exit 1
fi

# default user/group, if not set
if [ -z "$USER_ID" ]; then
    USER_ID=720
fi
if [ -z "$GROUP_ID" ]; then
    GROUP_ID=720
fi

# check that the user "tock" exists and has the desired UID
uid=$(id -u tock 2> /dev/null)
if [ -z "$uid" ]; then
    # does not exist yet, create now
    addgroup -g $GROUP_ID tock
    adduser -D -H -u $USER_ID -G tock tock
elif [ "$uid" -ne "$USER_ID" ]; then
    # wrong uid, remove bad and replace
    deluser -f tock
    delgroup -f tock
    addgroup -o -g $GROUP_ID tock
    adduser -M -o -u $USER_ID -g $GROUP_ID tock
fi

# now that tock user exists, we can set their crontab
crontab -u tock /tmp/tock/combined
rm /tmp/tock/combined

echo "Found: $cron_tasks Cron Tasks from the following files:"
find crons -type f
echo '--- starting cron ---'

exec crond -f

