module Codecamp
  module Ext
    module UserAuthentication
      extend ActiveSupport::Concern

      included do
        include Mongoid::Slug
        # other attributes
        attr_accessor :provider, :uid, :is_suspended

        # Include default devise modules. Others available are:
        # :token_authenticatable, :confirmable, :timeoutable and :omniauthable
        devise :database_authenticatable, :registerable, :lockable,
               :recoverable, :rememberable, :trackable, :validatable, :omniauthable

        ## Database authenticatable
        field :email,              :type => String, :default => ""
        field :encrypted_password, :type => String, :default => ""

        validates_presence_of :email
        validates_presence_of :encrypted_password

        ## Recoverable
        field :reset_password_token,   :type => String
        field :reset_password_sent_at, :type => Time

        ## Rememberable
        field :remember_created_at, :type => Time

        ## Trackable
        field :sign_in_count,      :type => Integer, :default => 0
        field :current_sign_in_at, :type => Time
        field :last_sign_in_at,    :type => Time
        field :current_sign_in_ip, :type => String
        field :last_sign_in_ip,    :type => String

        ## Confirmable
        field :confirmation_token,   :type => String
        field :confirmed_at,         :type => Time
        field :confirmation_sent_at, :type => Time
        field :unconfirmed_email,    :type => String # Only if using reconfirmable

        ## Lockable
        field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
        field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
        field :locked_at,       :type => Time

        field :status, type: String, default: 'active'
        field :is_deleted,            type: Boolean,  default: false

        # scopes
        # default_scope   where(:is_deleted => false, :guest => false)
        scope :active,  where(:status => "active")
        scope :suspend, where(:status => "suspended")


        ## Token authenticatable
        # field :authentication_token, :type => String

        index({email: 1})

        before_save :check_lock
        after_initialize :check_suspension

      end


      module ClassMethods

        # Class method to find user by facebook authentication
        def find_for_facebook_oauth(auth, resource=nil)
          user = User.where('tokens.category' => auth.provider, 'tokens.account_guid' => auth.uid).first

          if resource.present? && user.blank?
            token = resource.tokens.create(token: auth.credentials.token,
                             username: auth.info.nickname,
                             account_guid: auth.uid,
                             category: auth.provider)
          end

          # return user
          user
        end

        # Class method to find user by twitter authentication
        def find_for_twitter_oauth(auth, resource=nil)
          user = User.where('tokens.category' => auth.provider, 'tokens.account_guid' => auth.uid).first

          if resource.present? && user.blank?
            token = resource.tokens.create(token: auth.credentials.token,
                             username: auth.info.nickname,
                             account_guid: auth.uid,
                             category: auth.provider)
          end

          user
        end

        # find user by linkedin authentication
        def find_for_linkedin_oauth(auth, resource=nil)
          user = User.where('tokens.category' => auth.provider, 'tokens.account_guid' => auth.uid).first

          if resource.present? && user.blank?
            token = resource.tokens.create(token: auth.credentials.token,
                             username: auth.info.nickname,
                             account_guid: auth.uid,
                             category: auth.provider)
          end

          user
        end

        # find user by google authentication
        def find_for_google_oauth(auth, resource=nil)
          user = User.where('tokens.category' => auth.provider, 'tokens.account_guid' => auth.uid).first

          if resource.present? && user.blank?
            token = resource.tokens.create(token: auth.credentials.token,
                             username: auth.info.nickname,
                             account_guid: auth.uid,
                             category: auth.provider)
          end

          user
        end

        def find_by_slug(val)
          where(:_slugs.in => [val]).first
        end


      end

      private

      def check_lock
        if valid?
          if locked_at.present? && !self.is_suspended
            self.unlock_access!
          elsif locked_at.blank? && self.is_suspended
            self.lock_access!
          end
        end
      end

      def check_suspension
        self.is_suspended = false
        self.is_suspended = true if self.locked_at.present?
      end

    end
  end
end