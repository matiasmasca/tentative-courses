require_relative 'schedule'

class CourseManager
  include Schedulable

  def self.create_tentative_course(teachers_list=[], students_list=[])
    # < Receive a list of teachers and a list of students in order to create courses >
    # < return: a hash with a list of tentatives courses (instances of Course) and a list of students name without course >
    # teachers_list: an array of instances of Teacher
    # students_list: an array of instances of Students

    # Sort the students by mode: group or single.
    students = sorted_by_mode(students_list)

    # Sort the students by level.
    students[:group] = sorted_by_level(students[:group])
    students[:single] = sorted_by_level(students[:single])

    # Match the teachers schedule with students schedule.
    # students must be sorted by mode and level
    matched_schedules  = match_schedule_teacher_students(teachers_list, students)
    teachers_choices = matched_schedules[:teachers_choices]
    students_out = matched_schedules[:students_out]

    # crate the tentative courses with teachers, students by: schedule, level and mode.
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

    return { tentative_courses: tentative_courses, students_out: students_out }
  end

  def self.match_schedule_teacher_students(teachers_list, students_list)
    # < Generate a list of alternatives with the matched schedules between a teacher a all the students >
    # < return: a hash with a list of tentatives courses per teacher and a list of students name without course; but don't create the courses >
    # teachers_list: an array of instances of Teacher
    # students_list: an hash of instances of Students ordered by course mode single or group and by their language level

    teachers_choices = {}
    students_out = []
    students_in = []

    teachers_list.each do |teacher|
      choices = draw_match(teacher, students_list)
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

    return { teachers_choices: teachers_choices, students_out: students_out }
  end

  def self.new_course(teacher, students,day, hour, mode, level)
    # < Create a new object Course >
    # teacher: an instance of the Teacher class
    # students: an array of instances of the Student class
    # day: an integer that represent the week day
    # hour: an integer that represent the start hour of the course
    # mode: a symbol that represent the mode of the course, :single or :group
    # level: a string that represent the level of the course

    return object_course = Course.new(teacher, mode, level, students, day, hour)
  end

  def self.draw_match(teacher, students_by_mode_and_level)
    # < create a list of candidates for a teacher availability with mode and level. >
    # teacher: an instance of Teacher
    # students_by_mode_and_level: an hash of instances of Students ordered by course mode single or group and by their language level

    choices = {} # hash with days, hours and a list of students availables for each day
    students_out = []
    students_in = []

    # for each availability of the teacher you must create a list of students with that availability
    teacher.schedule.each do |teacher_schedule|
      choices[teacher_schedule] = {group: {"Beginner"=>[], "Pre-Intermediate"=>[], "Intermediate"=>[], "Upper-Intermediate"=>[], "Advanced"=>[]}, single:[]}
      students_by_mode_and_level.keys.each do |mode|
        students_by_mode_and_level[mode].keys.each do |level|
          students_by_mode_and_level[mode][level].each do |student|
            if mode == :single && student.schedule.include?(teacher_schedule) && student.mode == mode && choices[teacher_schedule][mode].include?(student.full_name) == false
              choices[teacher_schedule][mode] << student.full_name
              students_in << student.full_name unless students_in.include?(student.full_name)
              next
            end
            if  mode == :group && student.schedule.include?(teacher_schedule) && student.mode == mode && choices[teacher_schedule][mode].include?(student.full_name) == false
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
    # < create group of students, in arrays, by the length param >
    # students_array: an array of objects Student
    # length: amount of groups

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
    # < Sort the list of students according to their mode single or group in a hash >
    # students_list: an array of instances of Student class

    students = { group: [], single:[] }
    students_list.each do |student|
      if student.mode == :single
        students[:single] << student
      elsif student.mode == :group
        students[:group] << student
      end
    end
    return students
  end

  def self.sorted_by_level(students_list_hash_by_mode)
    # < Sort the list of students according to their mode single or group in a hash >
    # students_list_hash_by_mode: a hash of instances of Student class ordered by mode single or group.

    students_by_level = { "Beginner"=>[], "Pre-Intermediate"=>[], "Intermediate"=>[], "Upper-Intermediate"=>[], "Advanced"=>[] }
    students_list_hash_by_mode.each do |student|
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
        raise "Error \"Student Level\": unknown student level in #{student.inspect}"
      end
    end
    return students_by_level
  end

  def self.check_mode(objects_array, attribute)
    # < Check if all the objects have the same value for the atrribute >
    # objects: an array of objects
    # attribute: name of the attribute to use as criteria for check the equality of the whole array items

    criteria = objects_array.first.instance_variable_get('@'+attribute)
    objects_array.each do |object|
      raise "Error: all \"objects\" in the array have to have the same #{attribute}." if object.instance_variable_get('@'+attribute) != criteria
    end
    true
  end
end
