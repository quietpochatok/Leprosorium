#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
@db= SQLite3::Database.new 'db/leprosorium.db'
@db.results_as_hash = true #резyльтат в виде хэша

end

#вызывается каждый раз при перезагрузке сайт/страницы
before do
#инициализация БД
init_db

end

# вызывается каждый раз при конфигурации приложения
# когда изменился код программы и перезагрузка страницы
configure do
	# инициализация БД
	init_db
	# создает таблицу если она не суще-етб также не пересоздает таблицу
	@db.execute 'CREATE TABLE IF NOT EXISTS "Posts" (
	"id"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	"create_date"	DATE NOT NULL,
	"content"	TEXT NOT NULL,
	"userName" TEXT
	)'

	# создает таблицу если она не суще-етб также не пересоздает таблицу
	@db.execute 'CREATE TABLE IF NOT EXISTS "Comments" (
	"id"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	"create_date"	DATE NOT NULL,
	"content"	TEXT NOT NULL,
	"postID" INTEGER
	)'


	# # создает таблицу если она не суще-етб также не пересоздает таблицу
	# @db.execute 'CREATE TABLE IF NOT EXISTS "author" (
	# "id"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	# "create_date"	DATE NOT NULL,
	# "content"	TEXT NOT NULL,
	# "postID" INTEGER,

	# )'
end

get '/' do
	@posts = @db.execute 'select * from Posts order by id desc'
	erb :lastPostMainmenu
end


# обработчик get-запроса /newPost
get '/newPost' do
	erb :newPost
end

# обработчик пост-запроса /newPost
post '/newPost' do

	# получаем данные из пост запроса через переменную
	post = params[:postUser]
	userName = params[:userName]

			if post.size <= 0
			@error = 'Input form text or get away!'			
			return erb :newPost
			end

	@db.execute 'insert into Posts (create_date,content,userName) values (datetime(), ?,?)', [post,userName]
					
	redirect '/'
end
#вывод информации о посте
get '/post/:id' do
	# получаем значение переменной из урл
	postID = params[:id]
	# вывод постов из БД с селектовкой по id, причем один так как завязано на урл страницу.
	detailPost = @db.execute 'select * from Posts where id =?',[postID]
	# пост переходит в переменную глобальную
	@row = detailPost[0]
	
	#
	@comments = @db.execute 'select * from Comments where postID=? order by id', [postID]
	erb :detail_post

	# erb "inf id #{postID}"

end

#обработчик пост запроса, где находится пост
post '/detail_post/:id' do

	# получаем значение переменной из урл
	postID = params[:id]

	# получаем данные из пост запроса через переменную
	post = params[:postUser]

	@db.execute 'insert into Comments (create_date,content,postID) 
					values (datetime(), ?,?)', [post, postID]
	
	redirect('/post/'+ postID)

end
