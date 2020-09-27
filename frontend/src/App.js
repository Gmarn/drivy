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
  render() {
    return (
      <div className="column-layout main-index">
        <h1 className="title-1">Hello You! Choose your car for the next days!</h1>
        <div className="CarsContainer row-layout wrap">
          { this.state.cars && this.state.cars.map(car => <Car data={car}/>) }
        </div>
      </div>
    )
  }
}

export default App;
