# MyFitnessPal API

## Setting up local development on a Mac ##

```shell
$ git clone https://github.com/devonzuegel/myfitnesspal-ruby.git
$ brew install postgresql
$ bundle install

```

Create `.env.development` and `.env.test` files with the following contents:

```yaml
SESSION_SECRET=YOUR-SESSION-SECRET
DATABASE_URL=postgres://your-username@localhost/mfp_api_development
RACK_ENV=development
```

```yaml
SESSION_SECRET=YOUR-SESSION-SECRET
DATABASE_URL=postgres://your-username@localhost/mfp_api_test
RACK_ENV=test
```

```shell
# To setup your databases:
$ ENV_FILE='.env.development' rake db:setup && ENV_FILE='.env.test' rake db:setup

# To clean your database:
$ ENV_FILE='.env.development' rake db:clean && ENV_FILE='.env.test' rake db:clean
```

## Starting the server for local development

```shell
$ bundle exec shotgun
$ rerun 'bundle exec sidekiq -r ./sidekiq.rb -c 2'
$ brew services restart redis
$ redis-cli flushdb
```


## Running specs

```shell
$ bundle exec guard
```
