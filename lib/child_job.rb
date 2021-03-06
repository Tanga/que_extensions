module Que
  class ChildJob < Que::Job
    def self.enqueue(*args)
      Que.transaction do
        job_data = super

        parent_job_id = args.first[:parent_job_id] rescue nil
        if parent_job_id.present?
          QueJob.where(job_id: job_data.attrs['job_id']).update_all(parent_job_id: parent_job_id)
        end

        job_data
      end
    end
  end
end
