class AddSiteAttrs < ActiveRecord::Migration
  def self.up
	add_column :sites, :required_permissions, :string
	add_column :sites, :available_permissions, :string
	add_column :sites, :available_actions, :string
	add_column :sites, :available_story_states, :string
	add_column :sites, :default_permit, :string

  end

  def self.down
  end
end
