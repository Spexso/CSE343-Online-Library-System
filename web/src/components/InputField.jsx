import React, {Component} from 'react';
import { SingleInput } from './SingleInput';
import "./InputField.css";

/**
 * Standalone Component InputField
 * 
 * Parameters
 * (str) fieldName: Name of the input filed.
 * (str array) inputFields: Headers of the SingleInputs'.
 * (function) onClickFunction: onClick function of the button. The function should have a single parameter of type (str array) whose size must be
 * equal to the size of inputFields array. Each element of the array corresponds to the current text in the input fileds when the button is pressed,
 * in the same order as the inputFileds array.
 */
class InputField extends Component{
	constructor(props){
		super(props);

		this.state={values:[]};
		for(let i=0; i<this.props.inputFields.length; ++i)
			this.state.values.push("");
		
		this.onChangeFuncs=[];

		this.parOnChangeFunc=function(index){
			return (e) => {
				let valuesCopy=[].concat(this.state.values);
				valuesCopy[index]=e.target.value;
				this.setState({values:valuesCopy});
			};
		}

		for(let i=0; i<this.props.inputFields.length; ++i)
			this.onChangeFuncs.push(this.parOnChangeFunc(i));
		
		/*this.x=[];
		for(let i=0; i<this.props.inputFields.length; ++i){
			this.x.push(<SingleInput header={this.props.inputFields[i]} value={this.state.values[i]} handleChange={this.onChangeFuncs[i]}/>);
		}*/

		this.onClick=this.onClick.bind(this);
	}

	onClick(){
		this.props.onClickFunction([].concat(this.state.values));
	}

	render(){

		let x=[];
		let i;
		for(i=0; i<this.props.inputFields.length; ++i){
			x.push(<SingleInput header={this.props.inputFields[i]} value={this.state.values[i]} handleChange={this.onChangeFuncs[i]}/>);
		}

		return(
			<div className="inputField">
				<h2 className='inputField_h2'>{this.props.fieldName}</h2>
				<ul className='inputField_ul'>
					{x.map(elm => (
						<li key={i++}>{elm}</li>
					))}
				</ul>
				<button className='inputField_button' onClick={this.onClick}>Onayla</button>
			</div>
		);
	}
}

export {InputField};