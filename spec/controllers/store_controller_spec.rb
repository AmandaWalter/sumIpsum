require 'rails_helper'

RSpec.describe StoreController, :type => :controller do

  it "should get index" do
    get :index
    assert_response :success
    assert_select '#columns #side li', minimum: 3
  end
end
