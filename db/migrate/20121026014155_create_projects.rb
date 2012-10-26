class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :description
      t.text :long_description
      t.string :language
      t.integer :creator
      t.boolean :accepted
      t.date :accepted_date

      t.timestamps
    end
  end
end
