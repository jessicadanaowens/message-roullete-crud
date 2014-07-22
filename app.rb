require "sinatra"
require "./lib/messages_table"
require "./lib/comments_table"
require "active_record"
require "gschool_database_connection"
require "rack-flash"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @comments_table = CommentsTable.new(GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"]))
    @messages_table = MessagesTable.new(GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"]))
  end

  get "/" do
    messages = @messages_table.all

    erb :home, locals: {messages: messages}
  end

  get "/messages/:id" do
    message = @messages_table.find(params[:id])

    erb :"messages/show", locals: {message: message}
  end


  get "/messages/:id/edit" do
    message = @messages_table.find(params[:id])

    erb :"messages/edit", locals: {message: message}
  end

  post "/messages" do
    message = params[:message]
    if message.length <= 140
      @messages_table.create(message)
    else
      flash[:error] = "Message must be less than 140 characters."
    end
    redirect "/"
  end

  patch "/messages/:id" do
    message = params[:message]
    if message.length <= 140
      @messages_table.update(params[:id], {
        message: params[:message]
      })

      flash[:notice] = "Message updated"

      redirect "/messages/#{params[:id]}"
    else
      flash[:error] = "Message must be less than 140 characters."
      redirect back
    end

  end

  delete "/messages/:id" do
    @messages_table.delete(params[:id])

    flash[:notice] = "Message deleted"

    redirect "/"
  end

  post "/messages/:id/comment" do
    @comments_table.create(params[:id], params[:comment])

    redirect "/"
  end


end