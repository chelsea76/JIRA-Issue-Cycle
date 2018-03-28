import React, { Component } from 'react';
import Immutable from 'immutable';

export default class AverageTransition extends Component {
  constructor(props){
    super(props);
    this.renderTransitionTable = this.renderTransitionTable.bind(this);
  }

  renderTransitionTable(){
    let { transitionCycle } = this.props;
    let cycle = [];
    let averageTransition = transitionCycle.average_transition_hash;
    let transitionCounter = Immutable.Map(transitionCycle.transition_counter);
    if(averageTransition === null){
      return null;
    }
    Object.entries(averageTransition).forEach(function(transition,index) {
      cycle.push(
        <tr>
          <td>{transition[0]}</td>
          <td>{transition[1]}</td>
          <td>{transitionCounter.get(transition[0])}</td>
        </tr>
      )
    });
    return cycle;
  }

  render(){
    let { transitionCycle } = this.props;
    return(
      <div className="average_transition">
        <div className="row">
          <div className="col-md-5">
            <label>Total Tickets : </label>
            {transitionCycle.no_of_tickets}
          </div>
        </div>
        <table className="table table-striped table-bordered">
          <thead>
            <tr>
              <th>Transition</th>
              <th>Average time taken in transition</th>
              <th># of tickets involved in transition</th>
            </tr>
          </thead>
          <tbody>
            {this.renderTransitionTable()}
          </tbody>
        </table>
      </div>
    )
  }
}