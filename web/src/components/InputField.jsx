import React, {Component} from 'react';
import { SingleInput } from './SingleInput';
import "./InputField.css";

/**
 * Parameters
 * (str) fieldName: name of the input filed
 * (str array) inputFields: header's of the SingleInput's
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
		console.log(this.state.values);
	}

	render(){

		let x=[];
		let i;
		for(i=0; i<this.props.inputFields.length; ++i){
			x.push(<SingleInput header={this.props.inputFields[i]} value={this.state.values[i]} handleChange={this.onChangeFuncs[i]}/>);
		}

		i=0;
		return(
			<div className="inputField">
				<h2>{this.props.fieldName}</h2>
				<ul>
					{x.map(elm => (
						<li key={i++}>{elm}</li>
					))}
				</ul>
				<button onClick={this.onClick}>Onayla</button>
			</div>
		);
	}
}

export {InputField};