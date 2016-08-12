class CreateMonitorings < ActiveRecord::Migration[5.0]
  def change
    create_table :monitorings do |t|
      t.string :url
      t.string :endpoint
      t.binary :content
      t.string :error
      t.datetime :fetched_at

      t.timestamps
    end
  end
end
