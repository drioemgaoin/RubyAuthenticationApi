module Api
  module Models
    module Validatable
      extend ActiveSupport::Concern

      VALIDATIONS = [:validates_presence_of, :validates_uniqueness_of, :validates_format_of,
                     :validates_confirmation_of, :validates_length_of].freeze

      def self.required_fields(klass)
        []
      end

      def self.included(base)
        assert_validations_api!(base)

        base.class_eval do
          validates_presence_of   :email, if: :email_required?, message: :email_is_required;
          validates_uniqueness_of :email, allow_blank: true, if: :email_changed?, message: :unique_email;
          validates_format_of     :email, with: /\A[^@\s]+@[^@\s]+\z/, allow_blank: true, if: :email_changed?, message: :bad_format_email;

          validates_presence_of     :password, if: :password_required?, message: :password_is_required;
          validates_confirmation_of :password, if: :password_required?, message: :confirmation_password_not_match;
          validates_length_of       :password, within: 6..128, allow_blank: true, message: :bad_length_password
        end
      end

      def self.assert_validations_api!(base)
        unavailable_validations = VALIDATIONS.select { |v| !base.respond_to?(v) }

        unless unavailable_validations.empty?
          raise "Could not use :validatable module since #{base} does not respond " <<
                "to the following methods: #{unavailable_validations.to_sentence}."
        end
      end

      protected

      def password_required?
        !persisted? || !password.nil? || !password_confirmation.nil?
      end

      def email_required?
        true
      end

      module ClassMethods
        Api::Models.config(self, :email_regexp, :password_length)
      end
    end
  end
end
