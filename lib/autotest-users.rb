require "autotest-users/version"

module Autotest

  class << self
    attr_accessor :email, :password

    def configure
      yield self
    end
  end

  module Users

    def create_user(name)
      require "randexp"

      $users ||= Hash.new
      $users[name] ||= Hash.new

      first_name = /[:first_name:]/.gen
      last_name = /[:last_name:]/.gen
      first_name.gsub!("'",'')
      last_name.gsub!("'",'')

      $users[name][:first_name] = first_name
      $users[name][:last_name] = last_name
      email = Autotest.email.split('@')
      $users[name][:email] = "%s+%s%s@%s" % [email[0], first_name.downcase, last_name.downcase, email[1]]
      $users[name][:password] = Autotest.password

      $users[name]
    end

    def get_user(name)
      if ($users.nil?) or ($users[name].nil?) 
        raise "<#Autotest::Users> User #{name} doesn't exist." 
      end

      $users[name]
    end

    def set_user_data(name, options = {})
      options.each do |key, value|
        $users[name][key.to_sym] = value
      end
      options.value.first
    end

    def get_user_data(name, type)
      user = get_user(name)
      type = type.to_sym
      if user[type].nil?
        raise "<#Autotest::Users> The '#{type}' doesn't exist for '#{name}' user"
      end
      user[type]
    end

    def current_user=(short_name)
      if $users.nil?
        raise "<#Autotest::Users> You should use create_user method, before 'current_user=' method."
      end      
      $current_user = $users[short_name]
      $current_user
    end

    def current_user
      $current_user
    end

    def user_created?(name)
      (all_users and $users[name]).nil? ? false : true
    end
    
    def all_users
      $users
    end

  end
end

Autotest.configure do |config|
  config.email = 'email@example.com'
  config.password = 'password'
end
