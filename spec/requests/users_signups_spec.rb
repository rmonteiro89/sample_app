require 'spec_helper'

describe "UsersSignups" do

  context 'invalid signup information' do
  	it 'has to be in users/new' do
  		get signup_path
  		count_before = User.count
    	post users_path, user: { name:  "",
                               email: "user@invalid",
                               password:              "foo",
                               password_confirmation: "bar" }
      count_after = User.count
      expect(count_before).to eq count_after
      expect(response).to render_template('users/new')
  	end
  end

  context 'valid signup information' do
  	it 'has to be in users/show' do
  		get signup_path
  		count_before = User.count
      post_via_redirect users_path, user: { name:  "Example User",
                                            email: "user@example.com",
                                            password:              "password",
                                            password_confirmation: "password" }
      count_after = count_before + 1
      expect(User.count).to eq count_after 
      expect(response).to render_template('users/show')
  	end
  end

end