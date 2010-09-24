require 'test_helper'

class BorrowedBooksControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:borrowed_books)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create borrowed_book" do
    assert_difference('BorrowedBook.count') do
      post :create, :borrowed_book => { }
    end

    assert_redirected_to borrowed_book_path(assigns(:borrowed_book))
  end

  test "should show borrowed_book" do
    get :show, :id => borrowed_books(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => borrowed_books(:one).id
    assert_response :success
  end

  test "should update borrowed_book" do
    put :update, :id => borrowed_books(:one).id, :borrowed_book => { }
    assert_redirected_to borrowed_book_path(assigns(:borrowed_book))
  end

  test "should destroy borrowed_book" do
    assert_difference('BorrowedBook.count', -1) do
      delete :destroy, :id => borrowed_books(:one).id
    end

    assert_redirected_to borrowed_books_path
  end
end
