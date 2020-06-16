

class Course
  attr_reader :teacher, :students, :day, :hour, :mode
  def initialize(teacher, students=[], day, hour, mode)
    @teacher = teacher
    @students = students
    @day = day
    @hour = hour
    @mode = mode
  end

end
