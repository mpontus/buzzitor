class CreateMonitorings < ActiveRecord::Migration[5.0]
  def change
    create_table :monitorings do |t|
      t.string :address
      t.string :endpoint
      t.binary :content
      t.string :error

      t.timestamps
    end
  end
end
