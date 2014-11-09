require 'spec_helper'

describe User do

	let(:user) { User.new(name: 'Raphael Monteiro', email: 'rmonteiro89@hotmail.com', 
												password: 'foobar', password_confirmation: 'foobar' ) }

  it 'is valid' do 
  	expect(user.valid?).to be true
  end

  it 'name must be present' do
  	user.name = '     '
  	expect(user.valid?).to be false 
  end

  it 'email must be present' do
  	user.email = '  '
  	expect(user.valid?).to be false
  end

  it 'name must not be longer than 50 characters' do
  	user.name = "a" * 51
  	expect(user.valid?).to be false
	end

	it 'email must not be longer than 255 characters' do
		user.email = "a" * 256
		expect(user.valid?).to be false
	end

	it 'email validation should accept valid addresses' do
		valid_addressess = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org 
										first.last@foo.jp alice+bob@baz.cn]
		valid_addressess.each do |valid_address|
			user.email = valid_address
			expect(user.valid?).to be true 
			puts "#{valid_address.inspect} should be valid"
		end
	end

	it 'email validation should reject invalid addresses' do
		invalid_addressess = %w[user@example,com user_at_foo.org user.name@example.
                            foo@bar_baz.com foo@bar+baz.com]
    invalid_addressess.each do |invalid_address|
    	user.email = invalid_address
    	expect(user.valid?).to be false
    	puts "#{invalid_address.inspect} should be invalid"
    end
	end

	it 'email must be unique' do
		duplicated_user = user.dup
		duplicated_user.email = user.email.upcase
		user.save
		expect(duplicated_user.valid?).to be false
	end

	it 'email should be saved as downcase' do
		user.email = 'ABC@ABC.com'
		user.save
		expect(user.email.downcase).to eq User.last.email
	end

	it 'password must has a minimum of 6 characters' do
		user.password = user.password_confirmation = 'a' * 5
		expect(user.valid?).to be false
	end
end
