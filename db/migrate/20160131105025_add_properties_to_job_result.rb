class AddPropertiesToJobResult < ActiveRecord::Migration
  def up
    ActiveRecord::Base.transaction do 
      add_column :bugger_job_results, :properties, :hstore
    end
  end

  def down
    ActiveRecord::Base.transaction do 
      remove_column :bugger_job_results, :properties
    end
  end
end
