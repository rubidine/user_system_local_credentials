# Copyright (c) 2009 Todd Willey <todd@rubidine.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

module UserSystem
  module LocalCredentials
    module Authentication
      ##
      #
      # Login with the given login and passphrase.
      # Will return a user instance or nil.
      #
      # If valid, will touch the last_login attribute of the user model.
      #
      def self.login controller
        params = controller.params
        return nil unless params[:session]
        passphrase = params[:session][:passphrase]
        login = params[:session][:login].downcase

        scope = controller.send(:user_scope)
        scope = scope.for_login(login)

        session_model = controller.class.send(:session_model_for_this_controller)
    
        u = scope.find(:first)
        if (u and (u.passphrase == User.pw_hash(passphrase)))
          u.logged_in(self)
          s = session_model.create(:user => u)
          if s.new_record?
            u.error_message = "Unable to create session: " +
                              s.errors.full_messages.inspect
            return nil
          end
          return s
        else
          return nil
        end
        # notreached
      end
    end
  end
end

