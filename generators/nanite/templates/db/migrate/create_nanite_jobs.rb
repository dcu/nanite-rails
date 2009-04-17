class <%= migration_name %> < ActiveRecord::Migration
  def self.up
    create_table "nanite_jobs", :force => true do |t|
      t.string :target_class
      t.string :method
      t.text :arguments
      t.boolean :performed, :default => false
      t.integer :failed, :default => false
      t.integer :priority, :default => 3

      t.timestamps
    end
    add_index :nanite_jobs, :priority
  end

  def self.down
    drop_table "nanite_jobs"
  end
end
