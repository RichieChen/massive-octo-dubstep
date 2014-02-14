class ApplicationController < ActionController::Base
  def client
  end
  def addUser
  	@logins = Logins.new
  	if Logins.where(username: params[:user]).count == 0
  		#username not taken
  		if params[:user].length != 0 and params[:user].length <= 128 and params[:password].length <= 128
  			#valid username and pwd
  			@logins.username = params[:user]
  			@logins.password = params[:password]
  			@logins.counter = 1	
  			@logins.save
        render :json => { errCode: 1, count: 1}
  		else
        if params[:password].length > 128
          #invalid pwd
          render :json => { errCode: -4}
        end
        if params[:user].length == 0 or params[:user].length > 128
          #invalid username
          render :json => { errCode: -3}
        end
  			#invalid username and/or pwd
  		end
  	else
  		#username taken
      render :json => { errCode: -2}
  	end
  end

  def login
  	@logins = Logins.where(username: params[:user], password: params[:password])
  	if @logins.count == 1
  		#valid login
  		@firstAndOnlyUser = @logins.first
  		@firstAndOnlyUser.counter+=1
      Logins.update(@firstAndOnlyUser.id, :counter => @firstAndOnlyUser.counter)
      render :json => { errCode: 1, count: @firstAndOnlyUser.counter}
  	else
  		#invalid login
      render :json => { errCode: -1}
  	end
  end
  def resetFixture
    Logins.destroy_all
    render :json => {errCode: 1}
  end
  def unitTests
    @output = IO.popen('rake test')
    @resp =  {}
    @lines = @output.readlines
    @lines.each do |line|
      if line =~ /10 tests, 10 assertions, 0 failures/
        @chunks = line.split()
        @resp[:totalTests] = @chunks[0].to_i
        @resp[:nrFailed] = @chunks[4].to_i
      end
    end
    @resp[:output] = @lines.join("")
    render :json => @resp
  end
end
