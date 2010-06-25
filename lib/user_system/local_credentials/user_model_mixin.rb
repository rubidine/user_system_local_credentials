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
    module UserModelMixin

      def self.included kls
        kls.validate :passphrase_length
        kls.validate :passphrase_confirmation_match
        kls.validates_presence_of :passphrase, :identifier => 'has_passphrase'
        kls.send :attr_reader, :passphrase_confirmation
        kls.send :extend, ClassMethods
      end

      ##
      #
      # Passwords are hashed, so compute the hash when assigning it.
      #
      def passphrase= new_passphrase
        return if new_passphrase.blank?
        @passphrase = new_passphrase
        write_attribute(:passphrase, pw_hash(new_passphrase))
      end

      ##
      #
      # Passwords are hashed, so compute the hash when assigning it.
      #
      def passphrase_confirmation= new_passphrase
        @passphrase_confirmation = pw_hash(new_passphrase)
      end

      private

      def pw_hash str
        self.class.pw_hash(str)
      end

      #
      # This is not a validates_length_of because at that point, the passphrase
      # is already a hash that always has a length of 32.
      #
      def passphrase_length
        if @passphrase and @passphrase.length < 5
          errors.add(:passphrase, 'is too short (minimum is 5 characters)')
        end
      end

      def passphrase_confirmation_match
        unless @passphrase_confirmation == passphrase
          errors.add(:passphrase, 'does not match confirmation')
        end
      end

      module ClassMethods
        def pw_hash str
          Digest::MD5.hexdigest(str)
        end
      end
    end
  end
end
