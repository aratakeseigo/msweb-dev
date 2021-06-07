class ZipCodeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A[0-9]*\z/
      record.errors.add(attribute, :only_number)
    end
    unless value.length == 7
      record.errors.add(attribute, :wrong_length, count: 7)
    end
  end
end
