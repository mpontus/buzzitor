class CreateMonitoringContexts < ActiveRecord::Migration[5.0]
  def change
    create_table :monitoring_contexts do |t|
      t.string :url
      t.boolean :active, default: true
      t.datetime :visited_at
      t.datetime :fetched_at

      t.timestamps
    end
  end
end
