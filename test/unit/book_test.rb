require File.dirname(__FILE__) + '/../test_helper'

class BookTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end

  def test_image_url
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg
http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }
    ok.each do |name|
      book = Book.new(:title => "My Book Title" ,
        :description => "yyy" ,
        :quantity => 1,
        :image_url => name)
      assert book.valid?, book.errors.full_messages
    end
    bad.each do |name|
      book = Book.new(:title => "My Book Title" , :description => "yyy" , :image_url => name, :quantity => 10)
      assert !book.valid?, "saving #{name}"
    end
  end
  def test_positive_quantity
    book = Book.new(:title => "My Book Title" ,
      :description => "yyy" ,
      :image_url => "zzz.jpg" )
    book.quantity = -1
    assert !book.valid?
    assert_equal "should be atleast 1" , book.errors.on(:quantity)
    book.quantity = 0
    assert !book.valid?
    assert_equal "should be atleast 1" , book.errors.on(:quantity)
    book.quantity = 1
    assert book.valid?
  end

end
