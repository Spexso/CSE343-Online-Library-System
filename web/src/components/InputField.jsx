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
 * in the same order as the inputFileds array. The function can use "this.setState({statusMsg:<str>})" to display a feedback message on submit.
 * (bool) pic: Adds a jpeg picture input filed if set to true. Optional.
 */
class InputField extends Component{
	constructor(props){
		super(props);

		this.state={values:[], statusMsg:""};
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

		this.onClick=this.onClick.bind(this);
	}

	onClick(){
		let inputs=[].concat(this.state.values);
		let base64jpg=null;
		this.setState({values:Array(this.props.inputFields.length).fill(""), statusMsg:"Please wait..."});
		let bindedOnClickFunction=this.props.onClickFunction.bind(this);
		
		if(this.props.pic){
			
			let file=document.getElementById("jpg_input_elm")["files"][0];
			if(file===undefined){
				this.setState({statusMsg:"Error: Choose a jpg file before submitting."});
				return;
			}
			
			let reader=new FileReader();
			reader.onload=()=>{
				base64jpg=reader.result.replace("data:", "").replace(/^.+,/, "");
				bindedOnClickFunction(this.props.bearer, inputs, base64jpg);
				reader.onload=undefined;
			};
			reader.readAsDataURL(file);
		}

		else{
			bindedOnClickFunction(this.props.bearer, inputs, base64jpg);
		}
	}

	render(){		
		return(
			<div className="inputField">
				<h2 className='inputField_h2'>{this.props.fieldName}</h2>
				<ul className='inputField_ul'>
					{this.state.values.map((value, i) =>
						<li key={i}><SingleInput header={this.props.inputFields[i]} value={value} handleChange={this.onChangeFuncs[i]}/></li>)
					}
					{this.props.pic && <input className='jpg_button' id="jpg_input_elm" type="file" accept="image/jpg"/>}
				</ul>
				<p className='inputField_p'>{this.state.statusMsg}</p>
				<button className='inputField_button' onClick={this.onClick}>Submit</button>
			</div>
		);
	}
}

export {InputField};