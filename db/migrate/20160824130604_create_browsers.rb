class CreateBrowsers < ActiveRecord::Migration
  def change
    create_table :browsers do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
