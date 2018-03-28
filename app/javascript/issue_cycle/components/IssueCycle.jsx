import React, { Component } from 'react';
import SubTasks from './SubTasks';
import Immutable from 'immutable';

export default class IssueCycle extends Component {

  constructor(props) {
    super(props);
    this.renderCycleData = this.renderCycleData.bind(this);
    this.state = {
      issueId: null,
      cycle: Immutable.Map(),
      subTasks: null,
      error: null,
      pendingAction: false,
      issueChanged: false
    }
  }

  renderCycleData(){
    let cycle = []
    if(this.props.transitionCycle.cycle === null){
      return null;
    }
    this.props.transitionCycle.cycle.forEach((issue) => {
      cycle.push(
        <tr>
          <td>{issue.transition}</td>
          <td>{issue.delta}</td>
        </tr>
      )
    })
    return(
      <div className="issue_cycle">
        <p>Please find below status cycle for Issue : {this.props.issueId}</p>
        <table className="table table-striped table-bordered">
          <thead>
            <tr>
              <th>Transition</th>
              <th>Time taken in transition</th>
            </tr>
          </thead>
          <tbody>
            {cycle}
          </tbody>
        </table>
      </div>
    )
  }

  render(){
    let { transitionCycle } = this.props;
    let cycleData;
    if(transitionCycle.cycle !== null){
      cycleData = this.renderCycleData();
    }
    let subTasks;
    if(transitionCycle.subtasks){
      subTasks = <SubTasks tasks={transitionCycle.subtasks} />
    }
    return(
      <div>
        {cycleData}
        {subTasks}
      </div>  
    )
  }
}

