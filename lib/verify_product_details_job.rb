class VerifyProductDetailsJob
  attr_accessor :bugger_job_id, :filepath, :sheet_name
  
  def initialize(bugger_job_id, filepath, sheet_name)
    @filepath = filepath
    @bugger_job_id = bugger_job_id
    @sheet_name = sheet_name
  end

  def perform
    xl_file = Bugger::XlExtractor.new(@filepath, @sheet_name)

    xl_file.each do |row|
      wp = Bugger::Webpage.new(Bugger::Flipkart.get_product_link(row))
      bugger_res = BuggerJobResult.new({:bugger_job_id => @bugger_job_id, 
                                        :product_ref => Bugger::Flipkart.get_product_ref(row)}, 
                                        {:without_protection => true})
      # Assign product details
      bugger_res.product_image_url = Bugger::Flipkart.get_product_image_url(row) 
      bugger_res.product_title = Bugger::Flipkart.get_product_title(wp)
      bugger_res.product_page_url = Bugger::Flipkart.get_product_link(row)
      
      # Check product details
      res = Bugger::Flipkart.assert_fk_row(row, wp, bugger_res)

      # Save results object to DB
      res.save!
    end

    # Mark the job completed
    bjob = BuggerJob.find(@bugger_job_id).complete!
  end

  def queue_name
    'verify_product_details'
  end  
end