class DropSessions < ActiveRecord::Migration
  def self.up
    drop_table :sessions
  end

  def self.down
    # up migration is db:sessions:create
  end
end
