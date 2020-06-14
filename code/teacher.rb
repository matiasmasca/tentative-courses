require_relative 'person'

class Teacher < Person
  attr_reader :name, :schedule

  def initialize(name, schedule=[])
    @name = name
    @schedule = schedule
  end
end
