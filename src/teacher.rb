require_relative 'schedule'

class Teacher < Schedule
  attr_reader :full_name
  attr_accessor :schedule

  def initialize(name_arg, schedule_arg = [])
    @full_name = name_arg
    @schedule = parse_schedule(schedule_arg)
  end

  private

  def parse_schedule(schedule_arg)
    super(schedule_arg)
  end
end
