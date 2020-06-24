require 'minitest/autorun'
require '../src/course_manager'
require '../src/student'
require '../src/teacher'
require '../src/course'

describe 'CourseManager' do
  # before do
  #   @student = Student.new("Milhouse Van Houten", "single", "Beginner", [["monday", 19]])
  #   @teacher = Teacher.new("Miss Crabapel", [["monday", 19]])
  # end

  # describe 'Sigle course' do
  #   it 'create a course with 1 student exact match one day with the teacher' do
  #     skip
  #     course = CourseManager.create_course(@teacher, [@student], :single)
  #     expect(course.hour).must_equal 19
  #     expect(course.day).must_equal 1
  #     expect(course.mode).must_equal :single
  #     expect(course.teacher.name).must_equal "Miss Crabapel"
  #     expect(course.students.count).must_equal 1
  #   end
  #   it 'create a course with 0 student exact match with one day' do
  #     skip
  #     # student = Student.new("Milhouse Van Houten", "single", "Beginner", [["monday", 19]])
  #     teacher = Teacher.new("Miss Crabapel", [["monday", 21]])

  #     assert_raises RuntimeError do
  #       course = CourseManager.create_course(teacher, [@student], :single)
  #     end
  #   end
  #   it 'create a course with 0 student exact match differents days' do
  #     skip
  #     # student = Student.new("Milhouse Van Houten", "single", "Beginner", [["monday", 19]])
  #     teacher = Teacher.new("Miss Crabapel", [["friday", 21]])
  #     assert_raises RuntimeError do
  #       course = CourseManager.create_course(teacher, [@student], :single)
  #     end
  #   end

  #   it 'create a single course with 2 student not is possible' do
  #     skip
  #     students = []
  #     students << Student.new("Milhouse Van Houten", "group", "Beginner", [["monday", 19]])
  #     students << Student.new("Bart J. Simpson", "group", "Beginner", [["monday", 19]])
  #     #teacher = Teacher.new("Miss Crabapel", [["monday", 19]])
  #     assert_raises RuntimeError do
  #       course = CourseManager.create_course(@teacher, students, :single)
  #     end
  # end

  # describe 'Groupal course' do
  #   it 'create a course with 2 student exact match one day' do
  #     skip
  #     students = []
  #     students << Student.new("Milhouse Van Houten", "group", "Beginner", [["monday", 19]])
  #     students << Student.new("Bart J. Simpson", "group", "Beginner", [["monday", 19]])
  #     #teacher = Teacher.new("Miss Crabapel", [["monday", 19]])
  #     course = CourseManager.create_course(@teacher, students, :group)

  #     expect(course.hour).must_equal 19
  #     expect(course.day).must_equal 1
  #     expect(course.mode).must_equal :group
  #     expect(course.teacher.name).must_equal "Miss Crabapel"
  #     expect(course.students.count).must_equal 2
  #   end


  #   end

  #   it 'create a group course with more than 6 student not is possible' do
  #     skip
  #     students = []
  #     students << Student.new("Milhouse Van Houten", "group", "Beginner", [["monday", 19]])
  #     students << Student.new("Bart J. Simpson", "group", "Beginner", [["monday", 19]])
  #     students << Student.new("Nelson Muntz", "group", "Beginner", [["monday", 19]])
  #     students << Student.new("Martin Prince.", "group", "Beginner", [["monday", 19]])
  #     students << Student.new("Wendell Borton", "group", "Beginner", [["monday", 19]])
  #     students << Student.new("Sophie Jensen", "group", "Beginner", [["monday", 19]])
  #     students << Student.new("Laurence Simmons", "group", "Beginner", [["monday", 19]])
  #     #teacher = Teacher.new("Miss Crabapel", [["monday", 19]])
  #     assert_raises RuntimeError do
  #       course = CourseManager.create_course(@teacher, students, :group)
  #     end
  #   end

  #   it 'create a group course with differents level for students not is possible' do
  #     skip
  #     students = []
  #     students << Student.new("Milhouse Van Houten", "group", "Beginner", [["monday", 19]])
  #     students << Student.new("Bart J. Simpson", "group", "Intermediate", [["monday", 19]])
  #     students << Student.new("Nelson Muntz", "group", "Beginner", [["monday", 19]])
  #     students << Student.new("Martin Prince.", "group", "Intermediate", [["monday", 19]])
  #     students << Student.new("Wendell Borton", "group", "Beginner", [["monday", 19]])
  #     students << Student.new("Sophie Jensen", "group", "Intermediate", [["monday", 19]])
  #     #teacher = Teacher.new("Miss Crabapel", [["monday", 19]])
  #     assert_raises RuntimeError do
  #       course = CourseManager.create_course(@teacher, students, :group)
  #     end
  #   end

    # it 'create a group course with differents mode for students not is possible' do
    #   skip
    #   students = []
    #   students << Student.new("Milhouse Van Houten", "single", "Intermediate", [["monday", 19]])
    #   students << Student.new("Bart J. Simpson", "group", "Intermediate", [["monday", 19]])
    #   students << Student.new("Nelson Muntz", "single", "Intermediate", [["monday", 19]])
    #   students << Student.new("Martin Prince.", "group", "Intermediate", [["monday", 19]])
    #   students << Student.new("Wendell Borton", "single", "Intermediate", [["monday", 19]])
    #   students << Student.new("Sophie Jensen", "group", "Intermediate", [["monday", 19]])
    #   #teacher = Teacher.new("Miss Crabapel", [["monday", 19]])
    #   assert_raises RuntimeError do
    #     course = CourseManager.create_course(@teacher, students, :group)
    #   end
    # end
  #end
  # Falta test para probar el metodo: draw_match

  # MVP
  # DONE * Los cursos tienen que respetar el horario que el docente tiene disponible.
  # DONE * Los cursos tienen que respetar el horario disponible de los estudiantes.
  # DONE * Los cursos individuales sólo pueden contener 1 inscripto.
  # DONE * Los cursos grupales pueden contener hasta 6 inscriptos.
  # DONE * Todos los inscriptos en el curso tienen que tener el mismo nivel.
  # DONE * Todos los inscriptos tienen que la misma modalidad. Ej. Si un estudiante eligió modalidad individual
  #        no se los puede inscribir en curso grupal.

  # Se desea que se obtener una lista de cursos posibles. El curso posible tiene que tener:
  # x- Un docente.
  # x- Un nivel.
  # - Un horario (día y hora)
  # - Una lista de inscriptos.


  # Bonus:

# x * Tener una lista de los estudiantes que no pudieron ser asignados porque no pudieron cumplir alguna de las condiciones.
# * Que al "agrupar el curso grupal" y hacer el match de horarios pueda matchear también los que difieren en 1 hora
#   o X horas configurable.
#   * Ejemplo:
#   * Jose Montoto es Beginner y uno de sus horarios diponibles es Jueves 15:00
#   * Elena Nito es Beginner y uno de sus horarios disponibles es Jueves 16:00
#   * Esteban Quito es Beginner y uno de sus horarios disponibles es Jueves 14:00
#   * Si configuro una diferencia máxima de 1 hora. Espero que se arme un curso tentativo para los 3 inscriptos
#     el Jueves a las 15:00 y marcar las inscripciones de Elena y Esteban que necesitan CONFIRMACION de hora.

end


describe 'TentativeCourses' do
  before do
    @teachers = []
    @teachers << Teacher.new("Drippy Dan", [["monday", 19],["friday", 19]])
    @teachers << Teacher.new("Frigid Bridget", [["monday", 17],["friday", 17]])
    @teachers << Teacher.new("Adam Bomb", [["monday", 19],["friday", 19]])
    @teachers << Teacher.new("Ali Gator", [["monday", 19],["friday", 19]])
    @teachers << Teacher.new("Windy Winston", [["monday", 19],["friday", 19]])

    @enrolled_students = []
    @enrolled_students << Student.new("Adrian Droide", "group", "Beginner", [["monday", 19],["friday", 19] ])
    @enrolled_students << Student.new("José K. Lavera", "group", "Intermediate", [["monday", 19],["friday", 18] ])
    @enrolled_students << Student.new("Ines Queleto", "group", "Intermediate", [["monday", 19],["friday", 19] ])
    @enrolled_students << Student.new("Guillermo Nigote.", "group", "Intermediate", [["monday", 19],["friday", 18] ])
    @enrolled_students << Student.new("Oscar Arrota", "single", "Upper-Intermediate", [["monday", 19],["friday", 19] ])
    @enrolled_students << Student.new("Federico N. Gelado", "single", "Intermediate", [["monday", 19],["friday", 19] ])
  end

  it 'has a tentative course for all students' do

    tentative_courses = CourseManager.create_tentative_course(@teachers, @enrolled_students)

    puts tentative_courses
  end
end
