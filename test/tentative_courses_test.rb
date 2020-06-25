require 'minitest/autorun'
require '../src/course_manager'
require '../src/student'
require '../src/teacher'
require '../src/course'

describe 'TentativeCourses' do
  describe 'Single Course' do
    describe 'has to have' do
      before do
        @teacher = Teacher.new("Drippy Dan", [["Friday", 19]])
        @teachers = [ @teacher ]
        @enrolled_students = [ Student.new("Adrian Droide", "single", "Beginner", [["Friday", 19]]) ]
        @tentative_courses = CourseManager.create_tentative_course(@teachers, @enrolled_students)
      end
      it 'has a teacher' do
        course = @tentative_courses[:tentative_courses][@teacher].first
        expect(course.teacher).must_equal @teacher
      end

      it 'has a level' do
        course = @tentative_courses[:tentative_courses][@teacher].first
        expect(course.level).must_equal "Beginner"
      end
      it 'has a schedule class, with day and hour' do
        course = @tentative_courses[:tentative_courses][@teacher].first
        expect(course.schedule_class).must_equal ({day: 5, hour:19 })
      end
      it 'has a list of enrolled' do
        course = @tentative_courses[:tentative_courses][@teacher].first
        expect(course.students_enrolled).must_equal @enrolled_students
      end
    end

    describe 'Match Schedules between 1 teacher and 1 student' do
      it 'has a Teacher with schedule that exact match with one Student so it must purpose 1 Course' do
        @teachers = [ Teacher.new("Drippy Dan", [["Friday", 19]]) ]
        @enrolled_students = [ Student.new("Adrian Droide", "single", "Beginner", [["Friday", 19]]) ]

        tentative_courses = CourseManager.create_tentative_course(@teachers, @enrolled_students)
        teacher = @teachers.first

        expect(tentative_courses[:tentative_courses][teacher].first.class).must_equal Course
      end

      it 'has a Teacher with schedule of 2 days that match in 1 day with 1 Student so it must purpose 1 Course' do
        @teachers = [ Teacher.new("Drippy Dan", [["Monday", 19], ["Friday", 19]]) ]
        @enrolled_students = [ Student.new("Adrian Droide", "single", "Beginner", [["Friday", 19]]) ]

        tentative_courses = CourseManager.create_tentative_course(@teachers, @enrolled_students)
        teacher = @teachers.first

        expect(tentative_courses[:tentative_courses][teacher].first.class).must_equal Course
        expect(tentative_courses[:tentative_courses][teacher].first.day).must_equal 5
        expect(tentative_courses[:tentative_courses][teacher].first.hour).must_equal 19
      end

      it 'has a Teacher with schedule that match in 2 days with 1 Student so it must purpose 2 possible courses' do
        @teachers = [ Teacher.new("Drippy Dan", [["Monday", 17], ["Friday", 19]]) ]
        @enrolled_students = [ Student.new("Adrian Droide", "single", "Beginner", [["Monday", 17],["Friday", 19]]) ]

        tentative_courses = CourseManager.create_tentative_course(@teachers, @enrolled_students)
        teacher = @teachers.first

        expect(tentative_courses[:tentative_courses][teacher].count).must_equal 2

        expect(tentative_courses[:tentative_courses][teacher].first.class).must_equal Course
        expect(tentative_courses[:tentative_courses][teacher].first.day).must_equal 1
        expect(tentative_courses[:tentative_courses][teacher].first.hour).must_equal 17

        expect(tentative_courses[:tentative_courses][teacher].last.class).must_equal Course
        expect(tentative_courses[:tentative_courses][teacher].last.day).must_equal 5
        expect(tentative_courses[:tentative_courses][teacher].last.hour).must_equal 19
      end

      it 'has a Teacher with schedule of 3 days that match in 2 days with 1 Student so it must purpose 2 possible courses' do
        @teachers = [ Teacher.new("Drippy Dan", [["Monday", 17],["tuesday", 17], ["Friday", 19]]) ]
        @enrolled_students = [ Student.new("Adrian Droide", "single", "Beginner", [["Monday", 17],["Friday", 19]]) ]

        tentative_courses = CourseManager.create_tentative_course(@teachers, @enrolled_students)
        teacher = @teachers.first

        expect(tentative_courses[:tentative_courses][teacher].count).must_equal 2

        expect(tentative_courses[:tentative_courses][teacher].first.class).must_equal Course
        expect(tentative_courses[:tentative_courses][teacher].first.day).must_equal 1
        expect(tentative_courses[:tentative_courses][teacher].first.hour).must_equal 17

        expect(tentative_courses[:tentative_courses][teacher].last.class).must_equal Course
        expect(tentative_courses[:tentative_courses][teacher].last.day).must_equal 5
        expect(tentative_courses[:tentative_courses][teacher].last.hour).must_equal 19
      end

      it 'has a Teacher doesn\'t match with the Student so it not purpose any course and add the student to the \"student_out\" list' do
        @teachers = [ Teacher.new("Drippy Dan", [["Monday", 17],["tuesday", 17], ["Friday", 19]]) ]
        @enrolled_students = [ Student.new("Adrian Droide", "single", "Beginner", [["Monday", 7],["Friday", 9]]) ]

        tentative_courses = CourseManager.create_tentative_course(@teachers, @enrolled_students)
        expect(tentative_courses[:students_out].first).must_equal "Adrian Droide"
      end
    end

    it 'has only 1 student enrolled if it has single mode' do
      @teachers = [ Teacher.new("Drippy Dan", [["Friday", 19]]) ]
      @enrolled_students = []
      @enrolled_students << Student.new("Adrian Droide", "single", "Beginner", [["Friday", 19]])
      @enrolled_students << Student.new("Martin P Gado", "single", "Beginner", [["Friday", 19]])

      tentative_courses = CourseManager.create_tentative_course(@teachers, @enrolled_students)
      teacher = @teachers.first

      expect(tentative_courses[:tentative_courses][teacher].first.students_enrolled.count).must_equal 1
    end

  end

  describe 'Group Course' do
    before do
      @teachers = []
      @teachers << Teacher.new("Frigid Bridget", [["Monday", 19],["Friday", 17]])

      @enrolled_students = []
      @enrolled_students << Student.new("José K. Lavera", "group", "Intermediate", [["Monday", 19]])
      @enrolled_students << Student.new("Ines Queleto", "group", "Intermediate", [["Monday", 19]])
      @enrolled_students << Student.new("Guillermo Nigote.", "group", "Intermediate", [["Monday", 19]])
      @enrolled_students << Student.new("Oscar Arrota", "group", "Intermediate", [["Monday", 19]])
      @enrolled_students << Student.new("Federico N. Gelado", "group", "Intermediate", [["Monday", 19]])
      @enrolled_students << Student.new("Ines Talactita", "group", "Intermediate", [["Monday", 19]])
    end

    it 'must has all enrolled students in the same level' do
      tentative_courses = CourseManager.create_tentative_course(@teachers, @enrolled_students)
      teacher = @teachers.first

      students_enrolled = tentative_courses[:tentative_courses][teacher].first.students_enrolled
      level = students_enrolled.first.level
      expect(students_enrolled.select { |student| student.level != level }).must_equal []
    end

    it 'must has all enrolled students in the same mode' do
      tentative_courses = CourseManager.create_tentative_course(@teachers, @enrolled_students)
      teacher = @teachers.first

      students_enrolled = tentative_courses[:tentative_courses][teacher].first.students_enrolled
      mode = students_enrolled.first.mode
      expect(students_enrolled.select { |student| student.mode != mode }).must_equal []
    end

    it 'can have a maximum of 6 students enrolled' do
      @enrolled_students << Student.new("Agustin Flador", "group", "Intermediate", [["Monday", 19]])
      @enrolled_students << Student.new("Martin P Gado" , "group", "Intermediate", [["Monday", 19]])

      tentative_courses = CourseManager.create_tentative_course(@teachers, @enrolled_students)
      teacher = @teachers.first

      students_enrolled_count = tentative_courses[:tentative_courses][teacher].first.students_enrolled.count
      expect(students_enrolled_count).must_equal 6
    end

    it 'has 10 enrolled students so create 2 tentative courses' do
      @enrolled_students << Student.new("Agustin Flador", "group", "Intermediate", [["Monday", 19]])
      @enrolled_students << Student.new("Martin P Gado" , "group", "Intermediate", [["Monday", 19]])
      @enrolled_students << Student.new("Juanca Nario"  , "group", "Intermediate", [["Monday", 19]])
      @enrolled_students << Student.new("Matias Tronauta", "group", "Intermediate", [["Monday", 19]])

      tentative_courses = CourseManager.create_tentative_course(@teachers, @enrolled_students)
      teacher = @teachers.first

      expect(tentative_courses[:tentative_courses][teacher].count).must_equal 2
    end

    it 'has 10 enrolled students so create 2 tentative courses in different days' do
      @enrolled_students << Student.new("Agustin Flador", "group", "Intermediate", [["Friday", 17]])
      @enrolled_students << Student.new("Martin P Gado" , "group", "Intermediate", [["Friday", 17]])
      @enrolled_students << Student.new("Juanca Nario"  , "group", "Intermediate", [["Friday", 17]])
      @enrolled_students << Student.new("Matias Tronauta", "group", "Intermediate", [["Friday", 17]])

      tentative_courses = CourseManager.create_tentative_course(@teachers, @enrolled_students)
      teacher = @teachers.first

      expect(tentative_courses[:tentative_courses][teacher].count).must_equal 2

      expect(tentative_courses[:tentative_courses][teacher].first.day).must_equal 1
      expect(tentative_courses[:tentative_courses][teacher].first.hour).must_equal 19

      expect(tentative_courses[:tentative_courses][teacher].last.day).must_equal 5
      expect(tentative_courses[:tentative_courses][teacher].last.hour).must_equal 17
    end

    it 'has a Teacher without match with any Student' do
      @another_enrolled_students = []
      @another_enrolled_students << Student.new("Agustin Flador", "group", "Intermediate", [["Friday", 9]])
      @another_enrolled_students << Student.new("Martin P Gado" , "group", "Intermediate", [["Friday", 10]])
      @another_enrolled_students << Student.new("Juanca Nario"  , "group", "Intermediate", [["Friday", 11]])
      @another_enrolled_students << Student.new("Matias Tronauta", "group", "Intermediate", [["Friday", 12]])

      tentative_courses = CourseManager.create_tentative_course(@teachers, @another_enrolled_students)

      expect(tentative_courses[:students_out].count).must_equal 4
    end
  end

  describe 'Multiple Teachers and Students' do
    before do
      @teacher_one = Teacher.new("Drippy Dan", [["Monday", 19],["Friday", 17]])
      @teacher_two = Teacher.new("Frigid Bridget", [["Thursday", 19],["Friday", 17]])
      @teacher_three = Teacher.new("Adam Bomb", [["Monday", 19],["Friday", 17]])
      @teacher_four = Teacher.new("Ali Gator", [["Monday", 19],["Friday", 17]])
      @teacher_five = Teacher.new("Windy Winston", [["Monday", 19],["Friday", 9]])
      @teachers = [ @teacher_one, @teacher_two, @teacher_three, @teacher_four, @teacher_five ]

      @enrolled_student_one = Student.new("Adrian Droide", "single", "Beginner", [["Monday", 19],["Friday", 17]])
      @enrolled_student_two = Student.new("José K. Lavera", "group", "Intermediate", [["Monday", 19]])
      @enrolled_student_three = Student.new("Ines Queleto", "group", "Intermediate", [["Monday", 19]])
      @enrolled_student_four = Student.new("Guillermo Nigote.", "group", "Intermediate", [["Monday", 19]])
      @enrolled_student_five = Student.new("Oscar Arrota", "group", "Intermediate", [["Monday", 19]])
      @enrolled_student_six = Student.new("Federico N. Gelado", "group", "Intermediate", [["Thursday", 19],["Thursday", 18]])
      @enrolled_student_seven = Student.new("Ines Talactita", "group", "Intermediate", [["Thursday", 19], ["Thursday", 18]])
      @enrolled_student_eight = Student.new("Agustin Flador", "group", "Intermediate", [["Monday", 19]])
      @enrolled_student_nine = Student.new("Martin P Gado", "group", "Intermediate", [["Monday", 19]])
      @enrolled_student_ten = Student.new("Juanca Nario", "group", "Pre-Intermediate", [["Monday", 19],["Friday", 1] ])
      @enrolled_student_eleven = Student.new("Matias Tronauta", "group", "Advanced", [["Monday", 19],["Friday", 9] ])
      @enrolled_student_twelve = Student.new("Carlos A. Fuera", "single", "Advanced", [["Wednesday", 10],["Friday", 14]])
      @enrolled_student_thirteen = Student.new("Stefi Ebre", "group", "Advanced", [["Monday", 9], ["Tuesday", 9], ["Wednesday", 9], ["Thursday", 9], ["Friday", 9], ["Saturday", 9]])

      @enrolled_students = [@enrolled_student_one, @enrolled_student_two, @enrolled_student_three, @enrolled_student_four, @enrolled_student_five, @enrolled_student_six, @enrolled_student_seven, @enrolled_student_eight, @enrolled_student_nine, @enrolled_student_ten, @enrolled_student_eleven, @enrolled_student_twelve, @enrolled_student_thirteen]
    end

    it 'has a tentative course for all students but one' do
      draw_match_result = CourseManager.create_tentative_course(@teachers, @enrolled_students)

      expect(draw_match_result[:tentative_courses][@teacher_one].count).must_equal 5 # five possibilities for teacher_one
      expect(draw_match_result[:tentative_courses].count).must_equal 5 # Teachers
      expect(draw_match_result[:students_out].count).must_equal 1 # Students out "Carlos A. Fuera"
    end
  end
end
