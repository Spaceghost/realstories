class UsersController < ApplicationController

  # anonymous can only create user
  before_filter :authorize, :except => [:new, :create]
  # edit profile, destroy user requires auth check
  before_filter :check_user, :except => [:index, :show, :new, :create]
  
  # GET /users
  # GET /users.xml
  # Admins only
  def index
    # unless User.find(session[:user_id]).is_admin?
    #   redirect_to :controller => 'stories', :action => 'index'
    # end
    @users = User.find(:all, :order => :name)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  # User profile
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  # TODO: Email verification so users can't create tons of accounts.
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        flash[:notice] = "User #{@user.name} was successfully created."
        format.html { redirect_to(:controller => 'stories', :action=>'index') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])
    
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = "User #{@user.name} was successfully updated."
        format.html { redirect_to(:controller => 'stories', :action=>'index') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  # TODO: Delete all of user's posts too.
  def destroy
    @user = User.find(params[:id])
    # destroy all stories!
    @user.stories.destroy_all
    # destroy user record!
    @user.destroy
    # log out!
    session[:user_id] = nil if session[:user_id].to_i == params[:id].to_i

    respond_to do |format|
      format.html { redirect_to(:controller => 'stories', :action=>'index') }
      format.xml  { head :ok }
    end
  end
  
  private
    
    def check_user
      unless session[:user_id].to_i == params[:id].to_i  || User.find(session[:user_id]).is_admin?
        redirect_to :controller => 'stories', :action => 'index'
      end
    end
  
end
