class CommentsTable
  attr_reader :database_connection

  def initialize(database_connection)
    @database_connection = database_connection
  end

  def create(id, comment)
    @database_connection.sql("INSERT INTO comments (message_id, comment) VALUES ('#{id}', '#{comment}')")
  end

  def all
    database_connection.sql("SELECT * FROM comments")
  end

  def find(id)
    database_connection.sql("SELECT * FROM comments WHERE id = #{id}").first
  end

  def update(id, attributes)
    update_sql = <<-SQL
    UPDATE comments
    SET comment = '#{attributes[:comment]}'
    WHERE id = #{id};
    SQL

    database_connection.sql(update_sql)
  end

  def delete(id)
    @database_connection.sql("DELETE FROM comments WHERE id = '#{id}'")
  end
end