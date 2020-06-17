require 'minitest/autorun'
require '../code/course_manager'
require '../code/student'
require '../code/teacher'
require '../code/course'


describe 'CourseManager' do
  it 'create a course with 1 student exact match one day with the teacher' do
    student = Student.new("Milhouse Van Houten", "single", "Beginner", [["monday", 19]])
    teacher = Teacher.new("Miss Crabapel", [["monday", 19]])
    course = CourseManager.create_course(teacher, [student], :single)

    expect(course.hour).must_equal 19
    expect(course.day).must_equal 1
    expect(course.mode).must_equal :single
    expect(course.teacher.name).must_equal "Miss Crabapel"

    expect(course.students.count).must_equal 1
  end

  it 'create a course with 0 student exact match with one day' do
    student = Student.new("Milhouse Van Houten", "single", "Beginner", [["monday", 19]])
    teacher = Teacher.new("Miss Crabapel", [["monday", 21]])

    assert_raises RuntimeError do
      course = CourseManager.create_course(teacher, [student], :single)
    end
  end

  it 'create a course with 0 student exact match differents days' do
    student = Student.new("Milhouse Van Houten", "single", "Beginner", [["monday", 19]])
    teacher = Teacher.new("Miss Crabapel", [["friday", 21]])
    assert_raises RuntimeError do
      course = CourseManager.create_course(teacher, [student], :single)
    end
  end

  it 'create a course with 2 student exact match one day' do
    students = []
    students << Student.new("Milhouse Van Houten", "group", "Beginner", [["monday", 19]])
    students << Student.new("Bart J. Simpson", "group", "Beginner", [["monday", 19]])
    teacher = Teacher.new("Miss Crabapel", [["monday", 19]])
    course = CourseManager.create_course(teacher, students, :group)

    expect(course.hour).must_equal 19
    expect(course.day).must_equal 1
    expect(course.mode).must_equal :group
    expect(course.teacher.name).must_equal "Miss Crabapel"
    expect(course.students.count).must_equal 2
  end

  it 'create a single course with 2 student not is possible' do
    students = []
    students << Student.new("Milhouse Van Houten", "group", "Beginner", [["monday", 19]])
    students << Student.new("Bart J. Simpson", "group", "Beginner", [["monday", 19]])
    teacher = Teacher.new("Miss Crabapel", [["monday", 19]])
    assert_raises RuntimeError do
      course = CourseManager.create_course(teacher, students, :single)
    end
  end

  it 'create a group course with more than 6 student not is possible' do
    students = []
    students << Student.new("Milhouse Van Houten", "group", "Beginner", [["monday", 19]])
    students << Student.new("Bart J. Simpson", "group", "Beginner", [["monday", 19]])
    students << Student.new("Nelson Muntz", "group", "Beginner", [["monday", 19]])
    students << Student.new("Martin Prince.", "group", "Beginner", [["monday", 19]])
    students << Student.new("Wendell Borton", "group", "Beginner", [["monday", 19]])
    students << Student.new("Sophie Jensen", "group", "Beginner", [["monday", 19]])
    students << Student.new("Laurence Simmons", "group", "Beginner", [["monday", 19]])
    teacher = Teacher.new("Miss Crabapel", [["monday", 19]])
    assert_raises RuntimeError do
      course = CourseManager.create_course(teacher, students, :group)
    end
  end

  # Falta test para probar el metodo: draw_match

  # DONE * Los cursos tienen que respetar el horario que el docente tiene disponible.
  # DONE * Los cursos tienen que respetar el horario disponible de los estudiantes.
  # DONE * Los cursos individuales sólo pueden contener 1 inscripto.
  # * Los cursos grupales pueden contener hasta 6 inscriptos.
  # * Todos los inscriptos en el curso tienen que tener el mismo nivel.
  # * Todos los inscriptos tienen que la misma modalidad. Ej. Si un estudiante eligió modalidad individual no se los puede inscribir en curso grupal.

end
