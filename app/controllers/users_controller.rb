class UsersController < ApplicationController
  before_filter :authorize_user
  # GET /users
  # GET /users.xml
  def index
    @users = User.find(:all, :order => :email)
    user = User.find_by_id(session[:user_id])
    @user_type = user.user_type
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
user = User.find_by_id(session[:user_id])
    @user_type = user.user_type
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
    user = User.find_by_id(session[:user_id])
    @user_type = user.user_type
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        Vlibmailer.deliver_registration_confirmation(@user)
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to( :action => :index) }
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
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to :action => :index }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def enable_or_disable
    @user = User.find(params[:id])
    begin
      if(@user.user_type == 'e')
        @user.user_type = 'd'
        if(@user.update_attributes(params[:user]))
          flash[:notice] = "User #{@user.name} disabled"
        end
      else if(@user.user_type == 'd')
          @user.user_type = 'e'
          if(@user.update_attributes(params[:user]))
            flash[:notice] = "User #{@user.name} enabled"
          end
        end
      end
    rescue Exception => e
      flash[:notice] = "Exception in enable_or_disable: " + e.message
    end
    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end

  def say_when
    render :text => "<p>The Time is <b>" + DateTime.now.to_s + "</b></p>"
  end

  def user_statistics
    enabled_user_count = (User.find_all_by_user_type('e').count).to_s
    disabled_user_count = (User.find_all_by_user_type('d').count).to_s
    render :text => "Number of Active users: " + enabled_user_count + "<br\>" + "Number of Disabled users: " + disabled_user_count + "<br/>"
  end
  
  protected
  def authorize_user
    user = User.find_by_id(session[:user_id])
    unless user.user_type == 'a'
      session[:original_uri] = '/index'
      flash[:notice] = "Sorry, You are not authorized to view this page"
      respond_to do |format|
        format.html { redirect_to( :controller => :admin, :action => :index) }
      end
    end
  end
end
