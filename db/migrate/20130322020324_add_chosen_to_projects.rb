class AddChosenToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :chosen, :boolean, :default => false
  end
end
