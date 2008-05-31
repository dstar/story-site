class CreateCommitments < ActiveRecord::Migration
  def self.up
    create_table :commitments do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :commitments
  end
end
