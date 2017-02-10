class QueJobRelationship < ActiveRecord::Base
  self.primary_key = :job_id
  belongs_to :job, class_name: QueJob
  belongs_to :parent, class_name: QueJob
end
