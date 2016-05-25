require_relative '../lib/periodic_job'
require 'active_support'
require 'active_support/core_ext'
require 'sequel'
require 'json'
require 'logger'
require 'active_record'

ActiveRecord::Base.establish_connection 'postgres://localhost/tanga_dev'
Que.connection = Sequel.connect('postgres://localhost/tanga_dev')

class QueJobStatus < ActiveRecord::Base
  self.table_name = :que_job_status
end

class J < Que::Job
  prepend Que::RecordJobStatus
  prepend Que::NotifyDevOnFailures

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
    puts "J running with #{args}"
  end
end

Que.mode = :async

J.enqueue({foo: 1, joe: 'args'})

gets
