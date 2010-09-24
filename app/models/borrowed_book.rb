class BorrowedBook < ActiveRecord::Base
  belongs_to :book
  belongs_to :user
  before_create :set_borrowed_on_to_now
  before_destroy :update_book_quantity

  def update_book_quantity
    updated_quantity = Book.find(self.book_id).quantity +=1
    Book.find(self.book_id).update_attribute(:quantity, updated_quantity)
  end
  
  def set_borrowed_on_to_now
    self.borrowed_date = Time.now.strftime("%m/%d/%Y")
  end

  def get_user
    User.find(self.user).name
  end

  def get_book
    Book.find(self.book).title
  end

  def get_book_image
    Book.find(self.book).image_url
  end
  
  def get_borrowed_date
    self.borrowed_date.strftime("%m/%d/%Y")
  end

  def get_return_date
    self.borrowed_date.advance(:weeks => 2).strftime("%m/%d/%Y")
  end
end
