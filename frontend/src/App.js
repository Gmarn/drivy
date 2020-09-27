import "./index.css";
import React from 'react';
import ReactDOM from 'react-dom';
import Car from './Car';

class App extends React.Component {
  constructor(props) {
    super(props)
    this.state = {cars:null}
  }
  componentDidMount() {
    fetch('/cars.json', {
      method: 'get',
      headers: {
        'Accept': 'application/json, text/plain, */*',
        'Content-Type': 'application/json'
      }
    })
    .then(response => response.json())
    .then(data => this.setState({ cars:data }));
  }
  handleSearch = () => {
    let url = new URL('http://localhost:3001/cars.json')

    const params = {};
    const {duration, distance } = this.state;
    if (duration && duration !== '') params.duration = duration
    if (distance && distance !== '') params.distance = distance
    url.search = new URLSearchParams(params)

    fetch(url, {
      method: 'get',
      headers: {
        'Accept': 'application/json, text/plain, */*',
        'Content-Type': 'application/json'
      }
    })
    .then(response => response.json())
    .then(data => this.setState({ cars:data }));
  }
  handleDurationChange = (e) => {
    this.setState({duration: e.target.value})
  }
  handleDistanceChange = (e) => {
    this.setState({distance: e.target.value})
  }
  render() {
    return (
      <div className="column-layout main-index">
        <h1 className="title-1">Hello You! Choose your car for the next days!</h1>
        <div className="">
          <p>Duration: </p>
          <input type="number" value={this.state.duration} onChange={this.handleDurationChange} />
        </div>
        <div className="">
          <p>Distance: </p>
          <input type="number" value={this.state.distance} onChange={this.handleDistanceChange} />
        </div>
        <button onClick={this.handleSearch}>Submit</button>
        <div className="CarsContainer row-layout wrap">
          { this.state.cars && this.state.cars.map(car => <Car data={car}/>) }
        </div>
      </div>
    )
  }
}

export default App;
