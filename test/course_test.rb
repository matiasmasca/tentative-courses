require 'minitest/autorun'
require '../src/course'
require '../src/student'
require '../src/teacher'


describe 'Course' do
  # teacher, mode, level, students=[], day, hour

  describe 'Sigle course' do
    before do
      @student = Student.new("Milhouse Van Houten", "single", "Beginner", [["Monday", 19]])
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

  end

  it '1 hour of class' do
    skip
  end

  it 'monday to friday'
end
