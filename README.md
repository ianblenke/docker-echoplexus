EchoPlexus for docker with multiple container linkage
=====================================================

This image runs a linkable [EchoPlexus](http://echoplex.us) instance.

There is an automated build repository on docker hub for [ianblenke/echoplexus](https://registry.hub.docker.com/u/ianblenke/echoplexus/).

This project was roughly based on the [sameersbn/gitlab](https://registry.hub.docker.com/u/sameersbn/gitlab/) project.

The scripts/init script generates a src/server/config.coffee file containing the variables as passed as per normal EchoPlexus documentation.
The same environment variables that would be used for Heroku PaaS deployment are used by this script.

The scripts/init script is aware of a redis linked container through the environment variables:

    REDIS_PORT_6379_TCP_ADDR
    REDIS_PORT_6379_TCP_PORT

If you do not link a redis container, a built-in redis-server will be started.

Additionally, the database variables may be overridden from the above:

    REDIS_HOST
    REDIS_PORT

The CMD launches EchoPlexus via the scripts/init script. This may become the ENTRYPOINT later.  EchoPlexus should start up very quickly.

## Usage

Simple stand-alone usage:

    docker run -it -p 5000:5000 ianblenke/echoplexus

To link to another redis container, for example:

    docker run --rm --name dockerfile_redis -p 6379 \
        dockerfile/redis
    docker run --rm --name echoplexus --link dockerfile_redis:REDIS -p 8080:8080 \
        ianblenke/echoplexus

## Environment Variables

There are other environment variables of note, as used by the scripts/init script to generate the src/servers/config.coffee file:

    ${FQDN:-localhost}
    ${PORT:-8080}
    ${USE_PORT_IN_URL:-true}
    ${REDIS_SELECT:-15}
    ${USE_NODE_SSL:-false}                     # only necessary if you're not having nginx proxy through to node
    ${PRIVATE_KEY:-/path/to/server.key}
    ${CERTIFICATE:-/path/to/certificate.crt}
    ${SERVER_NICK:-Server}
    ${IRC_SERVER:-false}                       # beta atm, you may not want to enable this as server stability isn't guaranteed
    ${LOG:-true}                               # keeps a log server-side for participants who may have been offline
    ${WEBSHOT_PREVIEWS_ENABLED:-true}          # http://www.youtube.com/watch?feature=player_detailpage&v=k3-zaTr6OUo#t=23s
    ${PHANTOMJS_PATH:-/usr/bin/phantomjs}      # sudo apt-get install phantomjs
    ${RATE_LIMITING_ENABLED:-true}
    ${RATE_LIMITING_RATE:-5.0}                 # allowed # messages
    ${RATE_LIMITING_PER:-8000.0}               # per # of seconds
    ${EDIT_ENABLED:-true}
    ${EDIT_ALLOW_UNIDENTIFIED:-true}            # whether anonymous users can edit their messages within the context of the same session
    ${MAXIMUM_TIME_DELTA:-(1000 * 60 * 60 * 2)} # after 2 hours, chat messages will not be editable, delete property to enable indefinitely
    ${SERVER_HOSTED_FILE_TRANSFER_ENABLED:-false}
    ${SERVER_HOSTED_FILE_TRANSFER:-${CLIENT_MAX_BODY_SIZE:-10mb}} # nginx user? make sure this matches your nginx configuration: e.g., look for line `client_max_body_size 10M;`
    ${DEBUG:-false}

## Building on your own

You don't need to do this on your own, because there is an [automated build](https://registry.hub.docker.com/u/ianblenke/echoplexus/) for this repository, but if you really want:

    docker build --rm=true --tag={yourname}/echoplexus .

## Source

The source is [available on GitHub](https://github.com/ianblenke/docker-echoplexus/).

Please feel free to submit pull requests and/or fork at your leisure.

