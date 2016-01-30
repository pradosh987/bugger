class BuggerSetup < ActiveRecord::Migration
  def up
    ActiveRecord::Base.transaction do 
      execute("CREATE EXTENSION IF NOT EXISTS hstore;")
      execute("CREATE EXTENSION IF NOT EXISTS pg_trgm;")

      create_table :bugger_jobs do |t|
        t.string :state, :null => false
        t.integer :delayed_job_id
        t.datetime :completed_at 
        t.timestamps
      end
      add_index :bugger_jobs, :state

      create_table :bugger_job_results do |t|
        t.integer :bugger_job_id, :null => false
        t.integer :product_id
        t.hstore :errors
        t.string :state, :null => false

        t.timestamps
      end
      add_index :bugger_job_results, :bugger_job_id
      add_index :bugger_job_results, :state
      add_index :bugger_job_results, :product_id

      create_table :file_attachments do |t|
        t.integer :row_id
        t.string :row_type

        t.timestamps
      end
      add_attachment :file_attachments, :file
      add_index :file_attachments, [:row_id, :row_type], :name => "index_file_attachments_on_row_id_and_row_type"

      create_table :photos do |t|
        t.integer :row_id
        t.string :row_type

        t.timestamps
      end
      add_attachment :photos, :file
      add_index :photos, [:row_id, :row_type], :name => "index_photos_on_row_id_and_row_type"
    end
  end

  def down
    ActiveRecord::Base.transaction do 
      drop_table :bugger_jobs
      drop_table :bugger_job_results
      drop_table :file_attachments
      drop_table :photos
    end
  end
end
