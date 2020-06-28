require_relative 'schedule'

class Teacher
  include Schedulable

  attr_reader :full_name
  attr_accessor :schedule

  def initialize(full_name, schedule = [])
    # full_name - complete name of the teacher
    # schedule - an array of integers that represent the availability of the teacher. [day, hour]
    #
    @full_name = full_name
    @schedule = parse_schedule(schedule)
  end
end
