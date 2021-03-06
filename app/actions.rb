require 'json'
enable :sessions

helpers do
	def current_user
		@current_user = User.find_by(id: session[:user_id]) if session[:user_id]
	end
end

# => GET
get '/' do
	erb :index
end

get '/home' do
	@posts = Post.first
	@posts.to_json
	erb :home
end

get '/login' do
    erb :login
end

get '/profile' do
	@user = current_user
    erb :profile
end

get '/signup' do
	erb :signup
end

get '/logout' do
	session.clear
	redirect '/'
end

get '/post/new' do
	puts "test"
	erb :post_new
end

get '/post/all' do
	@posts = Post.all
	@posts.to_json
end

get '/post/:id' do
	@post = Post.find(params[:id])
	erb :post_view
end

get '/login/error' do
	# load error page here
end

# => POST
post '/login' do
	username = params[:username]
	password = params[:password]

	@user = User.find_by(username: username)
	if @user.password == password
		session[:user_id] = @user.id
		redirect '/profile'
	else
		redirect '/login'
	end
end

post '/profile' do
	# @user = User.update() ---> update this
	redirect '/'
end

post '/signup' do
	username = params[:username]
	password = params[:password]

	@user = User.find_by(username: username)
	if @user
		redirect '/signup'
	else
		@user = User.create(
			firstname: params[:firstname],
			lastname: params[:lastname],
			username: username,
			password: password,
		)
		session[:user_id] = @user.id
		redirect '/profile'
	end
end

post '/post/create' do
	title = params[:title]
	category = params[:category]
	content = params[:content]
	image = params[:image]
	#@post = Post.where()
	@post = current_user.posts.create(
		title: title,
		category: category,
		content: content,
		likes: 0,
		image: image
	)
	#redirect "/post/#{@post.id}"
end