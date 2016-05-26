module Que::RecordJobStatus
  def job_id
    @job_id || 0
  end

  def run(args={})
    @job_id = self.attrs['job_id']
    record_job_started
    super if defined?(super)
    record_job_finished
  rescue => e
    record_job_failed(e)
    notify_dev_if_needed(e)
  end

  def notify_dev_if_needed(e)
    super if defined?(super)
  end

  def record_job_failed(e)
    TangaServices.logger.error(service: 'que_jobs', status: 'error', error: e.to_json)
    job_scope.update_all(status: 'failed', error: { message: e.message, caller: e.backtrace, args: e.as_json })
  end

  def record_job_started
    QueJobStatus.where(job_id: job_id).delete_all
    QueJobStatus.create!(job_id: job_id, attrs: attrs, status: 'executing')
  end

  def record_job_finished
    job_scope.update_all(finished_at: Time.now, status: 'finished')
  end

  def update_job_data(job_data)
    job_scope.update_all(job_data: job_data)
  end

  def job_scope
    QueJobStatus.where(job_id: job_id)
  end
end
