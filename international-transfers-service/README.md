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

## Links

* [Gradle Test Organisation](https://www.safaribooksonline.com/blog/2013/08/22/gradle-test-organization/)
