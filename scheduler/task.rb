class Task
  attr_reader :id
  attr_reader :original
  attr_reader :scheduled_at
  attr_reader :last_time
  attr_reader :unscheduled_at
  attr_reader :count

  attr_accessor :next_time


  def initialize(scheduler, original)
    @scheduler = scheduler
    @original = original

    @scheduled_at = Time.now
    @unscheduled_at = nil
    @last_time = nil

    @locals = {}
    @local_mutex = Mutex.new

    @id = determine_id

    @count = 0
    
  end


  def determine_id
    [
      self.class.name.split(':').last.downcase[0..-4],
      @scheduled_at.to_f,
    ].map(&:to_s).join('_')
  end
end









