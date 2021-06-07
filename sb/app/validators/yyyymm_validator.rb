class YyyymmValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A[0-9]*\z/
      record.errors.add(attribute, :only_number)
    end
    unless value.length == 6
      record.errors.add(attribute, :wrong_length, count: 7)
    end
    unless value.last(2).to_i <= 12
      record.errors.add(attribute, :month_in_1_12)
    end
  end
end
