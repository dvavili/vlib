class BooksController < ApplicationController
  # GET /books
  # GET /books.xml
  before_filter :authorize_user
  def index
    if params[:search]
      @books = Book.find(:all, :conditions => ['title LIKE ?',"%#{params[:search]}%"])
    else
      @books = Book.find(:all)
    end
#    @books = Book.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @books }
    end
  end

  # GET /books/1
  # GET /books/1.xml
  def show
    @book = Book.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @book }
    end
  end

  # GET /books/new
  # GET /books/new.xml
  def new
    @book = Book.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @book }
    end
  end

  # GET /books/1/edit
  def edit
    @book = Book.find(params[:id])
  end

  # POST /books
  # POST /books.xml
  def create
    @book = Book.new(params[:book])

    respond_to do |format|
      if @book.save
        flash[:notice] = 'Book was successfully created.'
        format.html { redirect_to(@book) }
        format.xml  { render :xml => @book, :status => :created, :location => @book }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @book.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /books/1
  # PUT /books/1.xml
  def update
    @book = Book.find(params[:id])

    respond_to do |format|
      if @book.update_attributes(params[:book])
        flash[:notice] = 'Book was successfully updated.'
        format.html { redirect_to(@book) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @book.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.xml
  def destroy
    @book = Book.find(params[:id])
    @book.destroy

    respond_to do |format|
      format.html { redirect_to(books_url) }
      format.xml  { head :ok }
    end
  end

  def return_book
    Book.find(params[:id]).quantity +=1
  end

  def say_when
    render :text => "<p>The Time is <b>" + DateTime.now.to_s + "</b></p>"
  end

  def num_books_borrowed
    book_count = (BorrowedBook.find_all_by_user_id(session[:user_id]).count).to_s
    render :text => "Number of books borrowed: " + book_count
  end

  protected
  def authorize_user
    user = User.find_by_id(session[:user_id])
    @user_type = user.user_type
  end
end
