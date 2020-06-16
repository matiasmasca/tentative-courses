require_relative 'person'

class Teacher < Person
  attr_reader :name, :schedule

  # def schedule=(schedule)
  #   return [] if schedule.empty?

  #   schedule.each {|schedule| self.add_day(schedule[0],schedule[1])}
  # end

  def initialize(name_arg, schedule_arg = [])
    @name = name_arg
    @schedule = parse_schedule(schedule_arg)
  end

  private

  def parse_schedule(schedule_arg)
    super(schedule_arg)
  end
end
