class CourseManager

  def self.create_tentative_course(teachers_list=[], students_list=[])
    # Receive a list of teacher and a list of students

    # Sort the students by mode: group or single.
    students = sorted_by_mode(students_list)

    # Sort the students by level.
    students[:group] = sorted_by_level(students[:group])
    students[:single] = sorted_by_level(students[:single])

    teachers_choices = {}
    students_out = []
    students_in = []

    # Match the teachers schedule with students schedule.
    teachers_list.each do |teacher|
      choices = draw_match(teacher, students)
      # which student was left without a course
      choices[1].each do |item|
        if students_in.include?(item.to_s) == false
          students_in << item
          students_out.delete(item.to_s)
        else
        end
      end

      # merge and clean the list of students without match schedule
      choices[0].each do |item|
        students_out << item if students_out.include?(item.to_s) == false && students_in.include?(item.to_s) == false
      end

      teachers_choices[teacher.full_name] = choices[2]
    end
    { out: students_out, in: students_in, choices: teachers_choices }

    # tentative courses... teachers, students by schedule, level and mode.
    tentative_courses = {}
    teachers_list.each do |teacher|
      teacher_options_by_schedule = teachers_choices[teacher.full_name]
      tentative_courses[teacher] = []
      teacher_options_by_schedule.each do |teacher_schedule|
        schedule = teacher_schedule[0]
        student_groups = teacher_schedule[1]
          #group
          student_groups[:group].keys.each do |level|
            sub_group = students_in_groups_of(student_groups[:group][level], 6)
            sub_group.each do |students|
              students_sub_group = []
              students.each do |student|
                students_sub_group << Student.find_student_by_name(students_list, student).first
              end
              level = students_sub_group.first.level # the first student level
              tentative_courses[teacher] << new_course(teacher, students_sub_group, schedule[0], schedule[1], :group, level)
            end
          end

          # single.
          student_groups[:single].each do |student_name|
            student = students_list.select { |student| student.full_name == student_name } # find the student object
            level = student.first.level
            tentative_courses[teacher] << new_course(teacher, student, schedule[0], schedule[1], :single, level)
          end
      end
    end
    return {tentative_courses: tentative_courses, students_out: students_out }
  end

  def self.new_course(teacher, students,day, hour, mode, level)
    if mode == :single && students.empty? == false
      # Only one student and only one teacher.
      if students.count != 1
        raise "Error: it was not possible to create a course for single mode, you must provide only one \"student\"."
      end
      return object_course = Course.new(teacher, :single, level, students, day, hour)
    end

    if mode == :group && students.empty? == false
      if students.count <= 6 && students.count > 0 && check_mode(students, "mode") && check_mode(students, "level")
        return object_course = Course.new(teacher, :group, level, students, day, hour)
      else
        raise "Error: it was not possible to create a course for group mode, you must provide between 1 and 6 \"student\"."
      end
    else
      raise "Error: it was not possible to create a course, there were no matches."
    end
  end

  def self.create_course(teacher, students=[], mode)
    # puts "teacher: #{teacher.schedule[0][0]}"
    # student_matches = draw_match(teacher, students)
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
      if students.count <= 6 && students.count > 0 && check_mode(students, "mode") && check_mode(students, "level")
        return object_course = Course.new(teacher, students, teacher.schedule[0][0], teacher.schedule[0][1], :group)
      else
        raise "Error: it was not possible to create a course for group mode, you must provide between 1 and 6 \"student\"."
      end
    else
      raise "Error: it was not possible to create a course, there were no matches."
    end
  end


  # draw_match: create a list of candidates for each teacher availability with mode and level.
  def self.draw_match(teacher, students_by_mode)
    choices = {} #hash with days, hours and a list of students availables for each day
    students_out = []
    students_in = []
    # person schedule must be sorted the data

    # for each availability of the teacher you must create a list of students with that availability
    teacher.schedule.each do |teacher_schedule|
      choices[teacher_schedule] = {group: {"Beginner"=>[], "Pre-Intermediate"=>[], "Intermediate"=>[], "Upper-Intermediate"=>[], "Advanced"=>[]}, single:[]}
      students_by_mode.keys.each do |mode|
        students_by_mode[mode].keys.each do |level|
          students_by_mode[mode][level].each do |student|
            if mode == :single && student.schedule.include?(teacher_schedule) && student.mode == mode.to_s && choices[teacher_schedule][mode].include?(student.full_name) == false
              choices[teacher_schedule][mode] << student.full_name
              students_in << student.full_name unless students_in.include?(student.full_name)
              next
            end

            if  mode == :group && student.schedule.include?(teacher_schedule) && student.mode == mode.to_s && choices[teacher_schedule][mode].include?(student.full_name) == false
              choices[teacher_schedule][mode][student.level] << student.full_name
              students_in << student.full_name unless students_in.include?(student.full_name)
              next
            end

            students_out << student.full_name unless students_out.include?(student.full_name)
          end
        end
      end
    end
    return [students_out, students_in, choices]
  end

  def self.students_in_groups_of(students_array, length)
    # students_array: an array of objects Student
    # number: amount of groups
    total_groups = (students_array.size.to_f/length).ceil.to_i

    groups = []
    start = 0

    total_groups.times do |index|
      groups << students_array.slice(start, length)
      start += length
    end

    return groups
  end

  def self.sorted_by_mode(students_list)
    students = { group: [], single:[] }
    students_list.each do |student|
      if student.mode == "single"
        students[:single] << student
      elsif student.mode == "group"
        students[:group] << student
      end
    end
    return students
  end

  def self.sorted_by_level(students_list)
    students_by_level = { "Beginner"=>[], "Pre-Intermediate"=>[], "Intermediate"=>[], "Upper-Intermediate"=>[], "Advanced"=>[] }
    students_list.each do |student|
      case student.level
      when "Beginner"
        students_by_level["Beginner"] << student
      when "Pre-Intermediate"
        students_by_level["Pre-Intermediate"] << student
      when "Intermediate"
        students_by_level["Intermediate"] << student
      when "Upper-Intermediate"
        students_by_level["Upper-Intermediate"] << student
      when "Advanced"
        students_by_level["Advanced"] << student
      else
        puts "Error \"Student Level\": unknown student level in #{student.inspect}"
      end
    end
    return students_by_level
  end

  def self.check_mode(people, attribute)
    criteria = people.first.instance_variable_get('@'+attribute)
    people.each do |person|
      raise "Error: all \"person\" have to have the same #{attribute}." if person.instance_variable_get('@'+attribute) != criteria
    end
    true
  end
end
