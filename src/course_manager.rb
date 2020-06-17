class CourseManager
  # def initialize(teacher=[], students=[])
  #   @teachers = teachers
  #   @students = students
  # end

  def self.create_course(teacher, students=[], mode)
    #puts "teacher: #{teacher.schedule[0][0]}"
    student_matches = draw_match(teacher, students)
   # puts "student_matches"
   # puts student_matches.inspect

    if mode == :single && student_matches.empty? == false
      # Only one student and only one teacher.
      if students.count != 1
        raise "Error: it was not possible to create a course for single mode, you must provide only one \"student\"."
      end
      # It should do the match with the first day
      return object_course = Course.new(teacher, students, teacher.schedule[0][0], teacher.schedule[0][1], :single)
    elsif student_matches.empty? == false
      # puts student_matches[0]
      return object_course = Course.new(teacher, students, teacher.schedule[0][0], teacher.schedule[0][1], :group)
    else
      raise "Error: it was not possible to create a course, there were no matches."
    end
  end

  def self.draw_match(teacher, students)
    choices = {} #hash with days, hours and a list of students availables for each day
    # person schedule must be sorted the data

    # for each availability of the teacher you must create a list of students with that availability
    teacher.schedule.each do |teacher_schedule|
      choices[teacher_schedule] = []
      students.each do |student|
        if student.schedule.include?(teacher_schedule)
          choices[teacher_schedule] << student.full_name
        end
      end
      choices.delete(teacher_schedule) if choices[teacher_schedule].empty? #delete the unuses key for empty students
    end
    return choices
  end
end
