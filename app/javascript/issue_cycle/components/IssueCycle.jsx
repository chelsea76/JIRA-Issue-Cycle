import React, { Component } from 'react';
import WebAPIUtils from '../utils/WebAPIUtils';
import SubTasks from './SubTasks';
import Immutable from 'immutable';

export default class IssueCycle extends Component {

  constructor(props) {
    super(props);
    this.submitIssue = this.submitIssue.bind(this);
    this.handleChange = this.handleChange.bind(this);
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

  submitIssue() {
    let url = "/issue_cycle?id=" + this.state.issueId
    this.setState({ pendingAction: true})
    WebAPIUtils.get(url)
      .then((responseData) => {
        this.setState({ cycle: Immutable.fromJS(responseData.cycle), subTasks: responseData.subtasks, error: null, pendingAction: false, issueChanged: true })
      })
      .fail((errorData) => {
        this.setState({ error: errorData.responseText, pendingAction: false, cycle: Immutable.Map(), subTasks: null })
      })
  }

  handleChange(event){
    this.setState({ issueId: this.refs.issueId.value, cycle: Immutable.Map(), subTasks: null });
  }

  renderCycleData(){
    let cycle = []
    this.state.cycle.forEach((issue) => {
      cycle.push(
        <tr>
          <td>{issue.get('transition')}</td>
          <td>{issue.get("delta")}</td>
        </tr>
      )
    })
    return(
      <div className="issue_cycle">
        <p>Please find below status cycle for Issue : {this.state.issueId}</p>
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
    let cycleData;
    if(this.state.cycle.size !== 0){
      cycleData = this.renderCycleData();
    }
    let subTasks;
    if(this.state.subTasks && this.state.subTasks.length && this.state.error === null){
      subTasks = <SubTasks tasks={this.state.subTasks} issueChanged={this.state.issueChanged}/>
    }
    return(
      <div className="container text-center">
        <h3>Issue Status Cycle</h3>
        <div>
          <label>Please enter JIRA Issue for which you want to see status cycle time: </label>
          <input type="text" name="id" onChange={this.handleChange} ref="issueId"/>
          <button type="submit" className="btn btn-primary" onClick={this.submitIssue}>Submit</button>
          {this.state.error && <p className="error">{this.state.error}</p>}
        </div>
        {this.state.pendingAction && <div className="spinner"></div>}
        {cycleData}
        {subTasks}
      </div>  
    )
  }
}

