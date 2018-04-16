import React, { Component } from 'react';
import WebAPIUtils from '../utils/WebAPIUtils';
import IssueCycle from './IssueCycle';
import AverageTransition from './AverageTransition';
import Immutable from 'immutable';

export default class Search extends Component {
  constructor(props) {
    super(props);
    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleInputChange = this.handleInputChange.bind(this);
    this.state = {
      searchBy: 'issue',
      searchValue: '',
      response: null,
      error: null,
      pendingAction: false
    }
  }

  handleChange(event){
    this.setState({ searchBy: event.target.value, searchValue: '', error: null, response: null });
  }

  handleInputChange(event){
    this.setState({ searchValue: event.target.value, error: null})
  }

  handleSubmit(){
    this.setState({ pendingAction: true});
    let url = "/issue_cycle?search_by=" + this.state.searchBy + '&search_value=' + this.state.searchValue
    WebAPIUtils.get(url)
      .then((responseData) => {
        this.setState({ response: responseData, error: null, pendingAction: false })
      })
      .fail((errorData) => {
        this.setState({ error: errorData.responseText, pendingAction: false, response: null })
      })
  }

  render(){
    let transitionTable;
    if(this.state.response !== null){
      if(this.state.searchBy === 'issue'){
        transitionTable = <IssueCycle transitionCycle={this.state.response} issueId={this.state.searchValue} />
      }else if(this.state.searchBy === 'filter'){
        transitionTable = <AverageTransition transitionCycle={this.state.response} filterId={this.state.searchValue}/>
      }
    }
    return(
      <div className="container text-center">
        <h3>Transition Time</h3>
        <div className="row">
          <div className="col-md-7">
            <label>Please use search to find average transition time</label>
          </div>
        </div>
        <div className="row">
          <div className="col-md-3">
            <select className="form-control" name="search_by" onChange={this.handleChange}>
              <option value="issue">Issue</option>
              <option value="filter">Filter</option>
            </select>
          </div>
          <div className="col-md-5">
            <input name="value" className="form-control" onChange={this.handleInputChange} value={this.state.searchValue}/>
          </div>
          <div className="col-md-1">
            <button type="submit" className="btn btn-primary" onClick={this.handleSubmit}>Submit</button>
          </div>
        </div>  
        <div className="row">
          {this.state.error && <p className="error">{this.state.error}</p>}
        </div>
        <div className="row">
          <div className="col-md-9">
            {this.state.pendingAction && <div className="spinner"></div>}
          </div>
        </div>
        {transitionTable}
      </div>
    )
  }
}