class Rollin::MetatagKey
  attr_reader :label, :values

  def initialize(label, values)
    @label, @values = label, values
  end
end
