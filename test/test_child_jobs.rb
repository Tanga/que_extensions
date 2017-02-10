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

class Child < Que::Job
  prepend Que::ChildJob
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
end

QueJob.delete_all
QueJobStatus.delete_all
Que.logger = Logger.new(STDOUT)
Que.mode = :async

Parent.enqueue
gets
