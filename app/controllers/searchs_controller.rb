class SearchsController < ApplicationController
  
  def search
    # 検索対象のモデル："Book", "User"
    @model = params[:model]
    # 検索ワード
    @content = params[:content]
    # 検索方法："完全一致","前方一致","後方一致","部分一致"
    @how = params[:how]
    # model,content,howを元に検索した結果をdatasに格納する
    if @model == 'User'
			@datas = User.search_for(@content, @how)
		elsif @model == 'Book'
			@datas = Book.search_for(@content, @how)
		end
  end
end
