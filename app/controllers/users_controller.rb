class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    # チャットルームのエントリー用のパラメータ
    # 自分のuser_idを含んでいるエントリーを取得
    @currentUserEntry = Entry.where(user_id: current_user.id)
    # 現在参照しているユーザのuser_idを含んでいるエントリーを取得
    @userEntry = Entry.where(user_id: @user.id)
    
    
    if @user.id != current_user.id
      # 自分と相手のエントリーを比較し、同じルームIDのルームを取得
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
          if cu.room_id == u.room_id then
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      
      # ルームがすでに存在していた場合は何もしない
      if @isRoom
      
      # ルームが存在していない場合は新たにルームとエントリーを作成する 
      else
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end
  
  def following
    # フォロー一覧を表示するユーザをインスタンス変数に格納し、引き渡す。
    @user  = User.find(params[:id])
  end

  def followers
    # フォロワー一覧を表示するユーザをインスタンス変数に格納し、引き渡す。
    @user  = User.find(params[:id])
  end

  private
  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
