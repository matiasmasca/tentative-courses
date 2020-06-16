require 'minitest/autorun'
require '../code/teacher'

describe 'Teacher' do
  it 'has a schedule' do
    schedule = [["Monday",17]]
    teacher = Teacher.new("Miss Crabapel", schedule)

    expect(teacher.schedule[0][1]).must_equal 17
    expect(teacher.schedule).must_equal [[1, 17]]
  end

  it 'has a schedule' do
    schedule = [["monday",17],["wednesday",9],["thursday",20]]
    teacher = Teacher.new("Miss Crabapel", schedule)
    expect(teacher.schedule[0][1]).must_equal 17
  end

  it 'can add his availability for a day' do
    teacher = Teacher.new("Miss Crabapel")
    teacher.add_day("monday", 19)
    expect(teacher.schedule[0][1]).must_equal 19
  end

  it 'can add his availability for a day in two differents hours' do
    teacher = Teacher.new("Miss Crabapel")
    teacher.add_day("monday", 19)
    teacher.add_day("wednesday", 9)
    expect(teacher.schedule[1][1]).must_equal 9
    expect teacher.schedule.must_equal [[1, 19], [3, 9]]
  end

  it 'can add his availability for a day in two differents hours' do
    teacher = Teacher.new("Miss Crabapel")
    teacher.add_day("Lunes", 19)
    teacher.add_day("Martes", 9)
    expect(teacher.schedule[1][1]).must_equal 9
    expect teacher.schedule.must_equal [[1, 19], [2, 9]]
  end
end


