require_relative 'person'

class Student < Person
  attr_reader :full_name, :mode, :level, :schedule

  def initialize(full_name = nil, mode = grupal, level = "Beginner", schedule_arg = [])
    @full_name = full_name
    @mode = mode
    @level = level
    @schedule = parse_schedule(schedule_arg)
  end

  # def schedule
  #   @schedule
  # end

  private

  def parse_schedule(schedule_arg)
    super(schedule_arg)
  end
end
