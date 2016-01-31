class InterfaceController < ApplicationController

  def index
    
  end

  def assert_fk_data
    # Save the incoming file
    # Create a bugger job entry

    @filepath = './C_Tops_muqqvoa79pvme6qm_2801-174401_REQEFE7J0LAMV.xls'
    @sheet_name = "t_shirt"
    @bugger_job_id = 123

    # Queue a delayed job

    # This will most probably be inside custom delayed job
    xl_file = Bugger::XlExtractor.new(@filepath, @sheet_name)

    res_array = []
    xl_file.each do |row|
      wp = Bugger::Webpage.new(Bugger::Flipkart.get_product_link(row))
      bugger_res = BuggerJobResult.new({:bugger_job_id => @bugger_job_id, :state =>"test", :product_ref => Bugger::Flipkart.get_product_ref(row)}, {:without_protection => true})
      res = Bugger::Flipkart.assert_fk_row(row, wp, bugger_res)
      res_array.push(res)
    end
  end

  # {
  #   product_ref: "flipkart ref number"
  #   main_image: "img url",
  #   title: "Some title",
  #   page_url: "flipkart page url"
  #   errors: [
  #     {
  #       key: "Some key",
  #       type: "mismatch",
  #       expected_value: "abc",
  #       actual_value: "xyz"
  #     },
  #     {
  #       key: "Some key",
  #       type: "missing"
  #     }
  #   ]
  # }
  def create_bugger_job
    ActiveRecord::Base.transaction do
      bjob = BuggerJob.new(params[:bugger_job], {:without_protection => true})
      bjob.file_attachment = FileAttachment.new({:file => params[:input_file]}, {:without_protection => true})
      bjob.save!
      puts "result => #{bjob.errors.inspect}"
      
    end
    render "show_results"
  end

  def poll

  end

end
