require 'thread'

class Scheduler
  def initialize
    @tasks = TaskArray.new
  end

  def cron(cron_command, &block)
    task = CronTask.new
    @tasks.push(task)
  end




end