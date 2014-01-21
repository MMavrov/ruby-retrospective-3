# skeptic --lines-per-method 4 --line-length 80 --max-nesting-depth 1 --methods-per-class 8 --no-semicolons --no-trailing-whitespace homework2.rb
class Task
  attr_reader :description

  def status
    return :todo if @status == "TODO"
    return :current if @status == "CURRENT"
    return :done if @status == "DONE"
  end

  def priority
    return :low if @priority == "Low"
    return :normal if @priority == "Normal"
    return :high if @priority == "High"
  end

  def tags
    @tags == nil ? "" : @tags.split(',')#.map { |e| e.strip }
  end

  def initialize(task_string)
    @status = task_string.split('|')[0].strip
    @description = task_string.split('|')[1].strip
    @priority = task_string.split('|')[2].strip
    @tags =  task_string.split('|')[3]
  end
end

class TodoList
  attr_accessor :the_list

  def self.parse(todo_string)
    @todo_object = TodoList.new
    @todo_object.fillList todo_string
    @todo_object
  end

  def fillList(fill_with)
    @the_list = []
    fill_with.split(/\n/).each do |str_task|
      task = Task.new str_task
      @the_list << task
    end
  end

  def filter(array_of_criteria)
    filtered_list = TodoListActions.new(@the_list, array_of_criteria)
    filtered_list.filter
  end

  def adjoin
  end

  def tasks_in_progress
  end

  def tasks_completed
  end

  def tasks_todo
  end

  def completed?
  end
end

class TodoListActions
  attr_accessor :todo_list, :criterias
  def initialize(todo_list_target, array_of_criteria)
    @todo_list = todo_list_target
    @criteria = array_of_criterias
  end

  def filter
    @todo_list.select { |elem| }
  end
end

class Criterion
  attr_accessor :criterion_status, :criterion_priority, :list_of_criteria

  def initialize(c_type, c_concrete)
    self.init(c_type, c_concrete)
    @list_of_criteria = []
  end

  def init(c_type, c_concrete)
    @criterion_status = c_concrete if c_type == :criterion_status
    @criterion_priority = c_concrete if c_type == :criterion_priority
    @criterion_tags = c_concrete if c_type == :criterion_tags
  end

  def criterion_tags
	  @criterion_tags.split(' ')
  end

  def criterion_tags=(other)
    @criterion_tags = other
  end

  def getCriteria
    return @criterion_status if @criterion_status != nil
    return @criterion_priority if @criterion_priority != nil
    return @criterion_tags if @criterion_tags != nil
  end

  def &(other)
    @list_of_criteria << 'AND'
    other.list_of_criteria.each { |criterion| @list_of_criteria << criterion }
    self
  end

  def |(other)
    @list_of_criteria << 'OR'
    other.list_of_criteria.each { |criterion| @list_of_criteria << criterion }
    self
  end

  def !@
    @list_of_criteria.insert(0, 'NOT')
    self
  end
end

class Criteria < Criterion

  def self.status(target_status)
    crit = Criterion.new(:criterion_status, target_status)
    crit.list_of_criteria << crit.getCriteria
    crit
  end

  def self.priority(target_priority)
    crit = Criterion.new(:criterion_priority, target_priority)
    crit.list_of_criteria << crit.getCriteria
    crit
  end

  def self.tags(target_tags)
    crit = Criterion.new(:criterion_tags, target_tags)
    crit.list_of_criteria << crit.getCriteria
    crit
  end
end