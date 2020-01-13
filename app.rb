#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
@db= SQLite3::Database.new 'db/leprosorium.db'
@db.results_as_hash = true #резyльтат в виде хэша

end


before do
init_db
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end
get '/newPost' do
erb :newPost
end

post '/newPost' do
	
post = params[:postUser]
erb "you taped: #{post}"
end

