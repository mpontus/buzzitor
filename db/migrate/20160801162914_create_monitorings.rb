class CreateMonitorings < ActiveRecord::Migration[5.0]
  def change
    create_table :monitorings do |t|
      t.string :address_url
      t.string :subscriber_endpoint
      t.binary :content_url
      t.string :error_code
      t.datetime :fetched_at

      t.timestamps
    end
  end
end
