class QueJobStatus < ActiveRecord::Base
  self.table_name = :que_job_status

  belongs_to :que_job
end
