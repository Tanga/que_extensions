class QueJob < ActiveRecord::Base
  self.primary_key = :job_id

  def run
    job_class.constantize.new(attributes.symbolize_keys)._run
    destroy
  end
end
