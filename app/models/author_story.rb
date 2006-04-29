class AuthorStory < ActiveRecord::Base
  belongs_to :author
  has_and_belongs_to_many :stories,
  :join_table =>
    "authors_stories",
  :foreign_key => "user_id"
end
