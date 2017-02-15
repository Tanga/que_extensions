class QueJobStatus < ActiveRecord::Base
  self.table_name = :que_job_status

  def self.raw_job_data(job_id)
    query = ['SELECT status, job_data from que_job_status where job_id = ?', job_id]
    sanitized = sanitize_sql_array(query)
    connection.execute(sanitized).first
  end
end
