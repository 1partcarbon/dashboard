class Scheduler

  class TaskArray
    def initialize
      @mutex = Mutex.new
      @array = []
    end

    def push(task)
      @mutex.synchronize {
        @array.push(task) unless @array.include?(task)
      }
      self
    end

  end

end