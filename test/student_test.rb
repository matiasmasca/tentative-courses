require 'minitest/autorun'
require '../code/student'

describe 'Student' do
  it 'has a name and a surname' do
    student = Student.new("Milhouse Van Houten", "single", "Beginner")
    expect(student.full_name).must_equal "Milhouse Van Houten"
  end

  it 'has a class mode' do
    student = Student.new("Milhouse Van Houten", "group", "Beginner")
    expect(student.mode).must_equal "group"
  end

  it 'has a class level' do
    student = Student.new("Milhouse Van Houten", "group", "Beginner")
    expect(student.level).must_equal "Beginner"
  end

  it 'has a schedule of class' do
    schedule = [["monday",17]]
    student = Student.new("Milhouse Van Houten", "group", "Beginner", schedule)
    expect(student.schedule).must_equal [[1, 17]]
    #expect(student.schedule).must_be_empty
  end

  it 'has not a schedule of class' do
    student = Student.new("Milhouse Van Houten", "group", "Beginner")
    expect(student.schedule).must_be_empty
  end

  it 'has a schedule of class' do
    schedule = [["monday",17],["wednesday",9],["thursday",20]]
    student = Student.new("Milhouse Van Houten", "group", "Beginner", schedule)
    expect(student.schedule[0][1]).must_equal 17
  end

  it 'can add his availability for a day' do
    student = Student.new("Milhouse Van Houten", "group", "Beginner")
    student.add_day("monday", 19)
    expect(student.schedule[0][1]).must_equal 19
  end

  it 'can add his availability for a day in two differents hours' do
    student = Student.new("Milhouse Van Houten", "group", "Beginner")
    student.add_day("monday", 19)
    student.add_day("wednesday", 9)
    student.add_day("thursday", 15)
    expect(student.schedule[1][1]).must_equal 9
  end
end
