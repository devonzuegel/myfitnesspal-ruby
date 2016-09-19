# MyFitnessPal API

## Setting up local development on a Mac ##

```shell
$ git clone https://github.com/devonzuegel/myfitnesspal-ruby.git
$ brew install postgresql
$ bundle install

# Create .env.development and .env.test files

$ ENV_FILE='.env.development' rake db:setup && ENV_FILE='.env.test' rake db:setup
```

## Starting the server for local development

```shell
$ bundle exec shotgun
```

## Running specs

```shell
$ bundle exec guard
```
