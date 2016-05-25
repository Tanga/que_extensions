require 'active_support'
require 'active_support/core_ext'
require 'json'
require 'logger'
require 'active_record'
require_relative '../lib/tanga_que_extensions'

ActiveRecord::Base.establish_connection 'postgres://localhost/tanga_dev'
Que.connection = ActiveRecord

p QueJobStatus.first
p QueJob.first

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
