class FavoriteUsersController < ApplicationController
  # GET /favorite_users
  # GET /favorite_users.xml
  def index
    @favorite_users = FavoriteUser.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @favorite_users }
    end
  end

  # GET /favorite_users/1
  # GET /favorite_users/1.xml
  def show
    @favorite_user = FavoriteUser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @favorite_user }
    end
  end

  # GET /favorite_users/new
  # GET /favorite_users/new.xml
  def new
    @favorite_user = FavoriteUser.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @favorite_user }
    end
  end

  # GET /favorite_users/1/edit
  def edit
    @favorite_user = FavoriteUser.find(params[:id])
  end

  # POST /favorite_users
  # POST /favorite_users.xml
  def create
    @favorite_user = FavoriteUser.new(params[:favorite_user])

    if params[:search]
      user = User.find current_user.id
      @graph = Koala::Facebook::API.new user.token
      #@profiles = @graph.search params[:name], {'type' => 'user', 'fields' => 'id,name,link,username,picture', 'locale' => 'ja_JP'}
      @profiles = @graph.get_connections 'me', 'friends', {:fields => 'id,name,link,username,picture', :locale => 'ja_JP'}
      respond_to do |format|
        format.html { render :action => "new" }
        format.xml  { render :xml => @favorite_user.errors, :status => :unprocessable_entity }
      end
    else
      respond_to do |format|
        if @favorite_user.save
          format.html { redirect_to(@favorite_user, :notice => 'Favorite user was successfully created.') }
          format.xml  { render :xml => @favorite_user, :status => :created, :location => @favorite_user }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @favorite_user.errors, :status => :unprocessable_entity }
        end
      end
    end

  end

  # PUT /favorite_users/1
  # PUT /favorite_users/1.xml
  def update
    @favorite_user = FavoriteUser.find(params[:id])

    respond_to do |format|
      if @favorite_user.update_attributes(params[:favorite_user])
        format.html { redirect_to(@favorite_user, :notice => 'Favorite user was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @favorite_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /favorite_users/1
  # DELETE /favorite_users/1.xml
  def destroy
    @favorite_user = FavoriteUser.find(params[:id])
    @favorite_user.destroy

    respond_to do |format|
      format.html { redirect_to(favorite_users_url) }
      format.xml  { head :ok }
    end
  end
end
