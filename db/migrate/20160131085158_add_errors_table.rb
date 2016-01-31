class AddErrorsTable < ActiveRecord::Migration
  def up
    ActiveRecord::Base.transaction do
      create_table :data_errors do |t|
        t.integer :bugger_job_result_id, :null => false
        t.string :key, :null => false
        t.string :type, :null => false
        t.string :expected_value
        t.string :actual_value

        t.timestamps
      end

      add_index :data_errors, :bugger_job_result_id
    end
  end

  def down
    ActiveRecord::Base.transaction do 
      drop_table :data_errors
    end
  end
end
