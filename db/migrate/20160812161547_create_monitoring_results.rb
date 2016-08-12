class CreateMonitoringResults < ActiveRecord::Migration[5.0]
  def change
    create_table :monitoring_results do |t|
      t.references :monitoring_context
      t.binary :content
      t.integer :error_code

      t.timestamps
    end
  end
end
