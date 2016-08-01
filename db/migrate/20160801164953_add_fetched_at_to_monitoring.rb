class AddFetchedAtToMonitoring < ActiveRecord::Migration[5.0]
  def change
    add_column :monitorings, :fetched_at, :datetime
  end
end
