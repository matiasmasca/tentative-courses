require 'minitest/autorun'
require '../src/course'
require '../src/student'
require '../src/teacher'

# schedule_class
# check_students_by_mode

describe 'Course' do
  describe 'Sigle course' do
    describe 'a course has to have' do
      before do
        @teacher = Teacher.new("Drippy Dan", [["Friday", 19]])
        @student = Student.new("Adrian Droide", :single, "Beginner", [["Friday", 19]])
        @enrolled_students = [ @student ]
      end

      it 'a teacher' do
        course = Course.new(@teacher, :single, "Beginner", @enrolled_students, 1, 9)
        expect(course.teacher).must_equal @teacher
      end

      it 'a level' do
        course = Course.new(@teacher, :single, "Beginner", @enrolled_students, 1, 9)
        expect(course.level).must_equal "Beginner"
      end
      it 'a schedule class, with day and hour' do
        course = Course.new(@teacher, :single, "Beginner", @enrolled_students, 1, 9)
        expect(course.schedule_class).must_equal ({day: 1, hour: 9 })
      end
      it 'a list of enrolled' do
        course = Course.new(@teacher, :single, "Beginner", @enrolled_students, 1, 9)
        expect(course.students_enrolled).must_equal @enrolled_students
      end

      describe 'correct parameters' do
        describe 'course level has to be one of this options: Beginner, Pre-Intermediate, Intermediate, Upper-Intermediate and Advanced' do
          it 'is correct course level' do
            course = Course.new(@teacher, :single, "Beginner", @enrolled_students, 1, 9)
            expect(course.level).must_equal "Beginner"
          end

          it 'is correct course level' do
            course = Course.new(@teacher, :single, "Beginner", @enrolled_students, 1, 9)
            expect(course.level).must_equal "Beginner"
          end

          it 'is incorrect course level' do
            err = assert_raises RuntimeError do
              course = Course.new(@teacher, :single, "Super Saiyajin", @enrolled_students, 1, 9)
            end
            assert_match /Error: incorrect \"Level\". It has to be one of this options: Beginner, Pre-Intermediate, Intermediate, Upper-Intermediate and Advanced./, err.message
          end

          it 'a teacher has to be an instance of the class Teacher' do
            course = Course.new(@teacher, :single, "Beginner", @enrolled_students, 1, 9)
            expect(course.teacher.class).must_equal Teacher
          end

          it 'a student has to be an instance of the class Student' do
            course = Course.new(@teacher, :single, "Beginner", @enrolled_students, 1, 9)
            expect(course.students_enrolled.first.class).must_equal Student
          end
        end

        describe 'course mode has to be a symbol, like :single or :group' do
          it 'Single for individual course' do
            course = Course.new(@teacher, :single, "Beginner", @enrolled_students, 1, 9)
            expect(course.mode).must_equal :single
          end

          it 'Group for multi-students course' do
            enrolled_students = []
            enrolled_students << Student.new("Milhouse Van Houten", :group, "Beginner", [["Monday", 19]])
            course = Course.new(@teacher, :group, "Beginner", enrolled_students, 1, 9)
            expect(course.mode).must_equal :group
          end

          it 'bad mode: :individual' do
            err = assert_raises RuntimeError do
              course = Course.new(@teacher, :individual, "Beginner", @enrolled_students, 1, 9)
            end
            assert_match /Error: mode is not a valid option. It has to be :single or :group./, err.message
          end

          it 'not symbol \"single\"' do
            err = assert_raises RuntimeError do
              course = Course.new(@teacher, "single", "Beginner", @enrolled_students, 1, 9)
            end
            assert_match /Error: mode is not a Symbol./, err.message
          end
        end
      end
    end

    before do
      @student = Student.new("Milhouse Van Houten", :single, "Beginner", [["Monday", 19]])
      @teacher = Teacher.new("Miss Crabapel", [["Monday", 19]])
    end

    it 'create a course with 1 student exact match one day with the teacher' do
      course = Course.new(@teacher, :single, "Beginner", [ @student ], 1, 9)
      expect(course.hour).must_equal 9
      expect(course.day).must_equal 1
      expect(course.mode).must_equal :single
      expect(course.teacher.full_name).must_equal "Miss Crabapel"
      expect(course.students_enrolled.count).must_equal 1
    end

    it 'can\'t create a single course with 2 student' do
      students = [ ]
      students << @student
      students << Student.new("Bart J. Simpson", :single, "Beginner", [["Monday", 19]])
      err = assert_raises RuntimeError do
        course = Course.new(@teacher, :single, "Beginner", students, 1, 9)
      end
      assert_match /Error: it was not possible to create a course for single mode, you must provide only one \"student\"./, err.message
    end
  end

  describe 'Schedule course' do
    before do
      @student = Student.new("Milhouse Van Houten", :single, "Beginner")
      @teacher = Teacher.new("Miss Crabapel")
    end

    describe 'can\'t add his schedule for the weekend' do
      it 'can\'t be on Saturday ' do
        err = assert_raises RuntimeError do
          course = Course.new(@teacher, :single, "Beginner", [ @student ], 6, 9) # Saturday
        end
        assert_match /Error: day must be between Monday and Friday/, err.message
      end

      it 'can\'t be on Sunday' do
        err = assert_raises RuntimeError do
          course = Course.new(@teacher, :single, "Beginner", [ @student ], 7, 9) # Sunday
        end
        assert_match /Error: day must be between Monday and Friday/, err.message
      end
    end

    describe 'can\'t add his availability for before 9 AM or after 7 PM' do
      it 'can\'t be before 9 AM' do
        err = assert_raises RuntimeError do
          course = Course.new(@teacher, :single, "Beginner", [ @student ], 1, 8)
        end
        assert_match /Error: hour must be number between 9 and 19/, err.message
     end

      it 'can\'t be after 7 PM' do
        err = assert_raises RuntimeError do
          course = Course.new(@teacher, :single, "Beginner", [ @student ], 1, 20)
        end
        assert_match /Error: hour must be number between 9 and 19/, err.message
      end
    end
  end

  describe 'Group course' do
    before do
      @teacher = Teacher.new("Miss Crabapel", [["Monday", 19]])
    end

    it 'Group for multi-students course' do
      enrolled_students = []
      enrolled_students << Student.new("Milhouse Van Houten", :group, "Pre-Intermediate", [["Monday", 19]])
      enrolled_students << Student.new("Bart J. Simpson", :group, "Pre-Intermediate", [["Monday", 19]])
      course = Course.new(@teacher, :group, "Pre-Intermediate", enrolled_students, 1, 9)
      expect(course.mode).must_equal :group
    end

    it 'can\'t create a group course with students with differents inscription mode' do
      enrolled_students = []
      enrolled_students << Student.new("Milhouse Van Houten", :group, "Beginner", [["Monday", 19]])
      enrolled_students << Student.new("Bart J. Simpson", :single, "Beginner", [["Monday", 19]])

      err = assert_raises RuntimeError do
        Course.new(@teacher, :group, "Beginner", enrolled_students, 1, 9)
      end
      assert_match /Error: all \"Student\" have to have the same mode./, err.message
    end

    it 'can\'t create with students with differents inscription levels' do
      enrolled_students = []
      enrolled_students << Student.new("Milhouse Van Houten", :group, "Beginner", [["Monday", 19]])
      enrolled_students << Student.new("Bart J. Simpson", :group, "Advanced", [["Monday", 19]])

      err = assert_raises RuntimeError do
        Course.new(@teacher, :group, "Beginner", enrolled_students, 1, 9)
      end
      assert_match /Error: all \"Student\" have to have the same level that the Course./, err.message
    end

    it 'can\'t create a course with differents level that the students inscription levels' do
      enrolled_students = []
      enrolled_students << Student.new("Milhouse Van Houten", :group, "Advanced", [["Monday", 19]])
      enrolled_students << Student.new("Bart J. Simpson", :group, "Advanced", [["Monday", 19]])

      err = assert_raises RuntimeError do
        Course.new(@teacher, :group, "Beginner", enrolled_students, 1, 9)
      end
      assert_match /Error: all \"Student\" have to have the same level that the Course./, err.message
    end

    describe 'Error: without Students' do
      before do
        @teacher = Teacher.new("Miss Crabapel", [["Monday", 19]])
      end

      it 'can\'t create a course without students' do
        enrolled_students = nil
        err = assert_raises RuntimeError do
          Course.new(@teacher, :group, "Beginner", enrolled_students, 1, 9)
        end
        assert_match /Error: Nil value is not allowed for students_enrolled param./, err.message
      end

      it 'can\'t create a course an empty list of students' do
        enrolled_students = []
        err = assert_raises RuntimeError do
          Course.new(@teacher, :group, "Beginner", enrolled_students, 1, 9)
        end
        assert_match /Error: empty value is not allowed for students_enrolled param./, err.message
      end
    end

    describe 'Error: without Teacher' do
      before do
        @enrolled_students = []
        @enrolled_students << Student.new("Milhouse Van Houten", :group, "Advanced", [["Friday", 19]])
        @enrolled_students << Student.new("Bart J. Simpson", :group, "Advanced", [["Friday", 19]])
      end

      it 'can\'t create a course without a Teacher' do
        teacher = nil

        err = assert_raises RuntimeError do
          Course.new(teacher, :group, "Advanced", @enrolled_students, 1, 9)
        end
        assert_match /Error: Nil value is not allowed for Teacher param./, err.message
      end

      it 'can\'t create a course an empty Teacher param' do
        teacher = []

        err = assert_raises RuntimeError do
          Course.new(teacher, :group, "Advanced", @enrolled_students, 1, 9)
        end
        assert_match /Error: empty value is not allowed for Teacher param./, err.message
      end
    end

  end
end
