class HomeController < ApplicationController
  def index
    if request.post?
      begin
        @issue = IssueStatusCycle.new(issue: Issue.new(id: params[:id])).call
      rescue => e
        flash[:error] = "The issue that you are trying does not exist. Please try again."
        redirect_to root_path
      end
    end
  end
end
