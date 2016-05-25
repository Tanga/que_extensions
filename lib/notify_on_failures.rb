module Que::NotifyDevOnFailures
  def notify_dev_if_needed(e)
    Airbrake.notify(e)
  end
end
