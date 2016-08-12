class CreateResults < ActiveRecord::Migration[5.0]
  def change
    create_table :results do |t|
      t.binary :content
      t.int :error_code

      t.timestamps
    end
  end
end
