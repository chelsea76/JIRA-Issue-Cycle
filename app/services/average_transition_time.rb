class AverageTransitionTime < Dry::Struct
  constructor_type :schema

  attribute :transition_cycle, Types::Class

  def call
    average_transition_time
  end

  def average_transition_time
    result = Search.new(payload: transition_cycle.payload).call
    hash = {}

    result["issues"].inject(hash) do |res, issue|
      res[issue["key"]] = GetTransition.new(changelog: issue["changelog"], status: issue["fields"]["status"]["name"], created: issue["fields"]["created"]).call
      res
    end
    output = {}
    hash.each do |k,v|
      output[k] = v.inject({}) {|res, i| res[i[:transition]] = i[:time_diff_in_hrs] if i.has_key?(:time_diff_in_hrs); res}
    end

    transition_hash = {}
    transition_counter_hash = {}
    output.each do |k,v|
      v.each do |i,j|
        if transition_hash.has_key?(i)
          transition_counter_hash[i] += 1
          transition_hash[i] = (transition_hash[i] + j)/transition_counter_hash[i]
        else
          transition_counter_hash[i] = 1
          transition_hash[i] = j
        end
      end
    end
    transition_hash = transition_hash.sort_by {|_key, value| value}.to_h.to_a.reverse.to_h
    transition_hash = transition_hash.inject({}) {|res, i| res[i[0]] = parse_time(i[1]); res}
    transition_cycle.average_transition_hash = transition_hash#.sort_by {|_key, value| value}.to_h.to_a.reverse.to_h
    transition_cycle.no_of_tickets = result["issues"].size
    transition_cycle.transition_counter = transition_counter_hash
    transition_cycle
  end

  def parse_time(time)
    if time > 24.to_f
      time = time / 24
      "#{time.to_i} Days #{((time - time.to_i)*24).round} Hrs"
    else
      (time < 1 ? "#{(time*60).round} Mins" : "#{time.round} Hrs")
    end
  end

end