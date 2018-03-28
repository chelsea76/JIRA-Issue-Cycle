class TransitionCycle
  include ActiveModel::Model

  attr_accessor :transition_counter , :average_transition_hash, :payload, :no_of_tickets
end