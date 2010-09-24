class BorrowedBooksController < ApplicationController
  # GET /borrowed_books
  # GET /borrowed_books.xml
  def index

    user = User.find_by_id(session[:user_id])
    @user_type = user.user_type
    if user.user_type == 'a'
      @borrowed_books = BorrowedBook.find(:all)
    else
      if user.user_type == 'e'
        @borrowed_books = BorrowedBook.find_all_by_user_id(session[:user_id])
      end
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @borrowed_books }
    end
  end

  # GET /borrowed_books/1
  # GET /borrowed_books/1.xml
  def show
    @borrowed_book = BorrowedBook.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @borrowed_book }
    end
  end

  # GET /borrowed_books/new
  # GET /borrowed_books/new.xml
  def new
    @borrowed_book = BorrowedBook.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @borrowed_book }
    end
  end

  # GET /borrowed_books/1/edit
  def edit
    @borrowed_book = BorrowedBook.find(params[:id])
  end

  # POST /borrowed_books
  # POST /borrowed_books.xml
  def create
    @borrowed_book = BorrowedBook.new(params[:borrowed_book])

    respond_to do |format|
      if @borrowed_book.save
        flash[:notice] = 'BorrowedBook was successfully created.'
        format.html { redirect_to(@borrowed_book) }
        format.xml  { render :xml => @borrowed_book, :status => :created, :location => @borrowed_book }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @borrowed_book.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /borrowed_books/1
  # PUT /borrowed_books/1.xml
  def update
    @borrowed_book = BorrowedBook.find(params[:id])

    respond_to do |format|
      if @borrowed_book.update_attributes(params[:borrowed_book])
        flash[:notice] = 'BorrowedBook was successfully updated.'
        format.html { redirect_to(@borrowed_book) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @borrowed_book.errors, :status => :unprocessable_entity }
      end
    end
  end

  def return_book
    @borrowed_book = BorrowedBook.find(params[:id])
    #    @borrowed_book.quantity += 1
    #    @borrowed_book.update_attributes(params[:@borrowed_book])
    @borrowed_book.destroy
    respond_to do |format|
      format.html { redirect_to(borrowed_books_url) }
      format.xml  { head :ok }
    end
  end

  def borrow
    book_to_borrow = Book.find(params[:id])
    if book_to_borrow.quantity >1
      book_to_borrow.quantity -= 1
      book_to_borrow.update_attributes(params[:book_to_borrow])
    end
    BorrowedBook.new(:user_id => session[:user_id],:book_id => book_to_borrow.id).save
    respond_to do |format|
      format.html { redirect_to(borrowed_books_url) }
      format.xml  { head :ok }
    end
  end

  # DELETE /borrowed_books/1
  # DELETE /borrowed_books/1.xml
  def destroy
    @borrowed_book = BorrowedBook.find(params[:id])
    @borrowed_book.destroy

    respond_to do |format|
      format.html { redirect_to(borrowed_books_url) }
      format.xml  { head :ok }
    end
  end

  def say_when
    render :text => "<p>The Time is <b>" + DateTime.now.to_s + "</b></p>"
  end

  def num_books_borrowed
    book_count = (BorrowedBook.find_all_by_user_id(session[:user_id]).count).to_s
    render :text => "Number of books borrowed: " + book_count
  end
end
