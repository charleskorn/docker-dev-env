# international-transfers-service

## Tests

There are three kinds of tests:

* Unit tests (stored under `src/test`): exactly what it sounds like. This might also include contract tests.

* Integration tests (stored under `src/integrationTest`): tests for individual components (eg. single methods or classes)
  that interact with an external dependency and that require that dependency (or a fake) to be running for the tests to pass. 
  An example of something to test here is interactions with our database.

* Journey tests (stored under `src/journeyTest`): tests that exercise one or more user journeys. Some people might call these
  functional tests or end-to-end tests. These tests require all external dependencies (or appropriate fakes) to be running for the
  tests to pass, and interact with the service as a user / consumer would (using its HTTP interface, for example). As these tests
  only use the external API, these could be written in a different language, but we use Java for everything for simplicity.

## Important notes

As this is just an example of a service with a full test environment, a number of shortcuts have been taken, including:

* There is no error checking or validation
* There is no logging
* Nothing is configurable (eg. port used for HTTP and database connection string are hard-coded)
* The database schema is hardcoded into the database Docker container (ideally some kind of schema migrations system would be in place)
* There are no consumer-driven contract tests in place

## Links

* [Gradle Test Organisation](https://www.safaribooksonline.com/blog/2013/08/22/gradle-test-organization/)
* [Sample Postgres Docker health check](https://github.com/docker-library/healthcheck/tree/master/postgres)
