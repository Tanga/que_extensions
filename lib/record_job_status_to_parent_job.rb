module Que::RecordJobStatusToParentJob
  def parent_job_id
    @attrs['args'].first['parent_job_id'] || 0
  rescue
    0
  end

  def update_job_data(job_data)
    super if defined?(super)

    parent_job_scope.find_each do |parent_job|
      parent_job.with_lock do
        parent_job.job_data = [] unless parent_job.job_data.kind_of?(Array)
        parent_job.job_data << job_data
        parent_job.save!
      end
    end
  end

  def parent_job_scope
    QueJobStatus.where(job_id: parent_job_id)
  end
end
