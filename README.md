# TrailSmith
Application that allows the AI tour guide to recommend different travel routes to users.

## Overview
TrailSmith is a platform provide different travel routes with specific spots based on the user's wish. The suggested sentences could be translated according to the user's selected language.

Users may **wish** for specific details, such as the desired duration, number of people, and other preferences. TrailSmith then suggests different travel **plans** with specific **spots** based on user's wish. Each spot includes essential details like the **address**, making it easy for users to locate these points of interest. Users can read **reviews** that include comments and ratings, which can help them choose the best spots for their travel plans.

## Setup

- Create a personal Google Maps API access token with `public_repo` scope
- Copy `config/secrets_example.yml` to `config/secrets.yml` and update token
- Ensure correct version of Ruby install (see `.ruby-version` for `rbenv`)
- Run `bundle install`
- Run `bundle exec rake db:migrate` to create dev database
- Run `RACK_ENV=test bundle exec rake db:migrate` to create test database

## Running tests

To run tests:

```shell
rake spec
```
