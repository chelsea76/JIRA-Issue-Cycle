class HomeController < ApplicationController
  def index
    if request.post?
      begin
        @result = IssueStatusCycle.new(issue_id: params[:issue_id]).call
      rescue
        flash[:error] = "The issue that you are trying does not exist. Please try again."
        redirect_to root_path
      end
    end
  end
end
