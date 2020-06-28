require 'minitest/autorun'
require '../src/schedule'

describe 'Schedulable' do
  before do
    @test_obj = Object.new
    @test_obj.extend(Schedulable)
    @schedule_array = [[1, 9],[1, 10],[1, 11],[1, 12],[5, 15]]
  end

  it 'parse_schedule' do
    schedule_array = [[1, 9]]
    schedule = @test_obj.parse_schedule(schedule_array)
    expect(schedule.first.class).must_equal Array
    expect(schedule.first[0]).must_equal 1
    expect(schedule.first[1]).must_equal 9
  end

  describe 'parse_hour' do
    it 'must be Ok for 9 AM' do
      hour = @test_obj.parse_hour(9)
      expect(hour).must_equal 9
    end

    it 'must be Ok for 19 AM' do
      hour = @test_obj.parse_hour(19)
      expect(hour).must_equal 19
    end

    it 'must be Error for 8 AM' do
      err = assert_raises RuntimeError do
        hour = @test_obj.parse_hour(8)
      end
      assert_match /Error: hour must be number between 9 and 19/, err.message
    end

    it 'must be Error for 8 PM' do
      err = assert_raises RuntimeError do
        hour = @test_obj.parse_hour(20)
      end
      assert_match /Error: hour must be number between 9 and 19/, err.message
    end
  end

  describe 'parse_day' do
    it 'must be Ok for Monday' do
      day = @test_obj.parse_day(1)
      expect(day).must_equal 1
    end

    it 'must be Ok for Friday' do
      day = @test_obj.parse_day(5)
      expect(day).must_equal 5
    end

    it 'must be Error for Sunday' do
      err = assert_raises RuntimeError do
        day = @test_obj.parse_day(7)
      end
      assert_match /Error: day must be between Monday and Friday/, err.message
    end

    it 'must be Error for Saturday' do
      err = assert_raises RuntimeError do
        day = @test_obj.parse_day(6)
      end
      assert_match /Error: day must be between Monday and Friday/, err.message
    end

    it 'must be Error for number grader than 7' do
      err = assert_raises RuntimeError do
        day = @test_obj.parse_day(8)
      end
      assert_match /Error: invalid number for day, it has to be a number between 1 and 7./, err.message
    end
  end

  it 'has_schedule? must be OK with a positive case' do
    response = @test_obj.has_schedule?(@schedule_array, [1, 9])
    expect(response).must_equal true
  end

  it 'has_schedule? must be false with a negative case' do
    response = @test_obj.has_schedule?(@schedule_array, [1, 14])
    expect(response).must_equal false
  end

  it 'add_day must be OK with a positive case' do
    response = @test_obj.add_day(@schedule_array, 1, 14)
    expect(response.last).must_equal [1, 14]
  end

  it 'day_to_number must return 1 for Monday ' do
    response = @test_obj.day_to_number("Monday")
    expect(response).must_equal 1
  end
end
