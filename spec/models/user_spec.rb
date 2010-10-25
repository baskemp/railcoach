require 'spec_helper'

describe User do
  context "when first created" do
    before(:each) do
      @user = User.new
    end

    it "should not save example" do
      @user.should_not be_valid
    end
  end

  context "when fully created" do
    before(:each) do
      @user = User.new
      @user.build_profile
      @user.username = 'edsgerd'
      @user.password = 'abcdefg'
      @user.password_confirmation = 'abcdefg'
      @user.profile.first_name = 'Edsger'
      @user.profile.last_name = 'Dijkstra'
      @user.profile.email = 'edsgerd@example.com'
      @user.profile.title = 'Genius'
      @user.profile.gender = 'm'
    end

    it "should be valid" do
      @user.should be_valid
    end

    it "should not be valid without a username" do
      @user.username = nil
      @user.should_not be_valid
    end

    it "should not be valid with an invalid e-mail" do
      @user.profile.email = 'Muhahaha'
      @user.should_not be_valid
    end
  end
end
