module Api
  module Models
    module Recoverable
      extend ActiveSupport::Concern

      def self.required_fields(klass)
        [:reset_password_sent_at, :reset_password_token]
      end

      included do
        before_update :clear_reset_password_token, if: :clear_reset_password_token?
      end

      # Update password saving the record and clearing token. Returns true if
      # the passwords are valid and the record was saved, false otherwise.
      def reset_password(new_password, new_password_confirmation)
        self.password = new_password
        self.password_confirmation = new_password_confirmation

        save
      end

      # Resets reset password token and send reset password instructions by email.
      # Returns the token sent in the e-mail.
      def send_reset_password_token
        set_reset_password_token
      end

      # Checks if the reset password token sent is within the limit time.
      # We do this by calculating if the difference between today and the
      # sending date does not exceed the confirm in time configured.
      # Returns true if the resource is not responding to reset_password_sent_at at all.
      # reset_password_within is a model configuration, must always be an integer value.
      def reset_password_period_valid?
        reset_password_sent_at && reset_password_sent_at.utc >= self.class.reset_password_within.ago.utc
      end

      protected

        def clear_reset_password_token
          self.reset_password_token = nil
          self.reset_password_sent_at = nil
        end

        def set_reset_password_token
          raw, enc = Api.token_generator.generate(self.class, :reset_password_token)

          self.reset_password_token   = enc
          self.reset_password_sent_at = Time.now.utc
          save(validate: false)
          raw
        end

        def clear_reset_password_token?
          encrypted_password_changed = respond_to?(:encrypted_password_changed?) && encrypted_password_changed?
          authentication_keys_changed = self.class.authentication_keys.any? do |attribute|
            respond_to?("#{attribute}_changed?") && send("#{attribute}_changed?")
          end

          authentication_keys_changed || encrypted_password_changed
        end

      module ClassMethods
        Api::Models.config(self, :reset_password_keys, :reset_password_within)

        # Attempt to find a user by password reset token. If a user is found, return it
        # If a user is not found, return nil
        def with_reset_password_token(token)
          reset_password_token = Api.token_generator.digest(self, :reset_password_token, token)
          to_adapter.find_first(reset_password_token: reset_password_token)
        end

        def send_reset_password_token(attributes={})
          recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
          return recoverable.send_reset_password_token if recoverable.persisted?
          nil if !recoverable.persisted?
        end

        # Attempt to find a user by its reset_password_token to reset its
        # password. If a user is found and token is still valid, reset its password and automatically
        # try saving the record. If not user is found, returns a new user
        # containing an error in reset_password_token attribute.
        # Attributes must contain reset_password_token, password and confirmation
        def reset_password_by_token(attributes={})
          original_token       = attributes[:reset_password_token]
          reset_password_token = Api.token_generator.digest(self, :reset_password_token, original_token)

          recoverable = find_or_initialize_with_error_by(:reset_password_token, reset_password_token)

          if recoverable.persisted?
            if recoverable.reset_password_period_valid?
              recoverable.reset_password(attributes[:password], attributes[:password_confirmation])
            else
              recoverable.errors.add(:reset_password_token, :expired)
            end
          end

          recoverable.reset_password_token = original_token if recoverable.reset_password_token.present?
          recoverable
        end
      end
    end
  end
end
