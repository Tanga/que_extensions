class QueJob < ActiveRecord::Base
  self.primary_key = :job_id

  def run
    job_class.constantize.new(attributes.with_indifferent_access)._run
    destroy
  end
end
