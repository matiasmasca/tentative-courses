
class Student
  attr_reader :full_name, :mode, :level, :schedule

  def initialize(full_name = nil, mode = grupal, level = "Beginner", schedule = nil)
    @full_name = full_name
    @mode = mode
    @level = level
    @schedule = schedule
  end

end
