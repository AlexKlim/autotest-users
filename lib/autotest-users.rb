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

      $users[name]['first_name'] = first_name
      $users[name]['last_name'] = last_name
      email = Autotest.email.split('@')
      $users[name]['email'] = "%s+%s%s@%s" % [email[0], first_name.downcase, last_name.downcase, email[1]]
      $users[name]['password'] = Autotest.password

      $users[name]
    end

    def get_user(name)
      if ($users.nil?) or ($users[name].nil?) 
        raise "<#Autotest::Users> User #{name} doesn't exist." 
      end

      $users[name]
    end

    def set_user_data(name, type, data)
      $users[name][type] = data
      data
    end

    def get_user_data(name, type)
      user = get_user(name)
      if user[type]nil?
        raise "<#Autotest::Users> The '#{type}' doesn't exist for '#{name}' user"
      end
      user[type]
    end

    def set_current(name)
      $current ||= Hash.new
      if ((name != 'anonymous') and (name != 'anonim'))
        if $users.nil?
          raise "<#Autotest::Users> You should use create_user method, before set_current method."
        end
        $current['first_name'] = $users[name]['first_name']
        $current['email'] = $users[name]['email']
        $current['password'] = $users[name]['password']
      else
        $current['first_name'] = 'anonymous'
        $current['email'] = 'anonymous'
        $current['password'] = 'anonymous'
      end
    end

    def get_current(type)
      if ($current.nil?) or ($current[type].nil?)
        raise "<#Autotest::Users> You doesn't set current user or '#{type}' doesn't exist fot the current user."
      end
      $current[type]
    end

    def user_created?(name)
      if ($users and $users[name]).nil? then true else false end
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
