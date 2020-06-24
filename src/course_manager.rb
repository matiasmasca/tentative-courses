class CourseManager

  def self.create_tentative_course(teachers_list=[], students_list=[])
    # Se tiene lista de estudiantes
    # Se tiene lista de docentes

    # Ordenar los estudiantes, por grupal e individual.
    students = sorted_by_mode(students_list)

    # Ordenar los estudiantes por nivel.
    students[:group] = sorted_by_level(students[:group])
    students[:single] = sorted_by_level(students[:single])

    # Ordenar los estudiantes por horario.
    tentative_courses = []

    teachers_list.each do |teacher|
      tentative_courses << {teacher.name => draw_match(teacher, students)}
    end

    # aca debería armar la lista de los que quedaron afuera.

    #  tiene que tener:
    # - Un docente.
    # - Un nivel.
    # - Un horario (día y hora)
    # - Una lista de inscriptos.

    # tentative courses... docente, estudiantes por horario, nivel y modo.
    tentative_courses
  end

  def self.create_course(teacher, students=[], mode)
    # puts "teacher: #{teacher.schedule[0][0]}"
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
      if students.count <= 6 && students.count > 0 && check_mode(students, "mode") && check_mode(students, "level")
        return object_course = Course.new(teacher, students, teacher.schedule[0][0], teacher.schedule[0][1], :group)
      else
        raise "Error: it was not possible to create a course for group mode, you must provide between 1 and 6 \"student\"."
      end
    else
      raise "Error: it was not possible to create a course, there were no matches."
    end
  end

  def self.check_mode(people, attribute)
    criteria = people.first.instance_variable_get('@'+attribute)
    people.each do |person|
      raise "Error: all \"person\" have to have the same #{attribute}." if person.instance_variable_get('@'+attribute) != criteria
    end
    true
  end

  def self.draw_match(teacher, students_by_mode)
    choices = {} #hash with days, hours and a list of students availables for each day
    # person schedule must be sorted the data

    # primero los grupales y despues los individuales...
    # {:group=>{"Beginner"=>[], "Pre-Intermediate"=>[], "Intermediate"=>[#<Student:0x0000564e56d4f6c0 @full_name="Adrian Droide", @mode="group", @level="Intermediate", @schedule=[[1, 19], [5, 19]]>, #<Student:0x0000564e56d4eb30 @full_name="José K. Lavera", @mode="group", @level="Intermediate", @schedule=[[1, 19], [5, 18]]>, #<Student:0x0000564e56d4de38 @full_name="Ines Queleto", @mode="group", @level="Intermediate", @schedule=[[1, 19], [5, 19]]>, #<Student:0x0000564e56d4d410 @full_name="Guillermo Nigote.", @mode="group", @level="Intermediate", @schedule=[[1, 19], [5, 18]]>], "Upper-Intermediate"=>[#<Student:0x0000564e56d4c9e8 @full_name="Oscar Arrota", @mode="group", @level="Upper-Intermediate", @schedule=[[1, 19], [5, 19]]>], "Advanced"=>[]}, :single=>[#<Student:0x0000564e56d4c088 @full_name="Federico N. Gelado", @mode="single", @level="Intermediate", @schedule=[[1, 14], [5, 14]]>]}

    # for each availability of the teacher you must create a list of students with that availability
    #  a.keys.each {|x| a[x].each {|y| puts y}}

    teacher.schedule.each do |teacher_schedule|
      choices[teacher_schedule] = {group: [], single:[]}
      students_by_mode.keys.each do |mode|
        students_by_mode[mode].keys.each do |level|
          students_by_mode[mode][level].each do |student|
            if mode == :single && student.schedule.include?(teacher_schedule) && student.mode == mode.to_s && choices[teacher_schedule][mode].include?(student.full_name) != false
              choices[teacher_schedule][mode] << student.full_name
            end

            if student.schedule.include?(teacher_schedule) && student.mode == mode.to_s && choices[teacher_schedule][mode].include?(student.full_name) == false
              choices[teacher_schedule][mode] << student.full_name
            end
          end
        end
      end

      choices.delete(teacher_schedule) if choices[teacher_schedule].empty? #delete the unuses key for empty students
    end
    return choices
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

end
