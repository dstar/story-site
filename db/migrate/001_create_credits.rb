class CreateCredits < ActiveRecord::Migration
  def self.up
    create_table :credits do |t|
      # t.column :name, :string
	t.column :user_id, :integer, :null => false
	t.column :story_id, :integer, :null => false
	t.column :credit_type, :string, :null => false, :default => "Author"
    end
  end

  def self.down
    drop_table :credits
  end
end
