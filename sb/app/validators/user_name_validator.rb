class UserNameValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.nil?
    unless value.split("　").size >= 2
      record.errors.add(attribute, :user_name_split_fullspace)
    end
  end
end
