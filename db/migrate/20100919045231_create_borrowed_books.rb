class CreateBorrowedBooks < ActiveRecord::Migration
  def self.up
    create_table :borrowed_books do |t|
      t.integer :user_id, :options =>
        "CONSTRAINT fk_borrowed_book_users REFERENCES users(id)"
      t.integer :book_id, :options =>
        "CONSTRAINT fk_borrowed_book_books REFERENCES books(id)"
      t.timestamp :borrowed_date
    end
  end

  def self.down
    drop_table :borrowed_books
  end
end
