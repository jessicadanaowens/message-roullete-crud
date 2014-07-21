class MessagesTable
  attr_reader :database_connection

  def initialize(database_connection)
    @database_connection = database_connection
  end

  def create(message)
    @database_connection.sql("INSERT INTO messages (message) VALUES ('#{message}')")
  end

  def all
    database_connection.sql("SELECT * FROM messages")
  end

  def find(id)
    database_connection.sql("SELECT * FROM messages WHERE id = #{id}").first
  end

  def update(id, attributes)
    update_sql = <<-SQL
    UPDATE messages
    SET message = '#{attributes[:message]}'
    WHERE id = #{id};
    SQL

    database_connection.sql(update_sql)
  end

  def delete(id)
    @database_connection.sql("DELETE FROM messages WHERE id = '#{id}'")
  end
end
