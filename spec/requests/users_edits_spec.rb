require 'spec_helper'

describe "UsersEdits" do
  describe "GET /users_edits" do
  	let(:user){ FactoryGirl.create(:user) }
  	let(:log_in_user){ post login_path, session: { email: user.email, password: user.password } }

	  it "unsuccessful edit" do
	  	log_in_user
	    get edit_user_path(user)
	    expect(response).to render_template('users/edit')
	    patch user_path(user), user: { name:  "",
	                                    email: "foo@invalid",
	                                    password:              "foo",
	                                    password_confirmation: "bar" }
	    expect(response).to render_template('users/edit')
    end

	  it "successful edit with friendly forwarding" do
		  get edit_user_path(user)
	    log_in_user
	    expect(response).to redirect_to edit_user_path(user)
	    name  = "Foo Bar"
	    email = "foo@bar.com"
	    patch user_path(user), user: { name:  name,
	                                    email: email,
	                                    password:              "",
	                                    password_confirmation: "" }
	    expect(flash.empty?).to be false
	    expect(response).to redirect_to(user)
	    user.reload
	    expect(user.name).to eq name
	    expect(user.email).to eq email
	  end
  end
end

