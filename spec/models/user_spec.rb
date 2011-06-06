require 'spec_helper'

describe User do

  before(:each) do
    @attr = {
      :name => "Example",
      :email => "user@example.com",
      :password => "password",
      :password_confirmation => "password"
    }    
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

  describe "password validations" do
    it "should require a password" do
      User.new(@attr.merge(:password => "",
                            :password_confirmation => "")).
        should_not be_valid      
    end

    it "should require a matchind password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end

    it "should reject short passwords" do
      short_pass= "a" * 5
      short_pass_attr= @attr.merge(:password => short_pass,
                                   :password_confirmation => short_pass)
      User.new(short_pass_attr).should_not be_valid
    end

    it "should reject long passwords" do
      long_pass= "a" * 41
      long_pass_attr= @attr.merge(:password => long_pass,
                                   :password_confirmation => long_pass)
      User.new(long_pass_attr).should_not be_valid
    end    
  end

  describe "password encryption" do
    before (:each) do
      @user=User.create!(@attr)
    end

    it "should have encrypted password" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

    it "should be true if the passwords match" do
      @user.has_password?(@attr[:password]).should be_true
    end

    it "should be false if the passwords don't match" do
      @user.has_password?("invalid").should be_false
    end
  end

  describe "authenticate method" do
    it "should return nil on email/password mismatch" do
      wrong_password_user=User.authenticate(@attr[:email],"wrongpass")
      wrong_password_user.should be_nil
    end

    it "should return nil for an email address with no user" do
      non_existent_user=User.authenticate("bar@foo.com",@attr[:password])
      non_existent_user.should be_nil
    end

    it "should return the user on email/password match" do
      valid_user=User.authenticate(@attr[:email],@attr[:password])
      valid_user.should == @user
    end    
  end  
end
