class BooksController < ApplicationController
	before_action :authenticate_user!
	before_action :check_current_user_book?,  only: [:edit, :update]

	def create
		@book_new = Book.new(book_params)
		@book_new.user_id = current_user.id
	  if @book_new.save
	  	flash[:notice] = "successfully"
	    redirect_to book_path(@book_new)  #成功の場合
	  else
	  	@user = current_user
	  	@books = Book.all
	    render 'index' #失敗の場合 
	  end
	end

	def show
		@book = Book.find(params[:id])
		@user = User.find(@book.user_id)
		@book_new = Book.new
		@book_comment = BookComment.new
        @book_comments = @book.book_comments
	end

	def index
		@user = current_user
		@book_new = Book.new
		@books = Book.all
	end

	def edit
		@book = Book.find(params[:id])
		if !(@book.user_id == current_user.id)
			redirect_to books_path
		end
	end

    def update
    	@book = Book.find(params[:id])
    	# if (@book.user_id == current_user.id)
    		if @book.update(book_params)
    			flash[:notice] = "successfully"
    			# flash process
    			redirect_to book_path
    		else
    			# flash process
    			render :edit
    		end
    	# end
    end

    def destroy
		book = Book.find(params[:id])
        book.destroy
        redirect_to books_path
    end

	private
	def book_params
		params.require(:book).permit(:title, :body)
	end

	def check_current_user_book?
		book = Book.find(params[:id])
		if current_user.id != book.user_id
			redirect_to books_path
		end

		# unless current_user_id == book.user_id
		# 	redirect_to books_path
		# end

		# redirect_to books_path unless current_user.id == book.user_id
	end
 end