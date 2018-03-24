import React, { Component } from 'react';
import WebAPIUtils from '../utils/WebAPIUtils';
import Immutable from 'immutable';

export default class SubTasks extends Component {

  constructor(props) {
    super(props);
    this.renderTasks = this.renderTasks.bind(this);
    this.fetchSubtaskCycle = this.fetchSubtaskCycle.bind(this);
    this.state = {
      tasksCycle: Immutable.Map()
    }
  }

  componentDidUpdate(prevProps, prevState) {
    if (prevProps.tasks !== this.props.tasks) {
      this.setState({ tasksCycle: Immutable.Map()});
    }
  }

  fetchSubtaskCycle(event){
    let taskId = event.target.text;
    let url = "/issue_cycle?id=" + taskId;
    let tasksCycle = this.state.tasksCycle;
    if(tasksCycle.getIn([taskId, "collapsed"]) === undefined || tasksCycle.getIn([taskId, "collapsed"])){
      WebAPIUtils.get(url)
        .then((responseData) => {
          tasksCycle = tasksCycle.set(taskId, Immutable.Map({cycle: responseData.cycle, collapsed: false }))
          this.setState({tasksCycle: tasksCycle})
        })
    }else{
      tasksCycle = tasksCycle.setIn([taskId, "collapsed"], true);
      this.setState({tasksCycle: tasksCycle});
    }
  }

  renderTaskCycle(task){
    let collapsed = this.state.tasksCycle.getIn([task, "collapsed"])
    let cycle = this.state.tasksCycle.getIn([task, "cycle"])
    let cycleValue= [];
    if(cycle === undefined || collapsed){
      return null;
    }
    if(cycle !== undefined ){
      cycle.forEach((c) => {
        cycleValue.push(
          <tr>
            <td>{c.transition}</td>
            <td>{c.delta}</td>
          </tr>
        )
      });
    }
    return(
      <table className="table table-striped table-bordered">
        <thead>
          <tr>
            <th>Transition</th>
            <th>Time taken in transition</th>
          </tr>
        </thead>
        <tbody>
         {cycleValue}
        </tbody>
      </table>
    )
  }

  renderTasks(tasks){
    let tasksList = [];
    tasks.forEach((task) =>{
      tasksList.push(
        <div className="col-md-4" key={task}>
          <div className="col-md-4"><a href="javascript:void(0)" ref="subTask" onClick={this.fetchSubtaskCycle}>{task}</a></div>
          {this.renderTaskCycle(task)}
        </div>
      )
    });
    return tasksList;
  }

  render(){
    return(
      <div>
        <h4>SubTasks</h4>
        <div className="row">
          {this.renderTasks(this.props.tasks)}
        </div>
      </div>
    )
  }
}