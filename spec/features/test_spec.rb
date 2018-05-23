require 'rails_helper'

RSpec.describe "Home page", type: :feature do

  it "Should redirect to home page" do
    visit '/'
  end

  it "Should NOT REDIRECT to home page and pass" do
    puts "Test"
  end
end