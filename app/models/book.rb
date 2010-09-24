class Book < ActiveRecord::Base
  has_many :borrowed_books

  validates_presence_of :title, :description, :image_url, :quantity
  validates_numericality_of :quantity, :only_integer =>true, :message =>'can be only integer'
  validates_format_of :image_url, :with => %r{\.(gif|jpg|png)$}i,
    :message => 'must be a URL for GIF, JPG ' + 'or PNG image.(gif|jpg|png)'
  validate :quantity_must_be_positive
  protected
  def quantity_must_be_positive
    errors.add(:quantity, 'should be atleast 1' ) if quantity.nil? ||
      quantity < 1
  end

end
