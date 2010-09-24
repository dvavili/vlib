require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end

  def test_unique_email
    user = User.new(:name => 'aaa',
      :email => users(:divya).email,
      :address => 'addr1',
      :phone_number => '1231231231'
      )
    assert !user.save
    assert_equal "is already registered to the system" , user.errors.on(:email)
  end

end
