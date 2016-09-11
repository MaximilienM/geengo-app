class CreateGolfCourses < ActiveRecord::Migration
  def change
    create_table :golf_courses do |t|
      t.belongs_to :infrastructure
      t.string :name
      t.integer :holes_count
      t.integer :par
      t.integer :length, :default => 0
      t.integer :white_slope
      t.integer :yellow_slope
      t.integer :red_slope
      t.integer :blue_slope

      t.timestamps
    end
    add_index :golf_courses, :infrastructure_id
  end
end
