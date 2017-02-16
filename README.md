# Sample microservices development environment

A sample repository showing how to use containers for your build, development and CI environments.

This repository contains two projects:

* The exchange rate service, a sample service that returns exchange rates for currency pairs on a given day.
* The international transfer service, another sample service that consumes the exchange rates provided by the
  exchange rate service. This contains a full Docker-based build and development environment.

There are many things that could be improved in this setup, but the idea is to illustrate the basic concepts and
serve as an inspiration / starting point for other projects.
