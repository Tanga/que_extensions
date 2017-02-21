module Que::WaitForChildJobs
  def record_job_finished
    job_scope.update_all(status: 'waiting-for-child-jobs')
    Jobs::WatchChildJobs.enqueue(
      job_id: job_id,
      on_finished_job_class: (defined? on_finished_job_class) ? on_finished_job_class : nil
    )
  end
end
