### Setup

## Dependencies
This application uses **Rails 5.2.4** and **Ruby 2.5.3**, there is an assumption that you have the rails environment and the other libraries needed to run a rails app.

- RVM - for managing ruby versions [RVM](https://rvm.io/rvm/install)
- MySQL - database for this application

You will also need to install Bundler:
```
gem install bundler
```

Once setup, install dependencies:
```
bundle install
```

## Configuration
Copy the included `.env.example` file and update the config accordingly:
```
cp .env.example .env
```

## Developing

To serve the application:
```
rails s
```

To run the unit tests:
```
rspec
```
