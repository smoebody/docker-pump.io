# pump.io

this image can be used to run a [pump.io](http://pump.io/) node. there is no
datastore built in, i suggest to use an existing one.
this image is configured to work out of the box by linking the docker image 
[docker-redis](https://registry.hub.docker.com/u/sameersbn/redis/) and since there
is only the databank-redis driver installed only redis can be used (next to the
native disk storage, which is not suggested to use anyway).

## Configuration

all settings mentioned in pump.io's configuration section can be set by passing 
environment variables at the `docker run` command. all configuration keys have to
be prefixed with `PUMPIO_`, eg:

    -e "PUMPIO_hostname=pumpio.example.com" -e "PUMPIO_site=My awesome pump.io site"

## Linking the redis-container

In order to be able to link the redis-container into the pump.io-container you
have to start it first. This can be easily done by doing

    docker run --name pumpio-redis -d sameersbn/redis
    
after successful start you can link this container into the pumpio-container by
passing the following switch at the `docker run` command

    --link pumpio-redis:redis
    
the name-mapping `redis` is mandatory as the pump.io-image is configured to this
name. if you change that you also have to change the configuration accordingly.
see the sources for how to achieve that.

## File storage

I strongly suggest to use a designated folder to store your user's uploaded files.
the image is preconfigured to use internal `/app/uploads`-folder to store all uploads.
by passing the following switch to the `docker run` command you can map the
`/app` folder to a host folder

    -v /my/hosts/pump.io-folder:/app
    
this folder can be used to store the pump.io's SSL-key and -certificate in case
you want to use proper SSL-encryption directly with pump.io.

## SSL

By default a snakeoil key and certificate are used in the image. to use your own
key and certificate you should place them in a folder that you mapped to the
pump.io-container, see [File Storage](#File storage). By passing the environment
variables

    -e "PUMPIO_key=/app/keyfile" -e "PUMPIO_crt=/app/crtfile"
    
you can specify them according to your naming premises.

## NON-SSL

If you decide *not* to use SSL-encryption you can disable it completely by passing
empty environment variables as so:

    -e "PUMPIO_key=" -e "PUMPIO_crt="

Be aware that, if you use this container behind an ssl-proxy like nginx, you have 
to use ssl as well since pump.io is not working properly otherwise. in that case
the default snakeoil credentials are sufficient though.

## using fig/compose

Fig is a useful tool to manage linked containers and their settings. The sources
to this image contain a fig.yml as well that shows an example of a usage behind an
ssl-proxy. feel free to use and adapt according to your needs.

## Help / Bugs

The [github-repo](https://github.com/smoebody/docker-pump.io) should be used to file bugs and ask for help, request features,
state pull-requests ...

i welcome all contributions
