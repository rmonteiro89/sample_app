require 'spec_helper'

describe "UsersIndices" do
  describe "GET /users_indices" do
  	let(:admin){ FactoryGirl.create(:user) }
  	let(:non_admin) { FactoryGirl.create(:user, name: 'Other', email: 'other@user.com', admin: false) }
  	let(:log_in_admin){ post login_path, session: { email: admin.email, password: admin.password } }
  	let(:log_in_non_admin){ post login_path, session: { email: non_admin.email, password: non_admin.password } }

  	before :each do 
  		FactoryGirl.create_list(:many_users, 30)
  	end

	  it "index including pagination and delete links" do
	    log_in_admin
	    get users_path
	    expect(response).to render_template('users/index')
	    assert_select 'div.pagination'
	    expect(User.count > 30).to be true
	    first_page_of_users = User.paginate(page: 1)
	    first_page_of_users.each do |user|
	      assert_select 'a[href=?]', user_path(user), text: user.name
	      unless user == admin
	        assert_select 'a[href=?]', user_path(user), text: 'delete',
	                                                    method: :delete
	      end
	    end
	    non_admin #create
	    expect{ delete user_path(non_admin) }.to change{ User.count }
	  end

		it "index as non-admin" do
	    log_in_non_admin
	    get users_path
	    assert_select 'a', text: 'delete', count: 0
	  end
  end
end

