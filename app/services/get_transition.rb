class GetTransition < Dry::Struct
  constructor_type :schema

  attribute :status, Types::String
  attribute :created, Types::String
  attribute :changelog, Types::Array.default([])

  def call
    build_status_tracker
  end

  def build_status_tracker#(changelog, status, created)
    status_history = []
    changelog["histories"].each do |his|
      if his["items"].map{|i| i["field"]}.include?("status")
        status_history << his
      end
    end
    if status_history.blank?
      [ { transition: status, delta: calculate_delta(Time.now.to_s, created) } ]
    else
      result = status_history.reverse.inject([]) do |res, his|
        status_his = his["items"].select{|i| i["field"] == "status"}
        res << { transition: transition(status_his.first["fromString"], status_his.first["toString"]), date: his["created"]}
      end
      result.each_with_index do |res, i|
        res[:delta] = i == 0 ? calculate_delta(res[:date], created) : calculate_delta(res[:date], result[i-1][:date])
        res[:time_diff_in_hrs] = i == 0 ? time_diff_in_hrs(res[:date], created) : time_diff_in_hrs(res[:date], result[i-1][:date])
      end
      result << { transition: status, delta: calculate_delta(Time.now.to_s, result.last[:date]) }
    end
  end

  def transition(from, to)
    "#{from} -> #{to}"
  end

  def calculate_delta(from_time, to_time)
    delta = time_diff_in_hrs(from_time, to_time)
    if delta > 24.to_f
      time = delta / 24
      "#{time.to_i} Days #{((time - time.to_i)*24).round} Hrs"
    else
      (delta < 1 ? "#{(delta*60).round} Mins" : "#{delta.round} Hrs")
    end
  end

  def time_diff_in_hrs(from_time, to_time)
    (Time.parse(from_time) - Time.parse(to_time))/3600
  end
end