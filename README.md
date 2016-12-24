# MyFitnessPal API

## Setting up local development on a Mac ##

```bash
$ git clone https://github.com/devonzuegel/myfitnesspal-ruby.git
$ brew install postgresql
$ bundle install
```

Create `.env.development` and `.env.test` files with the following contents:

```yaml
SESSION_SECRET=YOUR-SESSION-SECRET
DATABASE_URL=postgres://
DATABASE_NAME=mfp_api_development
RACK_ENV=development
```

```yaml
SESSION_SECRET=YOUR-SESSION-SECRET
DATABASE_URL=postgres://
DATABASE_NAME=mfp_api_test
RACK_ENV=test
```

```shell
# To create your databases:
$ ENV_FILE='.env.development' rake db:create && ENV_FILE='.env.test' rake db:create

# To setup your databases:
$ ENV_FILE='.env.development' rake db:setup && ENV_FILE='.env.test' rake db:setup

# To clean your database:
$ ENV_FILE='.env.development' rake db:clean && ENV_FILE='.env.test' rake db:clean
```

## Starting the server for local development

To start the app, execute both of these commands (in separate windows):

```bash
$ bundle exec rackup config.ru                     # Run app
$ bundle exec sidekiq -r ./sidekiq.rb -c N         # Run Sidekiq with N workers

$ bundle exec shotgun config.ru                    # Run app with hot-reloader
$ rerun 'bundle exec sidekiq -r ./sidekiq.rb -c N' # Run Sidekiq with hot-reloader
```

Debugging/resetting Redis:

```bash
$ brew services restart redis
$ redis-cli flushdb  # Clear Redis db
```


## Running specs

```bash
$ bundle exec guard
```

## Calculating actual calories in a food entry ##

```
actual_calories = amount * gram_weight * quantity * calories / grams
```

For example, given the following `Rice` food entry, the actual calories of this entry are `1 * 195 * 2.5 * 111 / 100 = 541.125`.

```js
[
  {
    "type": "FoodEntry",
    "data": {
      "food": {
        "type": "Food",
        "data": {
          "description": "Rice - Brown, long-grain, cooked",
          "nutrients": {
            "calories": 111,
            // ...
          },
          "portions": [
            {
              "type": "FoodPortion",
              "data": {
                "amount": 1,
                "gram_weight": 195,
                // ...
              }
            },
            {
              "type": "FoodPortion",
              "data": {
                "amount": 100,
                "gram_weight": 100
                // ...
              }
            },
            {
              "type": "FoodPortion",
              "data": {
                "amount": 1,
                "gram_weight": 28.34950065612793
                // ...
              }
            }
          ],
          // ...
          "grams": 100
        }
      },
      "weight_index": 0,
      "quantity": 2.5,
      // ...
    }
  }
]
```
