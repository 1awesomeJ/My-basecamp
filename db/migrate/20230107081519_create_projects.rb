class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :Name
      t.string :Description

      t.timestamps
    end
  end
end
