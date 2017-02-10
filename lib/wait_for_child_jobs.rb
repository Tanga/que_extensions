module Que::WaitForChildJobs
  def record_job_finished
    job_scope.update_all(status: 'waiting-for-child-jobs')
    Jobs::WatchChildJobs.enqueue(job_id: job_id)
  end
end
