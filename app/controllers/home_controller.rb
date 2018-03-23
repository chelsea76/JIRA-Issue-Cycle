class HomeController < ApplicationController
  def index
  end

  def issue_cycle
    begin
      @issue = IssueStatusCycle.new(issue: Issue.new(id: params[:id])).call
      render json: @issue.to_json
    rescue => e
      render text: "The issue that you are trying does not exist. Please try again.", status: 400
    end
  end
end
