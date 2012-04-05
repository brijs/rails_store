class User < ActiveRecord::Base
	attr_accessible :name, :email, :password, :password_confirmation
	# password, and password_confirmation are actually not stored in the db.
	# By default, all db fields are accessible, but by using attr_accessible
	# explicity, only the enumerated fields are accessible. This is generally
	# preferred for security reasons, especially with a table which contains
	# sensitive information such as users/login table

	has_secure_password #validates :password, :password_digent, :presence => true
	# has_secure_password relies on model.attribute-name password_digest
	# & model.password. see the generated db/schema.rb file
	# see https://github.com/rails/rails/blob/master/activemodel/lib/active_model/secure_password.rb?version=3.2#
	# secure_password.rb -- it is a very simple module that adds two methods 
	# to ActiveModel; has_secure_password and password=

	has_many :microposts, dependent: :destroy

	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	has_many :followed_users, through: :relationships, source: :followed
	
	has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
	has_many :followers, through: :reverse_relationships, source: :follower

	validates :name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email,   presence:   true,
						format:     { with: VALID_EMAIL_REGEX },
						uniqueness: { case_sensitive: false }
	validates :password, presence:true, length: { minimum: 6 }
	validates :password_confirmation, presence: true

	# callback method to auto-generate a remember-token before saving to db
	before_save :create_remember_token

	def following?(other_user)
		relationships.find_by_followed_id(other_user.id)
	end

	def follow!(other_user)
		relationships.create!(followed_id: other_user.id)
	end
	
	def unfollow!(other_user)
	    relationships.find_by_followed_id(other_user.id).destroy
	end	

	
    def feed
	    Micropost.from_users_followed_by(self)
	end

	private
	def create_remember_token
		self.remember_token = SecureRandom.urlsafe_base64
	end

end
