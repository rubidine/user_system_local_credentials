module UserSystem
  module LocalCredentials
    module Authentication
      ##
      #
      # Login with the given login and passphrase.
      # Will return a user instance or nil.
      #
      def self.login options
        options.symbolize_keys!
        passphrase = options[:passphrase]
        login = options[:login].downcase
        scope = options[:scope] || User
    
        u = scope.find(
              :first,
              :conditions => {User.table_name => {:lowercase_login =>login}}
            )
        if (u and (u.passphrase == User.pw_hash(passphrase)))
          u.update_attribute :last_login, Time.now
          u.sessions.clear
          s = Session.create(:user => u)
          s.new_record? ? nil : s
        else
          nil
        end
      end
    end
  end
end

