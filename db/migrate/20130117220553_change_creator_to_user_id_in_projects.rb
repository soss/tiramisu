class ChangeCreatorToUserIdInProjects < ActiveRecord::Migration
  def up
    rename_column :projects, :creator, :user_id
  end

  def down
    rename_column :projects, :user_id, :creator
  end
end
