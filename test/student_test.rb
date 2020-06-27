require 'minitest/autorun'
require '../src/student'

describe 'Student' do
  before do
    @student = Student.new("Milhouse Van Houten", :group, "Beginner") #without schedule
  end

  it 'has a name and a surname' do
    expect(@student.full_name).must_equal "Milhouse Van Houten"
  end

  it 'has a class mode' do
    expect(@student.mode).must_equal :group
  end

  it 'has a class level' do
    expect(@student.level).must_equal "Beginner"
  end

  it 'has a schedule of class' do
    schedule = [["Monday",17]]
    student = Student.new("Milhouse Van Houten", :group, "Beginner", schedule)
    expect(student.schedule).must_equal [[1, 17]]
  end

  it 'has not a schedule of class' do
    expect(@student.schedule).must_be_empty
  end

  it 'has a schedule of class' do
    schedule = [["Monday",17],["Wednesday",9],["Thursday",19]]
    student2 = Student.new("Milhouse Van Houten", :group, "Beginner", schedule)
    expect(student2.schedule[0][1]).must_equal 17
  end

  it 'can add his availability for a day' do
    @student.add_day("Monday", 19)
    expect(@student.schedule[0][1]).must_equal 19
  end

  it 'can add his availability for a day in two differents hours' do
    @student.add_day("Monday", 19)
    @student.add_day("Wednesday", 9)
    @student.add_day("Thursday", 15)
    expect(@student.schedule[1][1]).must_equal 9
  end

  it 'can\'t add his availability for the weekend' do
    assert_raises RuntimeError do
      @student.add_day("Saturday", 9)
    end

    assert_raises RuntimeError do
      @student.add_day("Sunday", 9)
    end
  end

  it 'can\'t add his availability for before 9 AM or after 7 PM' do
    assert_raises RuntimeError do
      @student.add_day("Monday", 8)
    end

    assert_raises RuntimeError do
      @student.add_day("Monday", 20)
    end
  end
end
