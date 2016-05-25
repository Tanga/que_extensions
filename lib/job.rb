class Que::Job
  private
  def self.class_for(job)
    job.constantize
  end
end
