import React from 'react';
import ReactDOM from 'react-dom';

class Car extends React.Component {
  render() {
    var car = this.props.data;
    return (
      <div className='CarContainer column-layout'>
        <div className='car-image'>
          <img src={car.picturePath} width="150" />
        </div>
        <p className="general-text">Car: {car.brand}, {car.model}</p>
        <p className="general-text">Price / Km: {car.pricePerKm}</p>
        <p className="general-text">Price / Day: {car.pricePerDay}</p>
      </div>
    )
  }
}

export default Car;
