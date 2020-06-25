require 'minitest/autorun'
require '../src/course_manager'
require '../src/student'
require '../src/teacher'
require '../src/course'

describe 'CourseManager' do
  before do
    @student = Student.new("Milhouse Van Houten", "single", "Beginner", [["Monday", 19]])
    @teacher = Teacher.new("Miss Crabapel", [["Monday", 19]])
  end

  describe 'Sigle course' do

    it 'create a course with 0 student exact match with one day' do
      skip
      # student = Student.new("Milhouse Van Houten", "single", "Beginner", [["Monday", 19]])
      teacher = Teacher.new("Miss Crabapel", [["Monday", 21]])

      assert_raises RuntimeError do
        course = CourseManager.create_course(teacher, [@student], :single)
      end
    end

    it 'create a course with 0 student exact match differents days' do
      skip
      # student = Student.new("Milhouse Van Houten", "single", "Beginner", [["Monday", 19]])
      teacher = Teacher.new("Miss Crabapel", [["Friday", 21]])
      assert_raises RuntimeError do
        course = CourseManager.create_course(teacher, [@student], :single)
      end
    end

    it 'create a single course with 2 student not is possible' do
      skip
      students = []
      students << Student.new("Milhouse Van Houten", "group", "Beginner", [["Monday", 19]])
      students << Student.new("Bart J. Simpson", "group", "Beginner", [["Monday", 19]])
      #teacher = Teacher.new("Miss Crabapel", [["Monday", 19]])
      assert_raises RuntimeError do
        course = CourseManager.create_course(@teacher, students, :single)
      end
  end

  describe 'Groupal course' do
    it 'create a course with 2 student exact match one day' do
      skip
      students = []
      students << Student.new("Milhouse Van Houten", "group", "Beginner", [["Monday", 19]])
      students << Student.new("Bart J. Simpson", "group", "Beginner", [["Monday", 19]])
      #teacher = Teacher.new("Miss Crabapel", [["Monday", 19]])
      course = CourseManager.create_course(@teacher, students, :group)

      expect(course.hour).must_equal 19
      expect(course.day).must_equal 1
      expect(course.mode).must_equal :group
      expect(course.teacher.name).must_equal "Miss Crabapel"
      expect(course.students.count).must_equal 2
    end


    end

    it 'create a group course with more than 6 student not is possible' do
      skip
      students = []
      students << Student.new("Milhouse Van Houten", "group", "Beginner", [["Monday", 19]])
      students << Student.new("Bart J. Simpson", "group", "Beginner", [["Monday", 19]])
      students << Student.new("Nelson Muntz", "group", "Beginner", [["Monday", 19]])
      students << Student.new("Martin Prince.", "group", "Beginner", [["Monday", 19]])
      students << Student.new("Wendell Borton", "group", "Beginner", [["Monday", 19]])
      students << Student.new("Sophie Jensen", "group", "Beginner", [["Monday", 19]])
      students << Student.new("Laurence Simmons", "group", "Beginner", [["Monday", 19]])
      #teacher = Teacher.new("Miss Crabapel", [["Monday", 19]])
      assert_raises RuntimeError do
        course = CourseManager.create_course(@teacher, students, :group)
      end
    end

    it 'create a group course with differents level for students not is possible' do
      skip
      students = []
      students << Student.new("Milhouse Van Houten", "group", "Beginner", [["Monday", 19]])
      students << Student.new("Bart J. Simpson", "group", "Intermediate", [["Monday", 19]])
      students << Student.new("Nelson Muntz", "group", "Beginner", [["Monday", 19]])
      students << Student.new("Martin Prince.", "group", "Intermediate", [["Monday", 19]])
      students << Student.new("Wendell Borton", "group", "Beginner", [["Monday", 19]])
      students << Student.new("Sophie Jensen", "group", "Intermediate", [["Monday", 19]])
      #teacher = Teacher.new("Miss Crabapel", [["Monday", 19]])
      assert_raises RuntimeError do
        course = CourseManager.create_course(@teacher, students, :group)
      end
    end

    it 'create a group course with differents mode for students not is possible' do
      skip
      students = []
      students << Student.new("Milhouse Van Houten", "single", "Intermediate", [["Monday", 19]])
      students << Student.new("Bart J. Simpson", "group", "Intermediate", [["Monday", 19]])
      students << Student.new("Nelson Muntz", "single", "Intermediate", [["Monday", 19]])
      students << Student.new("Martin Prince.", "group", "Intermediate", [["Monday", 19]])
      students << Student.new("Wendell Borton", "single", "Intermediate", [["Monday", 19]])
      students << Student.new("Sophie Jensen", "group", "Intermediate", [["Monday", 19]])
      #teacher = Teacher.new("Miss Crabapel", [["Monday", 19]])
      assert_raises RuntimeError do
        course = CourseManager.create_course(@teacher, students, :group)
      end
    end
  end
  # Falta test para probar el metodo: draw_match

  # MVP
  # DONE * Los cursos tienen que respetar el horario que el docente tiene disponible.
  # DONE * Los cursos tienen que respetar el horario disponible de los estudiantes.
  # DONE * Los cursos individuales sólo pueden contener 1 inscripto.
  # DONE * Los cursos grupales pueden contener hasta 6 inscriptos.
  # DONE * Todos los inscriptos en el curso tienen que tener el mismo nivel.
  # DONE * Todos los inscriptos tienen que la misma modalidad. Ej. Si un estudiante eligió modalidad individual
  #        no se los puede inscribir en curso grupal.


end
