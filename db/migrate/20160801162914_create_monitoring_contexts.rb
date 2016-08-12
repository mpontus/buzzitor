class CreateMonitoringContexts < ActiveRecord::Migration[5.0]
  def change
    create_table :monitoring_contexts do |t|
      t.string :url
      t.string :endpoint
      t.datetime :fetched_at

      t.timestamps
    end
  end
end
