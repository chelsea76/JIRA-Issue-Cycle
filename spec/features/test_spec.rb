require 'rails_helper'

RSpec.describe "Home page", type: :feature do

  it "Should redirect to home page" do
    visit '/'
  end

  it "Should not redirect to home page" do
    puts "Test"
  end
end