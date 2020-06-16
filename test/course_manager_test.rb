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

  it 'create a course with 0 student exact match one day' do
    student = Student.new("Milhouse Van Houten", "single", "Beginner", [["monday", 19]])
    teacher = Teacher.new("Miss Crabapel", [["monday", 21]])
    course = CourseManager.create_course(teacher, [student], :single)
    assert_nil(course)
  end

  it 'create a course with 2 student exact match one day' do
    students = []
    students << Student.new("Milhouse Van Houten", "group", "Beginner", [["monday", 19]])
    students << Student.new("Bart J. Simpson", "group", "Beginner", [["monday", 19]])
    teacher = Teacher.new("Miss Crabapel", [["monday", 19]])
    course = CourseManager.create_course(teacher, students, :group)

    puts "course "
    puts course.inspect
    expect(course.hour).must_equal 19
#    expect(course.day).must_equal :monday
#    expect(course.mode).must_equal :single
#    expect(course.teacher.name).must_equal "Miss Crabapel"
  end

  # test para probar el metodo.

end
