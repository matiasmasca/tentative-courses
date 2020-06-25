

class Course
  attr_reader :teacher, :students_enrolled, :day, :hour, :mode, :level

  def initialize(teacher, mode, level, students=[], day, hour)
    @teacher = teacher
    @mode = mode
    @level = level
    @students_enrolled = students
    @day = day
    self.hour = hour
  end

  def hour=(hour)
    # hour: a Integer that represent the clock hour. It has to be between 9 and 19
    raise 'Error: course hour must be number between 9 and 19' if hour.class != Integer

    raise 'Error: course hour must be number between 9 and 19' unless hour.between?(9, 19)
    @hour = hour
  end



  def schedule_class
    { day: day, hour: hour }
  end

end
