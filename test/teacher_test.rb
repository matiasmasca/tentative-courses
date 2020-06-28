require 'minitest/autorun'
require '../src/teacher'

describe 'Teacher' do
  before do
    schedule = [["Monday",17]]
    @teacher = Teacher.new("Miss Crabapel Edna", schedule)
  end

  it 'has a schedule' do
    expect(@teacher.schedule[0][1]).must_equal 17
    expect(@teacher.schedule).must_equal [[1, 17]]
  end

  it 'can set a schedule' do
    schedule = [["Monday",17],["Wednesday",9],["Thursday",20]]
    @teacher.schedule = schedule
    expect(@teacher.schedule[2][1]).must_equal 20
  end

  it 'can add his availability for a day' do
    @teacher.add_day("Monday", 19)
    expect(@teacher.schedule[1][1]).must_equal 19
  end

  it 'can add his availability for a day in two differents hours' do
    @teacher.add_day("Monday", 19)
    @teacher.add_day("Wednesday", 9)
    expect(@teacher.schedule).must_equal [[1, 17], [1, 19], [3, 9]]
  end

  it 'can add his availability for a day in Spanish in two differents hours' do
    @teacher.add_day("Lunes", 19)
    @teacher.add_day("Martes", 9)
    expect(@teacher.schedule).must_equal [[1, 17], [1, 19], [2, 9]]
  end

  it 'can\' add his availability for the weekend' do
    err = assert_raises RuntimeError do
      @teacher.add_day("Saturday", 19)
    end
    assert_match /Error: day must be between Monday and Friday/, err.message
  end

  it 'can\'t add his availability for before 9 AM or after 7 PM' do
    err = assert_raises RuntimeError do
       @teacher.add_day("Monday", 8)
    end
    assert_match /Error: hour must be number between 9 and 19/, err.message

    err = assert_raises RuntimeError do
       @teacher.add_day("Monday", 20)
    end
    assert_match /Error: hour must be number between 9 and 19/, err.message
  end
end
