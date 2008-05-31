class CreateDonations < ActiveRecord::Migration
  def self.up
    create_table :donations do |t|
      t.column :email, :string
      t.column :amount, :float
      t.column :txn_id, :string
      t.column :donation_date, :date
    end
  end

  def self.down
    drop_table :donations
  end
end
