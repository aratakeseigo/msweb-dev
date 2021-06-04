class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ Devise.email_regexp
      record.errors.add(attribute, :invalid_email_address, email: value)
    end
  end
end
