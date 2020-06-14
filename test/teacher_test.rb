require 'minitest/autorun'
require '../code/teacher'

describe 'Teacher' do
  it 'has a schedule' do
    schedule = [["monday",17],["wednesday",9],["thursday",20]]
    object_teacher = Teacher.new("Milhouse Van Houten", schedule)
    expect(object_teacher.schedule[0][1]).must_equal 17
  end

  it 'can add his availability for a day' do
    object_teacher = Teacher.new("Milhouse Van Houten")
    object_teacher.add_day("monday", 19)
    expect(object_teacher.schedule[0][1]).must_equal 19
  end

  it 'can add his availability for a day in two differents hours' do
    object_teacher = Teacher.new("Milhouse Van Houten")
    object_teacher.add_day("monday", 19)
    object_teacher.add_day("monday", 9)
    expect(object_teacher.schedule[1][1]).must_equal 9
  end
end


