namespace :feature do

	task :run do
		system("USING_CAPYBARA=true bundle exec rspec spec/features/test_spec.rb")
	end
end