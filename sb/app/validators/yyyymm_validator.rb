class YyyymmValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A[0-9]*\z/
      record.errors.add(attribute, :only_number)
    end
    unless value.length == 6
      record.errors.add(attribute, :wrong_length, count: 7)
    end
    unless (1..12).include? value.last(2).to_i
      record.errors.add(attribute, :month_in_1_12)
    end
    unless value.first(4).to_i > 1900
      record.errors.add(attribute, :month_in_1_12)
    end
  end
end
