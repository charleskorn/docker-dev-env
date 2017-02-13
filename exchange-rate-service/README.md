# exchange-rate-service

A dummy implementation of a service dependency. 

## Important notes

As this is just an example of a service that could be depended on by other services, a number of shortcuts have been taken, including:

* The exchange rates returned are just semi-randomly generated, rather than being retrieved from a data store of some kind, and the
  calculation used to do this is very, very dodgy
* There is no error checking or validation
* There is no logging
* Nothing is configurable (eg. port used for HTTP)
* Almost everything is in one class

You would not use code like this in production.

## Requirements

* JDK 1.8
* Docker 1.12 or higher (required for health check functionality)

## Building

Run `./build.sh`. This will build the application and create a Docker image tagged as `exchange-rate-service:latest`. 

The Docker image built contains a baked-in [health check script](https://docs.docker.com/engine/reference/builder/#healthcheck)
that will check the health of the service every two seconds.
 
## Running

* You can run `./gradlew run` to build the application if it is not up-to-date and then start the application locally. 
  This is the quickest way.
* You can build the application using `./build.sh` and then run it with 
  `docker run --rm -it --name NAME_HERE -p6000:6000 exchange-rate-service`, replacing `NAME_HERE` with the desired container name
  (eg. `my-exchange-rate-service`).
  
Regardless of the method chosen, the application will then be available at [http://localhost:6000](http://localhost:6000).
