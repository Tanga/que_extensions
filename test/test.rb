require 'active_support'
require 'active_support/core_ext'
require 'json'
require 'logger'
require 'active_record'
require_relative '../lib/tanga_que_extensions'

ActiveRecord::Base.establish_connection 'postgres://localhost/channel_advisor_dev'
Que.connection = ActiveRecord

QueJob.delete_all
QueJobStatus.delete_all

# ActiveRecord::Base.logger = Logger.new($stdout)
# Que.logger = Logger.new(STDOUT)

class J < Que::Job
  prepend Que::RecordJobStatus
  prepend Que::NotifyDevOnFailures
  include Que::PreventDuplicates

  class Ack < StandardError
    def initialize(message, args)
      @message = message
      @args = args
    end

    def as_json(*)
      { foo: @args }
    end

    def message
      "i acked"
    end
  end

  def run(args)
    Que.execute 'select pg_sleep(2)'
    puts "J running with #{args}"
  end
end


# Running job manually and getting status
job_id = J.enqueue({foo: 4, joe: 'args'}).attrs['job_id']
QueJob.find(job_id).run
puts QueJobStatus.raw_job_data(job_id)

Que.mode  = :async

loop do
  J.enqueue({foo: 1, joe: 'args'})
  J.enqueue({foo: 1, joe: 'args'})

  sleep 1
end

