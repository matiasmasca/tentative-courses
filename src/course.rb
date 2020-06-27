require_relative 'schedule'

class Course
  include Schedulable

  attr_reader :teacher, :students_enrolled, :day, :hour, :mode, :level

  def initialize(teacher, mode, level, students=[], day, hour)
    self.teacher = teacher
    self.mode = mode
    self.level = level
    self.students_enrolled = students
    self.day = day
    self.hour = hour
  end

  def teacher=(teacher)
    # has to be an instance of the class Teacher
    raise 'Error: Nil value is not allowed for Teacher param.' if teacher.class == NilClass
    raise 'Error: empty value is not allowed for Teacher param.' if teacher.class == Array && teacher.empty?

    @teacher = teacher
  end

  def mode=(mode)
    # mode: is a Symbol that represent the mode of the course. Single for one student course and Group for multiple-student course.
    raise "Error: mode is not a Symbol." unless mode.class == Symbol
    raise "Error: mode is not a valid option. It has to be :single or :group." if mode != :single && mode != :group
    @mode = mode
  end

  def level=(level)
    # level: a string that represent the level of the course
    levels_enabled = %w[Beginner Pre-intermediate Intermediate Upper-intermediate Advanced]
    if levels_enabled.include?(level.capitalize)
      @level = level
    else
      raise "Error: incorrect \"Level\". It has to be one of this options: Beginner, Pre-Intermediate, Intermediate, Upper-Intermediate and Advanced."
    end
  end

  def students_enrolled=(students)
    # students: an Array of Student objects
    raise 'Error: Nil value is not allowed for students_enrolled param.' if students.class == NilClass
    raise 'Error: empty value is not allowed for students_enrolled param.' if students.class == Array && students.empty?

    # check all students have the same attribute value that the course
    if same_course_attribute_value?(students, "mode") && same_course_attribute_value?(students, "level") && check_students_by_mode(students, self.mode)
      @students_enrolled = students
    else
      @students_enrolled = []
    end
  end

  def hour=(hour)
    # hour: a Integer that represent the clock hour. It has to be between 9 and 19
    hour = parse_hour(hour)
    @hour = hour
  end

  def day=(day)
    # day: represent a day of the week. it could be a word or a number.
    day = parse_day(day)
    @day = day
  end


  def schedule_class
    { day: day, hour: hour }
  end

  def check_students_by_mode(students, mode)
    if mode == :single && students.empty? == false
      # Only one student per teacher.
      if students.count != 1
        raise "Error: it was not possible to create a course for single mode, you must provide only one \"student\"."
      else
        return true
      end
    elsif mode == :group && students.empty? == false
      if students.count >= 1 && students.count <= 6
        true
      end
    else
      false
    end
  end

  private

  def same_course_attribute_value?(people, attribute)
    # they all have the same attribute value
    # people: a list of students or teachers
    # atrribute: name of the atrribut to test
    raise 'Error: Nil param is not allowed.' if people.class == NilClass || attribute.class == NilClass

    criteria = people.first.instance_variable_get('@'+attribute)
    people.each do |person|
      raise "Error: all \"Student\" have to have the same #{attribute} that the Course." if person.instance_variable_get('@'+attribute) != self.instance_variable_get('@'+attribute)
    end
    true
  end
end
