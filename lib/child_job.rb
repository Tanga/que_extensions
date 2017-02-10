module Que::ChildJob
  def enqueue(*args)
    Que.transaction do
      job_data = super

      parent_job_id = args.first[:parent_job_id] rescue nil
      if parent_job_id.present?
        QueJob.where(job_id: job_data.attrs['job_id']).update_all(parent_job_id: parent_job_id)
      end
    end
  end
end
