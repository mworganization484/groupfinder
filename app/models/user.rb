class User < ActiveRecord::Base
  
    def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"] || session["devise.linkedin_data"] && session["devise.linkedin_data"]["extra"]["raw_info"] || session["devise.github_data"] && session["devise.github_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
        user.birthday = data["user_birthday"] if user.birthday.blank?
        user.first_name = data["first_name"] if user.first_name.blank?
        user.last_name = data["last_name"] if user.last_name.blank?
        user.image = data["picture"] if user.last_name.blank?
      end
    end
    end
    
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: %i[facebook linkedin github]
  has_many :posts
  has_many :comments, through: :posts
  
  #For Paperclip
  
  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  
  #For omniauth
  
  def self.from_omniauth(auth)
  where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    user.email = auth.info.email
    user.password = Devise.friendly_token[0,20]
    user.username = auth.info.name 
    user.birthday = auth.info.birthday
    user.first_name = auth.info.first_name
    user.last_name = auth.info.first_name
    user.image = auth.info.picture
    # assuming the user model has a name
    # If you are using confirmable and the provider(s) you use validate emails, 
    # uncomment the line below to skip the confirmation emails.
    # user.skip_confirmation!
  end
  end
  
end

