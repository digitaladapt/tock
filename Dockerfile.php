# vim: set ft=dockerfile :
FROM php:cli-alpine

RUN mkdir /tock
WORKDIR /tock
COPY ./crons-php /tock/crons
COPY ./init.sh /tock/
COPY ./license.txt /tock/
COPY ./readme.md /tock/

RUN mkdir -p /tmp/tock

RUN touch /var/log/cron.log

HEALTHCHECK --interval=60s --retries=3 --start-interval=1s --start-period=10s --timeout=5s \
    CMD ps | grep -v 'grep' | grep 'cron' || exit 1

ENTRYPOINT ["/tock/init.sh"]

