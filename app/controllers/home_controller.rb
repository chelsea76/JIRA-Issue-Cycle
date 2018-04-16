class HomeController < ApplicationController
  def index
  end

  def issue_cycle
    begin
      if params[:search_by] == 'issue' || params[:subtask].present?
        @issue = IssueStatusCycle.new(issue: Issue.new(id: params[:search_value] || params[:subtask])).call
        render json: @issue.to_json
      elsif  params[:search_by] == 'filter'
        @average_transition = AverageTransitionTime.new(transition_cycle: TransitionCycle.new(payload: { filter_id: params[:search_value]})).call
        render json: @average_transition.to_json
      end
    rescue => e
      render text: "No result found for current search criteria.", status: 400
    end
  end
end
