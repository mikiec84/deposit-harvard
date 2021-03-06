module DepositRequestsHelper
  def document_type_options
    Metadata::TYPES
  end
  
  def status_statement_options
    Metadata::STATUS_STATEMENTS
  end
  
  def language_options
    Metadata::LANGUAGES
  end
  
  def render_jobs(deposit_request)
    html = "<table class='jobs-table'>"
    repositories = deposit_request.jobs.map {|job| YAML.load(job.handler).repository.to_s }
    completed_repositories = deposit_request.repositories.dup - repositories

    deposit_request.jobs.each do |job|
      handler = YAML.load(job.handler)
      html << "<tr><td>"
      
      if job.failed?
        html << "<span style='color: red; font-weight: bold;'>&bull;</span>"
        html << "</td><td class='failed'>"
        html << Deposit.repositories[handler.repository.to_sym].config['name']
        html << "</td></tr>"      
      else
        html << "<span style='color: #e4b100; font-weight: bold;'>&bull;</span>"
        html << "</td><td class='pending'>"
        html << Deposit.repositories[handler.repository.to_sym].config['name']        
        html << "</td></tr>"
      end
    end
    
    html << "</table><table class='jobs-table completed-jobs-table'>"
    
    completed_repositories.each do |completed|
      html << "<tr><td><span style='color: #ccc; font-weight: bold;'>&bull;</span></td><td>"
      html << Deposit.repositories[completed.to_sym].config['name']
      html << " (completed)</td></tr>"
    end
    
    html << "</table>"
    
    html.html_safe
  end
end
