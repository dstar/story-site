class Php_Session < ActiveRecord::Base
  belongs_to :user

  def self.primary_key() "session_id"  end
end
