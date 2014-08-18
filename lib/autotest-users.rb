require "autotest-users/version"
require 'randexp'

module Autotest
  module Users

    class << self
      attr_accessor :email
      attr_reader :post_create_block, :post_change_block

      def on_user_create &block
        @post_create_block = block
      end

      def on_user_change &block
        @post_change_block = block
      end

      def generate_email_for user
        local_part, domain_part = email.split('@')
        user[:email] = sprintf('%s+%s%s@%s', local_part, user[:first_name].downcase, user[:last_name].downcase, domain_part)
      end

      def default_value_for user
        user[:first_name] = Randgen.first_name.gsub("'",'')
        user[:last_name] = Randgen.last_name.gsub("'",'')
        user[:email] = generate_email_for user
        user[:password] = 'password'
        user
      end

    end

    def create_user name
      $users ||= {}
      $users[name] ||= ActiveSupport::HashWithIndifferentAccess.new
      $users[name] = Autotest::Users.default_value_for $users[name]
      Autotest::Users.post_create_block.call($users[name])
      set_user_data(name, options = {})

      $users[name]
    end

    def get_user name
      if ($users.nil?) or ($users[name].nil?)
        raise "<#Autotest::Users> User #{name} doesn't exist."
      end
      $users[name]
    end

    def user_data(name, param)
      value = if param.kind_of? Hash
        set_user_data(name, param)
      else
        get_user_data(name, param)
      end
      value
    end

    def set_user_data(name, options = {})
      user = get_user(name)
      options.with_indifferent_access.each do |key, value|
        user[key] = value
      end
      Autotest::Users.post_change_block.call(user)
      options.values.first
    end

    def get_user_data(name, *keys)
      user = get_user(name)
      keys.size == 1 ? user.fetch(keys.first) : keys.map{ |key| user.fetch(key) }
    end

    def current_user(short_name = nil)
      if short_name
        if $users.nil?
          raise "<#Autotest::Users> You should use create_user method, before 'current_user=' method."
        end
        $current_user = $users.fetch(short_name)
      end
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

Autotest::Users.email = 'test@example.com'

Autotest::Users.on_user_create do |user|
end

Autotest::Users.on_user_change do |user|
  user[:full_name] = "#{user[:first_name]} #{user[:last_name]}"
end
