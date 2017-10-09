require 'pg'
require 'io/console'

class ExpenseData
  def initialize
    @db = PG.connect(dbname: "expenses")
    setup_schema
  end

  def list_expenses
    result = @db.exec "SELECT * FROM expenses ORDER BY created_on ASC, amount DESC"
    display_expenses(result)
  end

  def add_expense(amount, memo)
    sql = "INSERT INTO expenses (amount, memo, created_on) VALUES ($1, $2, $3)"
    @db.exec_params sql, [amount, memo, Date.today]
  end

  def search_expenses(term)
    sql = "SELECT * FROM expenses WHERE UPPER(memo) ILIKE $1"
    result = @db.exec_params sql, ["%#{term}%"]
    display_expenses(result)
  end

  def delete_expense(id)
    sql = "SELECT * FROM expenses WHERE id = $1"
    result = @db.exec_params sql, [id]
    abort "There is no expense with the id '#{id}'." unless result.count == 1
    sql = "DELETE FROM expenses WHERE id = $1"
    @db.exec_params sql, [id]
    puts "These expenses were deleted: "
    display_expenses(result)
  end

  def delete_all_expenses
    @db.exec "DELETE FROM expenses"
    puts "All expenses have been deleted."
  end

  private

  def setup_schema
    sql = <<~QUERY
      SELECT COUNT(*) FROM information_schema.tables
       WHERE table_schema = 'public' AND table_name = 'expenses'
    QUERY
    result = @db.exec sql
    if result.first['count'] == "0"
      @db.exec <<~SQL
        CREATE TABLE expenses (
          id serial PRIMARY KEY,
          amount numeric(6,2) NOT NULL CHECK (amount >= 0.01),
          memo text NOT NULL,
          created_on date NOT NULL
        );
      SQL
    end
  end

  def display_count(pg_result)
    count = pg_result.count
    count = 'no' if count == 0
    puts count == 1 ? "There is 1 expense." : "There are #{count} expenses."
  end

  def display_expenses(pg_result)
    display_count(pg_result)
    return if pg_result.count == 0
    total = 0
    pg_result.each do |tuple|
      columns = [ tuple['id'].rjust(3),
                  tuple['created_on'],
                  tuple['amount'].rjust(7),
                  tuple['memo']
                ]
      total += tuple['amount'].to_f
      puts columns.join(' | ')
    end
    puts "-" * 45
    puts "Total" + "#{total.round(2)}".rjust(21)
  end 

end

class CLI
  def initialize
    @expense_data = ExpenseData.new
  end

  def run(argv)
    case argv.first
    when 'list'
      @expense_data.list_expenses
    when 'add'
      amount = argv[1]
      memo = argv[2]
      abort "You must provide an amount and memo." unless amount && memo
      @expense_data.add_expense(amount, memo)
    when 'search'
      @expense_data.search_expenses(argv[1])
    when 'delete'
      id = argv[1]
      abort "You must provide an expense ID." unless id
      @expense_data.delete_expense(id)
    when 'clear'
      puts "This will remove all expenses. Are you sure? (y/n)"
      answer = $stdin.getch.downcase
      @expense_data.delete_all_expenses if answer == 'y'
    else
      display_help
    end
  end

  def display_help
    puts <<~HELP
      An expense recording system

      Commands:

      add AMOUNT MEMO [DATE] - record a new expense
      clear - delete all expenses
      list - list all expenses
      delete NUMBER - remove expense with id NUMBER
      search QUERY - list expenses with a matching memo field
    HELP
  end
end

CLI.new.run(ARGV)
