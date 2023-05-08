class CreateForecasts < ActiveRecord::Migration[6.1]
  def change
    create_table :forecasts do |t|
      t.string :address
      t.float :temperature
      t.boolean :cached

      t.timestamps
    end
  end
end
