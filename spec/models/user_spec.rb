require 'spec_helper'

describe User do

  before(:each) do
    @attr = { :name => "Example", :email => "user@example.com" }    
  end

  it "should create new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user=User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end

  it "should require a email" do
    no_email_user=User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  it "should reject names that too long" do
    long_name= "a" * 51
    long_name_user= User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  it "should accept valid email ids" do
    ids = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    ids.each do |id|
      valid_user = User.new(@attr.merge(:email => id))
      valid_user.should be_valid
    end
  end
  
  it "should reject invalid email ids" do
    ids = %w[user@foo,com THE_USER_foo.bar.org first.last@foo.]
    ids.each do |id|
      invalid_user=User.new(@attr.merge(:email => id))
      invalid_user.should_not be_valid
    end
  end

  it "should reject duplicate email ids" do
    User.create!(@attr)
    user_with_duplicate_mail=User.new(@attr)
    user_with_duplicate_mail.should_not be_valid
  end

  it "should reject email ids identical to uppercase" do
    upcased_email=@attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email_id= User.new(@attr)
    user_with_duplicate_email_id.should_not be_valid
  end
end
