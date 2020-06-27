require_relative 'schedule'

class Student
  include Schedulable

  attr_reader :full_name, :mode, :level, :schedule

  def initialize(full_name = nil, mode = grupal, level = "Beginner", schedule_arg = [])
    @full_name = full_name
    @mode = mode
    @level = level
    @schedule = parse_schedule(schedule_arg)
  end

  def self.find_student_by_name(students, student_name)
    # students: an array list of objects Student.
    # student_name: a string thar represetn the value of full_name attribute
    students.select { |student| student.full_name == student_name } # find the student object
  end
end
