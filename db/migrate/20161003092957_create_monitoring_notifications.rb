class CreateMonitoringNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :monitoring_notifications do |t|
      t.references :context, foreign_key: { to_table: :monitoring_contexts }
      t.string :endpoint
      t.boolean :fetched, default: false, null: false
      t.string :title
      t.string :body
      t.string :icon

      t.timestamps
    end
  end
end
