require 'autotest-users/version'

module Autotest

  class << self
    attr_accessor :email, :password

    def configure
      yield self
    end
  end

  class User
    @data = {}

    def [](key)
      key = key.to_sym
      return "#{@data[:first_name]} #{@data[:last_name]}" if key == :name
      @data[key]
    end

    def []=(key, value)
      @data[key.to_sym] = value
    end
  end

  module Users
    @@users = {}

    def create_user(short_name)
      require 'randexp'
      short_name = short_name.to_s
      user = @@users[short_name] = User.new

      user[:first_name] = /[:first_name:]/.gen
      user[:last_name] = /[:last_name:]/.gen
      email_first_name = prepare_for_email_address(user[:first_name])
      email_last_name = prepare_for_email_address(user[:last_name])
      user[:email] = Autotest.email.sub('@', "+#{email_last_name}_#{email_last_name}@")
      user[:password] = Autotest.password
      user
    end

    def get_user(name)
      raise "<#Autotest::Users> User '#{name}' doesn't exist." unless @@users[name]
      @@users[name]
    end

    def set_user_data(name, type, data)
      @@users[name][type] = data
      data
    end

    def get_user_data(name, type)
      user = get_user(name)
      raise "<#Autotest::Users> The '#{type}' doesn't exist for '#{name}' user" unless user[type]
      user[type]
    end

    def set_current(name)
      if name != 'anonymous'
        user = @@users[short_name]
        raise "<#Autotest::Users> You should use create_user method, before set_current method." if user.nil?
        @@current = user
      else
        @@current[:first_name] = 'anonymous'
        @@current[:email] = 'anonymous'
        @@current[:password] = 'anonymous'
      end
    end

    def get_current(type)
      if (@@current.nil?) or (@@current[type].nil?)
        raise "<#Autotest::Users> You didn't set current user or '#{type}' doesn't exist for current user."
      end
      @@current[type]
    end

    def user_created?(name)
      @@users[name].nil? ? false : true
    end
    
    def all_users
      @@users
    end

    private
    def prepare_for_email_address(something)
      something.gsub(/[^0-9A-Za-z]/, '').downcase
    end
  end
end

Autotest.configure do |config|
  config.email = 'email@example.com'
  config.password = 'password'
end
