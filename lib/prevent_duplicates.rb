require 'digest/md5'

module Que
  module PreventDuplicates
    def self.included(base)
      base.send(:extend, ClassMethods)
    end

    module ClassMethods
      def enqueue(*args)
        # Handle args same way que does
        if args.last.is_a?(Hash)
          options   = args.pop
          options.delete(:queue) || '' if options.key?(:queue)
          job_class = options.delete(:job_class)
          options.delete(:run_at)
          options.delete(:priority)
          args << options if options.any?
        end

        md5 = Digest::MD5.hexdigest("#{job_class || to_s}#{args.to_json}")
        if ::QueJob.where("md5(job_class || args::text) = ?", md5).exists?
          puts "preventing dupes"
          return
        else
          super
        end
      end
    end
  end
end
