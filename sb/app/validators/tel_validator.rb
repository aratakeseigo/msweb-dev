class TelValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A[0-9]*\z/
      record.errors.add(attribute, :only_number)
    end
    unless value.length == 10 or value.length == 11
      record.errors.add(attribute, :length_10_or_11)
    end
  end
end
