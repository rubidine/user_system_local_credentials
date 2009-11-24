module UserSystem
  module LocalCredentials
    module UserModelMixin

      def self.included kls
        kls.validates_length_of :passphrase, :minimum => 5
        kls.validate_on_create :passphrase_confirmation_match
        kls.validates_presence_of :passphrase, :identifier => 'has_passphrase'
        kls.send :attr_reader, :passphrase_confirmation
        kls.send :extend, ClassMethods
      end

      ##
      #
      # Passwords are hased, so compute the hash when assigning it.
      #
      def passphrase= new_passphrase
        return if new_passphrase.blank?
        write_attribute(:passphrase, pw_hash(new_passphrase))
      end

      ##
      #
      # Passwords are hased, so compute the hash when assigning it.
      #
      def passphrase_confirmation= new_passphrase
        @passphrase_confirmation = pw_hash(new_passphrase)
      end

      private

      def pw_hash str
        self.class.pw_hash(str)
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
