require 'active_support'
require 'active_support/core_ext'
require 'json'
require 'logger'
require 'active_record'
require_relative '../lib/tanga_que_extensions'

require 'pry'

ActiveRecord::Base.establish_connection 'postgres://localhost/channel_advisor_dev'
Que.connection = ActiveRecord

ActiveRecord::Base.logger = Logger.new($stdout)

class OnFinish < Que::Job
  prepend Que::RecordJobStatus

  def run(args)
    puts args.inspect
  end
end

class Child < Que::ChildJob
  prepend Que::RecordJobStatus
  prepend Que::RecordJobStatusToParentJob

  def run(args)
    sleep(args[:i])
    update_job_data(args)
  end
end

class Parent < Que::Job
  prepend Que::RecordJobStatus
  prepend Que::WaitForChildJobs

  def run(args)
    5.times do |i|
      Child.enqueue(i: i, parent_job_id: job_id)
    end
  end

  def on_finished_job_class
    OnFinish.to_s
  end
end

QueJob.delete_all
QueJobStatus.delete_all
Que.logger = Logger.new(STDOUT)
Que.mode = :async

Parent.enqueue
gets
Que.mode = :none
binding.pry
