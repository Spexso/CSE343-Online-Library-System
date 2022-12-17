import React, {Component} from 'react';
import { InputField } from './InputField';
import "./Sidebar.css";


class Sidebar extends Component{
	
	Logout = () => {
		console.log("Logout");
	  }

	
	constructor(props){
		super(props);

		this.items=[
			{index:0, icon:"a", text:"Kitap Ver", content:<InputField fieldName="Kitap Ver" inputFields={["E-mail:", "Kitap ID:"]}/>},
			{index:1, icon:"b", text:"Kitap Al", content:<InputField fieldName="Kitap Al" inputFields={["E-mail:", "Kitap ID:"]}/>},
			{index:2, icon:"c", text:"Kitap Kaydet", content:<InputField fieldName="Kitap Kaydet" inputFields={["ISBN:"]}/>},
			/*{index:3, icon:"d", text:"Kitap Sil", content:<InputField fieldName="Kitap Sil" inputFields={["Kitap ID:"]}/>},*/
		];

		this.parOnClick=function(index){
			return () => {
				this.setState({contentIndex:index});
			};
		}

		this.parOnClick=this.parOnClick.bind(this);

		this.state={contentIndex: 0};
	}

	render(){

		return(
			<div className='wholePage'>
				<div className='sidebar'>
					<ul>
						{this.items.map((value) =>(
							<li key={value.index} onClick={this.parOnClick(value.index)} style={{backgroundColor: value.index===this.state.contentIndex?"rgb(182, 155, 80)":"rgb(173, 199, 131)"}}>
								<div className="icon">{value.icon}</div>
								<div className="text">{value.text}</div>
							</li>
						))}
					</ul>
				</div>
				<div className='non-sidebar'>
					<div className='content'>
						{
							this.items[this.state.contentIndex].content
							/*<div>
								<InputField fieldName="Kitap Ver" inputFields={["E-mail:", "Kitap ID:"]}/>
								<InputField fieldName="Kitap Al" inputFields={["E-mail:", "Kitap ID:"]}/>
								<InputField fieldName="Kitap Kaydet" inputFields={["ISBN:"]}/>
								<InputField fieldName="Kitap Sil" inputFields={["Kitap ID:"]}/>
							</div>*/
						}
							
					</div>
					<button className='LogoutB' onClick={this.Logout}> Log out </button>
				</div>
			</div>
		);
	}
}

export {Sidebar};