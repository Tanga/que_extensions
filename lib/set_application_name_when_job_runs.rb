module Que::SetApplicationNameWhenJobRuns
  def _run(*)
    old_application_name = get_application_name_when_job_runs
    new_application_name = self.class.name
    set_application_name_when_job_runs(new_application_name)
    super
  ensure
    set_application_name_when_job_runs(old_application_name)
  end

  def get_application_name_when_job_runs
    Que.execute("show application_name").first["application_name"]
  end

  def set_application_name_when_job_runs(application_name)
    Que.execute("set application_name='#{application_name}'")
  end
end

module Que
  class Job
    prepend Que::SetApplicationNameWhenJobRuns
  end
end
