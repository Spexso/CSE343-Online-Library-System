import React, {Component} from 'react';
import { InputField } from './InputField';
import "./MainPage.css";

class MainPage extends Component{
	
	constructor(props){
		super(props);

		this.state={contentIndex: 0};
		let self=this;

		this.items=[
			{index:0,
			 icon:"a",
			 text:"Kitap Ver",
			 onClick(){self.setState({contentIndex:0});},
			 style(){return {backgroundColor: this.index===self.state.contentIndex?"rgb(182, 155, 80)":"rgb(173, 199, 131)"};},
			 content:<InputField key="0" fieldName="Kitap Ver" inputFields={["E-mail:", "Kitap ID:"]} onClickFunction={this.f}/>
			},

			{index:1,
			 icon:"b",
			 text:"Kitap Al",
			 onClick(){self.setState({contentIndex:1});},
			 style(){return {backgroundColor: this.index===self.state.contentIndex?"rgb(182, 155, 80)":"rgb(173, 199, 131)"};},
			 content:<InputField key="1" fieldName="Kitap Al" inputFields={["E-mail:", "Kitap ID:"]} onClickFunction={this.f}/>
			},

			{index:2,
			 icon:"c",
			 text:"Kitap Kaydet",
			 onClick(){self.setState({contentIndex:2});},
			 style(){return {backgroundColor: this.index===self.state.contentIndex?"rgb(182, 155, 80)":"rgb(173, 199, 131)"};},
			 content:<InputField key="2" fieldName="Kitap Kaydet" inputFields={["ISBN:"]} onClickFunction={this.f}/>
			},

			{index:3,
			 icon:"d",
			 text:"Kitap Sil",
			 onClick(){self.setState({contentIndex:3});},
			 style(){return {backgroundColor: this.index===self.state.contentIndex?"rgb(182, 155, 80)":"rgb(173, 199, 131)"};},
			 content:<InputField key="3" fieldName="Kitap Sil" inputFields={["Kitap ID:"]} onClickFunction={this.f}/>
			},

			{index:4,
			 icon:"e",
			 text:"Kitap Listesi",
			 onClick(){self.setState({contentIndex:4});},
			 style(){return {backgroundColor: this.index===self.state.contentIndex?"rgb(182, 155, 80)":"rgb(173, 199, 131)"};},
			 content:<InputField key="4" fieldName="Burda senin BookList component'in olcak" inputFields={["Önemsiz text:"]} onClickFunction={this.f}/>
			},

			{index:5,
			 icon:"f",
			 text:"Kullanıcı Listesi",
			 onClick(){self.setState({contentIndex:5});},
			 style(){return {backgroundColor: this.index===self.state.contentIndex?"rgb(182, 155, 80)":"rgb(173, 199, 131)"};},
			 content:<InputField key="5" fieldName="Burda senin UserList component'in olcak" inputFields={["Önemsiz text:"]} onClickFunction={this.f}/>
			},

			{index:6,
			 style(){return {"flexGrow":1};}
			},

			{index:7,
			 icon:"g",
			 text:"Çıkış Yap",
			 onClick(){self.setState({contentIndex:7}); /* Burda senin pop fonksiyonunu çağırcaz galiba login'e dönmek için. */},
			 style(){return {backgroundColor: this.index===self.state.contentIndex?"rgb(182, 155, 80)":"rgb(173, 199, 131)"};},
			}
		];
	}

	f(inputs){
		for(let i=0; i<inputs.length; ++i)
			console.log("Input text: "+inputs[i]);
	}

	render(){
		return(
			<div className='wholePage'>
				<div className='sidebar'>
					<ul className='sidebar_ul'>
						{this.items.map((value) =>(
							<li className='sidebar_li' key={value.index} onClick={value.onClick} style={value.style()}>
								<div className="icon">{value.icon}</div>
								<div className="text">{value.text}</div>
							</li>
						))}
					</ul>
				</div>
				<div className='non-sidebar'>
					<div className='content'>
						{this.items[this.state.contentIndex].content}
					</div>
				</div>
			</div>
		);
	}
}

export {MainPage};