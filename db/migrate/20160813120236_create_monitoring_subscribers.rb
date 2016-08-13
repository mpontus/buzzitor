class CreateMonitoringSubscribers < ActiveRecord::Migration[5.0]
  def change
    create_table :monitoring_subscribers do |t|
      t.references :context, foreign_key: true
      t.string :endpoint, null: false, index: { unique: true }
    end
  end
end
