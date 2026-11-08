# JwtAuthService

[![Ruby](https://img.shields.io/badge/ruby-3.x-blue.svg)](https://www.ruby-lang.org/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

A lightweight, production‑ready JWT authentication service built with **Sinatra**. 
It demonstrates modern Ruby practices, proper error handling, logging, configuration
management, and a full test suite.

## Features

* Stateless authentication using JSON Web Tokens (JWT)
* Secure secret handling via **dotenv**
* Centralised logging (`Logger`)
* Simple in‑memory user store (replaceable with a DB)
* Comprehensive RSpec tests
* Clear separation of concerns (controllers, helpers, config)

## Getting Started

### Prerequisites

* Ruby ≥ 2.7
* Bundler (`gem install bundler`)

### Installation