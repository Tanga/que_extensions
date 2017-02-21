module Jobs
  class WatchChildJobs < Que::Job
    def run(options)
      unless QueJob.where(parent_job_id: options[:job_id]).count > 0
        QueJobStatus.where(job_id: options[:job_id]).update_all(finished_at: Time.now, status: 'finished')

        if options[:on_finished_job_class].present?
          options[:on_finished_job_class].constantize.enqueue(job_id: options[:job_id]);
        end

        return
      end

      self.class.enqueue(options.merge(run_at: Time.current + 5.second))
    end
  end
end
