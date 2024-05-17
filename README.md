# BrainFood

## Table of Contents
[Summary](#summary)<br>
[Schema](#schema)<br>
[Instructions](#instructions)<br>
-[Basic Setup](#basic-setup)<br>
-[External API Setup](#external-api-setup)<br>
[Dependencies/Gems](#dependenciesgems)<br>
[Endpoints](#endpoints)<br>
[Contributors](#contributors)


## Summary
This project was completed for Turing's Capstone Project for Mod 4. [Part 1](https://mod4.turing.edu/projects/capstone/) of the project pertained planning and completing our app's minimum viable product (MVP). [Part 2](https://mod4.turing.edu/projects/capstone_expansion/) focused on adding additional features.

### Project Links
BE Repo (You're here! Welcome :sunglasses: )<br>
[FE Repo](https://github.com/Brain-Defrost/Brain-Defrost_FE) (Check out what our amazing FE team's code)<br>
[BE Deployment](https://brain-defrost-f8afea5ead0a.herokuapp.com/)<br>
[FE Deployment](https://brain-defrost.github.io/Brain-Defrost_FE/) (Play our game!)

## Schema
![schema diagram](image.png)

## Instructions
### Basic Setup
1. Fork and/or clone this repo from GitHub
2. In terminal, run `git clone <ssh or https path>`
3. Navigate into the cloned project by running `cd tea-subscriptions`
4. Run `bundle install` to install gems used for this project
5. Setup the database migration and seed file by running `rails db:{drop,create,migrate}`

### External API Setup
Trivia question's for a game are created using [OpenAI's API](https://platform.openai.com/docs/api-reference/introduction). You must use your own API key in order to access it. To acquire an Open AI API key:

1. Sign in or create an [OpenAI account](https://platform.openai.com/signup)
2. Go to your [API keys page](https://platform.openai.com/account/api-keys)
3. Open AI currently requires a verified phone number to create an API key.  click on "Start verification"
4. Click on "Create new secret key"
   - Note: Open AI currently requires a verified phone number to create an API key. If you don't have a verified number: 
     1. Click on "Start verification" at the top of the screen
     2. Verify a phone number
     3. Click on "Create new secret key"<br><br>

To add your OpenAI API key to the rails app:

1. Delete the `config/master.key` file
2. In the terminal, run `EDITOR="code --wait" rails credentials:edit`
   - This creates a new `config/master.key` file and opens a credentials file (`config/credentials.yml.enc`)
3. Paste the code below in the credentials file that opens (can go above or below the secret key)
    ```yml
    open_ai_key: 
      Bearer <your_open_ai_api_key_here>
    ```
4. Close the credentials file and have fun coding


### Local Server
To start a local rails server:
```shell
rails server
```

Endpoints may then be utilized in a browser by navigating to
```http
https://localhost:3000
```
And adding the desired api endpoint path to the end. A full list of options may be found in this README's [endpoints section](#endpoints).

<details>
<summary>Local Host Endpoint URL Example</summary>

```http
https://localhost:3000/api/v1/games/1/players
```

</details><br>

To stop the local rails server use `Ctrl` + `C` in the open terminal.


### Testing
[Rspec](https://rspec.info/documentation/) was used for testing. This project currently uses rspec-rails v6.1 and rspec-core v3.13.

**Terminal commands**<br>
To run the entire test suite:
```shell
bundle exec rspec spec
```

To run a test folder:
```shell
bundle exec rspec spec/folder_name
# ex: bundle exec rspec spec/models
```

To run just one file:
```shell
bundle exec rspec <path/to/test/file>
# ex: bundle exec rspec spec/requests/api/v1/games_spec.rb
```

To run just one test:
```shell
bundle exec rspec <path/to/test/file>:test_line
# ex: bundle exec rspec spec/requests/api/v0/customer_adds_subscription_spec.rb:8
```

## Dependencies/Gems
### Gems


## Endpoints
API documentation was setup using the [rswag gem](https://github.com/rswag/rswag?tab=readme-ov-file) and [SwaggerUI](https://swagger.io/tools/swagger-ui/). Documentation may be accessed [here](https://brain-defrost-f8afea5ead0a.herokuapp.com/api-docs/index.html).

To access the API documentation on the local server. [Start](#local-server) the server and navigate to `http://localhost:3000/api-docs/index.html` in a browser.

If preferred, you can also use [Postman](https://www.postman.com/) rather than the browser's localhost, but you will still need to startup the local server using the `rails server` command.

## Contributors
Backend - Jess, Laura, Martin<br>
Frontend - Ethan, Tayla