# Autotest::Users

This is a gem to help you work with users in your auto-tests. Create users, update any params and etc. Users are saved in Hash (not in a databases). Because, not needed save users on a long time. When auto-test is starting, new Hash will be created. After finishing User-Hash will be destroyed. Preferably, use the gem with cucumber. 

User-Hash example: 

    {"user_name" => {first_name: "Alex", last_name: "Klim", full_name: "Alex Klim", email: "email+alexklim@example.com", password: "password"}}

user_name - this is a name, which you use in a cucumber features;

first_name - generate automatically;

last_name - generate automatically;

full_name = first_name + ' ' + last_name

email - your email + (first and last name) @ example.com

password - password for email 


## Installation

Add this line to your application's Gemfile:

    gem 'autotest-users'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install autotest-users

## Usage with cucumber

In features/env.rb file please add:

    require 'autotest-users'
    include Autotest::Users

We should change default email and password for your users. We can add follow lines in features/env.rb file:

    Autotest.configure do |config|
      config.email = <Email For Users> # default: email@example.com
      config.password = <Password for Emails> # default: password
    end

### Methods

    create_user(name)

Create user with name, and basic params: first_name, last_name, full_name, email, password.

    get_user(name)

Find user by 'name' and return this hash

    set_user_data(name, options = {})

Find user by name and set new 'key: value' into the hash.

    get_user_data(name, type)

Find user by name and returned value from hash by type (:type as key for hash).

    current_user=(short_name)

We can set current user. User which used at the moment.

    current_user

Get current user.

    user_created?(name)

Check created or not user with the name, return 'true' or 'false'.

### Example

    $ create_user('alex')
    => {"alex" => {"first_name"=>"Murray", "last_name"=>"Hilpert", "email"=>"email+murrayhilpert@example.com", "password"=>"password"}}
    
    $ get_user('alex')
    => {"first_name"=>"Murray", "last_name"=>"Hilpert", "email"=>"email+murrayhilpert@example.com", "password"=>"password"}

    $ set_user_data('alex', phone: '+1234567')
    => "+1234567"

    $ get_user_data('alex', :email)
    => "email+murrayhilpert@example.com"

    $ curent_user = 'alex'
    current_user[:first_name]
    => "Murray"

    $ user_created?('alex')
    => true

    $ u = get_user('alex')
    $ u[:last_name]
    => "Hilpert"

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
