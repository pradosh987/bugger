class InterfaceController < ApplicationController

  def index
    render
  end

  def create_bugger_job
    ActiveRecord::Base.transaction do
      bjob = BuggerJob.new(params[:bugger_job], {:without_protection => true})
      bjob.file_attachment = FileAttachment.new({:file => params[:input_file]}, {:without_protection => true})
      bjob.save!

      filepath = bjob.file_attachment.file.path
      sheet_name = "t_shirt"
      @dj = Delayed::Job.enqueue(VerifyProductDetailsJob.new(bjob.id, filepath, sheet_name))
      
      bjob.delayed_job_id = @dj.id
      bjob.save!
    end

    render "show_results"
  end

  def get_poll_results
    bugger_job = BuggerJob.where(:id => params[:bugger_job_id]).first
    raise "No job present with ID #{params[:bugger_job_id]}" if bugger_job.blank?
    job_results = BuggerJobResult.where(:bugger_job_id => params[:bugger_job_id])

    ret = poll_result_json(bugger_job, job_results)
    render :json => ret 
  end

  private
  def poll_result_json(bugger_job, bugger_job_results)
    ret = {:bugger_job => bugger_job.as_json(:only => [:state, :delayed_job_id, :completed_at])}
    ret[:bugger_job][:results] = get_bugger_job_results_json(bugger_job_results)
    return ret
  end

  def get_bugger_job_results_json(bugger_job_results)
    return bugger_job_results.collect {|jr| get_bugger_job_result_json(jr) }
  end

  def get_bugger_job_result_json(bugger_job_result)
    ret = bugger_job_result.as_json(:methods => [:product_image_url, :product_title, :product_page_url])
    ret[:errors] = bugger_job_result.data_errors.as_json
    return ret
  end

  # {
  #   bugger_job: {
  #     :state => "processing",
  #     :delayed_job_id => "123",
  #     :completed_at => "sometime",
  #     :results => [
  #       {
  #         product_ref: "flipkart ref number"
  #         product_image: "img url",
  #         product_title: "Some title",
  #         product_page_url: "flipkart page url"
  #         errors: [
  #           {
  #             key: "Some key",
  #             type: "mismatch",
  #             expected_value: "abc",
  #             actual_value: "xyz"
  #           },
  #           {
  #             key: "Some key",
  #             type: "missing"
  #           }
  #         ]
  #       }
  #     ]
  #   } 
  # }

end
