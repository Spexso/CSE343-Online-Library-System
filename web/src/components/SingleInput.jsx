import React, {Component} from 'react';
import "./SingleInput.css";

/**
 * Controlled Component SingleInput
 * 
 * Parameters
 * (str) header: name of the input field
 * (str) value: value of the input field
 * (function) handleChange: onChange function of the input field
 */
class SingleInput extends Component{

	render(){
		return(
			<div className='singleInput'>
				<label className='singleInput_label'>{this.props.header}</label>
				<input className='singleInput_input' value={this.props.value} onChange={this.props.handleChange}/>
			</div>
		);
	}
}

export {SingleInput};