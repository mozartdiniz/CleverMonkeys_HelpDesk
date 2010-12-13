require 'digest/sha2'

class User < ActiveRecord::Base
  
  belongs_to :group
  belongs_to :enterprise
  belongs_to :language

  has_many :comments
  has_many :ticket_notification_users
  has_many :log_works

  validates_presence_of :name
  validates_presence_of :email
  
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i  
  validates_uniqueness_of :email
  validates_uniqueness_of :name
  
  attr_accessor :password_confirmation
  validates_confirmation_of :password
  validate :password_non_blank  

  #paperclip upload
  has_attached_file :photo,

    #O style diz o tamanho das imagens que será geradas

    :styles => { :small => ["60", :png], :large => ["200", :png] },

    #O path irá salvar as imagens em sua_app/public/images/bisk/photo/1/thumb_originalfilename.jpg
    :path => ":rails_root/public/images/:class/:attachment/:id/:style_:basename.png",

    #A url irá ficar: localhost:3000/user/photo/1/thumb_originalfilename.jpg
    :url => "/images/:class/:attachment/:id/:style_:basename.png",

    #Bem se você não fizer o upload de nenhuma imagem ele seta uma imagem padrão
    :default_url => "/images/default_avatar.gif"

  def self.authenticate(name, password)
    user = self.find_by_name(name)
    if user
      expected_password = encrypted_password(password, user.salt)
      if user.hashed_password != expected_password
        user = nil
      end
    end
    user
  end  
  
  # 'password' is a virtual attribute
  def password
    @password
  end

  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password = User.encrypted_password(self.password, self.salt)
  end

  private
  def password_non_blank
    errors.add(:password, "Missing password") if hashed_password.blank?
  end

  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end

  def self.encrypted_password(password, salt)
    string_to_hash = password + "wibble" + salt
    Digest::SHA256.hexdigest(string_to_hash)
  end
  
end
