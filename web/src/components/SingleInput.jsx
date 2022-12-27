import React, {Component} from 'react';
import "./SingleInput.css";

/**
 * Parameters
 * (str) header: name of the input field
 * 
 * State
 * (str) value: content of the input filed
 */
class SingleInput extends Component{
	// eslint-disable-next-line
	constructor(props){
		super(props);
		//this.state={value:''};

		//this.onChange=this.onChange.bind(this);
	}

	/*onChange(e){
		this.setState({value:e.target.value});
	}*/

	render(){
		return(
			<div className='singleInput'>
				<label>{this.props.header}</label>
				<input value={this.props.value} onChange={this.props.handleChange} style={{backgroundColor: "white"}}/>
			</div>
		);
	}
}

export {SingleInput};