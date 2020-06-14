require_relative 'person.rb'

class Student < Person
  attr_reader :full_name, :mode, :level, :schedule

  def initialize(full_name = nil, mode = grupal, level = "Beginner", schedule = [])
    @full_name = full_name
    @mode = mode
    @level = level
    @schedule = schedule
  end

end
