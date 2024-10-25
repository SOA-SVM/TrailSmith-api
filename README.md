# TrailSmith
Application that allows the AI tour guide to recommend different travel routes to users.

## Overview
TrailSmith will provide different travel routes with specific **spots** based on the user's **z**. The provided **sentences** could be translated according to the user's selected language.


## Setup

- Create a personal Google Cloud API access token with `public_repo` scope
- Copy `config/secrets_example.yml` to `config/secrets.yml` and update token
- Ensure correct version of Ruby install (see `.ruby-version` for `rbenv`)
- Run `bundle install`

## Running tests

To run tests:

```shell
rake spec
```
