class ApplicationForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::AttributeMethods
  include ActiveRecord::AttributeMethods::BeforeTypeCast
  include ActiveModel::Serializers::JSON
end
