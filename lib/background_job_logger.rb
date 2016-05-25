module Que
  module BackgroundJobLogger
    def _run(*)
      start_time    = Time.current
      start_memory  = Que::MemoryInfo.rss

      super

      end_time       = Time.current
      total_run_time = end_time - start_time
      current_memory = Que::MemoryInfo.rss
      memory_taken   = current_memory - start_memory

      TangaServices.logger.info(
        service:          'que_jobs',
        status:           'job_finished',
        end_time:         end_time,
        total_run_time:   total_run_time,
        job:              self.class.name,
        attrs:            attrs,
        current_memory:   current_memory,
        change_in_memory: memory_taken
      )
    end
  end

  class Job
    prepend Que::BackgroundJobLogger
  end
end
