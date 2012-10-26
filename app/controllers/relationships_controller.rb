class RelationshipsController < ApplicationController
  before_filter :signed_in_user

  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
#    redirect_to @user
    respond_to do |format|
      format.html { redirect_to @user }   #normal response
      format.js                           #ajax response (stay on same page)
                                          # (calls create.js.erb to update the page)
    end
  end
  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js                           # calls destroy.js.erb to update the page
    end
  end
end