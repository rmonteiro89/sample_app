require 'spec_helper'

describe UsersController do
	let(:user) { FactoryGirl.create(:user) }
	let(:other_user) { FactoryGirl.create(:user, name: 'Other', email: 'other@user.com') }
  let(:log_in_other_user) { post login_url, session: { email: other_user.email, password: other_user.password } }

  describe "GET 'new'" do
	  it "should get new" do
	    get :new
	    expect(response).to be_success
	  end

	  it "should redirect edit when not logged in" do
	    get :edit, id: user
	    expect(flash.empty?).to be false
	    expect(response).to redirect_to login_url
	  end

	  it "should redirect update when not logged in" do
	    patch :update, id: user, user: { name: user.name, email: user.email }
	    expect(flash.empty?).to be false
	    expect(response).to redirect_to login_url
	 	end

	 	it "should redirect index when not logged in" do
	    get :index
	    expect(response).to redirect_to login_url
	  end

	  it "should redirect destroy when not logged in" do
	  	user #create user
			expect{ delete :destroy, id: user }.to_not change{ User.count }
			expect(response).to redirect_to login_url
	  end

	end
end
