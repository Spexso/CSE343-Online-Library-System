import React, { useState } from 'react';
import { InputField } from './InputField';
import './MainPage.css';
import lend from "../assets/lend_book.png";
import ret from "../assets/return_book.png";
import reg from "../assets/register_book.png";
import add from "../assets/add_book.png";
import ext from "../assets/exit.png";
import red from "../assets/redirect.png";
import { useHistory } from 'react-router-dom';

//"http://libware.westeurope.cloudapp.azure.com"

//const REACT_APP_API_TOKEN="http://libware.westeurope.cloudapp.azure.com:8080";
//const REACT_APP_API_TOKEN="http://localhost:8080";
const {REACT_APP_API_TOKEN} = process.env;

/**
 * Parameters
 * (str) token: The token returned by the admin-login
 */
function MainPage(props){

	const historyN = useHistory();

	const [contentIndex, setContentIndex] = useState(0);
	
	const bearer="Bearer "+props.token;

	const userList=()=>{
		historyN.push("/userlist");
	}

	const bookList=()=>{
		historyN.push("/booklist");
	}

	const exit=()=>{
		historyN.push("/CSE343-Online-Library-System");
	}

	function registerBook (bearer, inputs, base64jpg) {
		fetch(`${REACT_APP_API_TOKEN}/admin/isbn-insert`,
			{method:"POST", headers:{"Content-Type":"application/json", "Authorization":bearer},
			body:JSON.stringify({"isbn":inputs[0], "name":inputs[1], "author":inputs[2], "publisher":inputs[3], "publication-year":inputs[4], "class-number":inputs[5], "cutter-number":inputs[6], "picture":base64jpg})
			})
		.then(res => {
			if(res.ok){
				console.log("isbn-insert SUCCESS");
				this.setState({statusMsg:"The book is successfully registered. ✔"});
			}
			else{
				return res.json().then(obj => {
					console.log("isbn-insert FAIL\nKind: %s\nMessage: %s", obj.kind, obj.message)
					switch(obj.kind){
						case "err-base64-decoder": this.setState({statusMsg:"Error: The jpg file couldn't be decoded."}); break;
						case "err-isbn-exist"    : this.setState({statusMsg:"Error: The book is already registered."}); break;
						case "err-json-decoder"  : this.setState({statusMsg:"Error: Inputs are invalid, please check again."}); break;
						case "err-generic"  	 : this.setState({statusMsg:"Error: An Unexpected Error has happened."}); break;
						default: this.setState({statusMsg:"Error: An unexpected error has occured."}); break;
					}
				});
			}
		}, ()=>{console.log("Couldn't reach server. (isbn-insert)"); this.setState({statusMsg:"Error: Couldn't reach server."})});
	}

	function addBook (bearer, inputs) {
		console.log("HERE");
		console.log(inputs);
		console.log("HERE");
		console.log(inputs[0]);
		console.log("HERE");
		fetch(`${REACT_APP_API_TOKEN}/admin/book-add`,
			  {method:"POST", headers:{"Content-Type":"application/json", "Authorization":bearer}, body:JSON.stringify({"isbn":inputs[0]})})
		.then(res => {
			if(res.ok){
				res.json().then(obj => {
					console.log("book-add SUCCESS");
					console.log("The id of the added book is: %d", obj.id);
					this.setState({statusMsg:`The book is registered with the id ${obj.id}. ✔`});
				});
			}
			else{
				res.json().then(obj => {
					console.log("book-add FAIL\nKind: %s\nMessage: %s", obj.kind, obj.message);
					switch(obj.kind){
						case "err-isbn-not-exist": this.setState({statusMsg:"Error: ISBN doesn't exist"}); break;
						case "err-json-decoder"  : this.setState({statusMsg:"Error: Inputs are invalid, please check again."}); break;
						default: this.setState({statusMsg:"Error: An unexpected error has occured."}); break;
					}
				});
			}
		}, ()=>{console.log("Couldn't reach server. (book-add)"); this.setState({statusMsg:"Error: Couldn't reach server."});})
	}

	function bookBorrow (bearer, inputs) {
		fetch(`${REACT_APP_API_TOKEN}/admin/user-id-of-email`, {method:"POST", headers:{"Content-Type":"application/json", "Authorization":bearer}, body:JSON.stringify({"email":inputs[0]})})
		.then((res) => {
			if(res.ok){
				console.log("user-id-of-email SUCCESS");
				res.json().then(obj => {
					fetch(`${REACT_APP_API_TOKEN}/admin/book-borrow`, {method:"POST", headers:{"Content-Type":"application/json", "Authorization":bearer}, body:JSON.stringify({"book-id":inputs[1], "user-id":obj.toString()})})
					.then((res) => {
						if(res.ok){
							console.log("book-borrow SUCCESS");
							this.setState({statusMsg:`The book is lent to the user. ✔`});
						}
						else{
							res.json().then(obj => {
								console.log("book-borrow FAIL\nKind: %s\nMessage: %s", obj.kind, obj.message);
								switch(obj.kind){
									case "err-user-id-not-exist": this.setState({statusMsg:`Error: Id of the user did not found.`}); break;
									case "err-book-id-not-exist": this.setState({statusMsg:`Error: There is no book with the id ${inputs[1]}`}); break;
									case "err-session-not-exist": this.setState({statusMsg:`Error: Session does not exist.`}); break;
									case "err-user-not-present" : this.setState({statusMsg:`Error: User didn't validate his/her request.`}); break;
									case "err-past-due"         : this.setState({statusMsg:`Error: past-due`}); break;
									case "err-book-has-borrower": this.setState({statusMsg:`Error: Book is already borrowed.`}); break;
									case "err-user-not-eligible": this.setState({statusMsg:`Error: User is not eligible to borrow.`}); break;
									case "err-user-not-in-queue": this.setState({statusMsg:`Error: User is not in the queue.`}); break;
									case "err-json-decoder"     : this.setState({statusMsg:"Error: Inputs are invalid, please check again."}); break;
									default:this.setState({statusMsg:`Error: An unexpected error has occured.`}); break;
							}
						})
						}
					}, ()=>{console.log("Couldn't reach server. (book-borrow)"); this.setState({statusMsg:"Error: Couldn't reach server."});})
				});
			}
			else{
				res.json().then(obj => {
					console.log("user-id-of-email FAIL\nKind: %s\nMessage: %s", obj.kind, obj.message);
					switch(obj.kind){
						case "err-email-not-exist":this.setState({statusMsg:`Error: There is no user with the e-mail ${inputs[0]}`}); break;
						case "err-json-decoder"   : this.setState({statusMsg:"Error: Inputs are invalid, please check again."}); break;
						default:this.setState({statusMsg:`Error: An unexpected error has occured.`}); break;
					}
				});
			}
		}, ()=>{console.log("Couldn't reach server. (user-id-of-email)"); this.setState({statusMsg:"Error: Couldn't reach server."});})
	}

	function bookReturn (bearer, inputs) {
		fetch(`${REACT_APP_API_TOKEN}/admin/user-id-of-email`, {method:"POST", headers:{"Content-Type":"application/json", "Authorization":bearer}, body:JSON.stringify({"email":inputs[0]})})
		.then((res) => {
			if(res.ok){
				console.log("user-id-of-email SUCCESS");
				res.json().then(obj => {
					fetch(`${REACT_APP_API_TOKEN}/admin/book-return`, {method:"POST", headers:{"Content-Type":"application/json", "Authorization":bearer}, body:JSON.stringify({"book-id":inputs[1], "user-id":obj.toString()})})
					.then((res) => {
						if(res.ok){
							console.log("book-return SUCCESS");
							this.setState({statusMsg:`The book returned to the library. ✔`});
						}
						else{
							res.json().then(obj => { 
								console.log("book-return FAIL\nKind: %s\nMessage: %s", obj.kind, obj.message);
								switch(obj.kind){
									case "err-user-id-not-exist"   :this.setState({statusMsg:`Error: Id of the user did not found.`}); break;
									case "err-book-id-not-exist"   :this.setState({statusMsg:`Error: There is no book with the id ${inputs[1]}`}); break;
									case "err-book-has-no-borrower":this.setState({statusMsg:`Error: Book is not currently borrowed by anybody.`}); break;
									case "err-user-not-borrower"   :this.setState({statusMsg:`Error: User is not the borrower of the book.`}); break;
									case "err-json-decoder"        : this.setState({statusMsg:"Error: Inputs are invalid, please check again."}); break;
									default:this.setState({statusMsg:`Error: An unexpected error has occured.`}); break;
							}
						})
					}
					}, ()=>{console.log("Couldn't reach server. (book-return)"); this.setState({statusMsg:"Error: Couldn't reach server."});})
				})
			}
			else{
				res.json().then(obj => {
					console.log("user-id-of-email FAIL\nKind: %s\nMessage: %s", obj.kind, obj.message);
					switch(obj.kind){
						case "err-email-not-exist":this.setState({statusMsg:`Error: There is no user with the e-mail ${inputs[0]}`}); break;
						case "err-json-decoder"   : this.setState({statusMsg:"Error: Inputs are invalid, please check again."}); break;
						default:this.setState({statusMsg:`Error: An unexpected error has occured.`}); break;
					}
				});
			}
		}, ()=>{console.log("Couldn't reach server. (user-id-of-email)"); this.setState({statusMsg:"Error: Couldn't reach server."});});
	}

	const items=[
		{index:0,
		sb_icon:<img src={lend} alt="lend_icon" height="40px" width="40px"/>,
		sb_text:"Lend Book",
		sb_onClick(){setContentIndex(0);},
		style(){return { cursor:"pointer"};},

		content:<InputField key="0" bearer={bearer} fieldName="Lend Book" inputFields={["E-mail:", "Book ID:"]} onClickFunction={bookBorrow}/>
		},

		{index:1,
		sb_icon:<img src={ret} alt="ret_icon" height="40px" width="40px"/>,
		sb_text:"Return Book",
		sb_onClick(){setContentIndex(1);},
		style(){return {cursor:"pointer"};},

		content:<InputField key="1" bearer={bearer} fieldName="Return Book" inputFields={["E-mail:", "Book ID:"]} onClickFunction={bookReturn}/>
		},

		{index:2,
		sb_icon:<img src={reg} alt="reg_icon" height="40px" width="40px"/>,
		sb_text:"Register Book",
		sb_onClick(){setContentIndex(2);},
		style(){return {cursor:"pointer"};},

		content:<InputField key="2" bearer={bearer} fieldName="Register Book" inputFields={["ISBN:", "Name:", "Author:", "Publisher:", "Publication Year:", "Class Number:", "Cutter Number:"]} pic={true} onClickFunction={registerBook}/>
		},

		{index:3,
		sb_icon:<img src={add} alt="add_icon" height="40px" width="40px"/>,
		sb_text:"Add Book",
		sb_onClick(){setContentIndex(3);},
		style(){return { cursor:"pointer"};},

		content:<InputField key="3" bearer={bearer} fieldName="Add Book" inputFields={["ISBN:"]} onClickFunction={addBook}/>
		},

		{index:4,
		style(){return {"flexGrow":1};}
		},

		{index:5,
		sb_icon:<img src={ext} alt="exit_icon" height="40px" width="40px"/>,
		sb_text:"Exit",
		sb_onClick(){setContentIndex(5); exit();},
		style(){return {cursor:"pointer"};},
		}
	];

	return(
		<div className='wholePage'>
			<div className='sidebar'>
				<ul className='sidebar_ul'>
					{items.map((value) =>(
						<li className='sidebar_li' key={value.index} onClick={value.sb_onClick} style={value.style()}>
							<div className="icon">{value.sb_icon}</div>
							<div className="text">{value.sb_text}</div>
						</li>
					))}
				</ul>
			</div>
			<div className='non-sidebar'>
				<div className='redirection_area'>
					<div className='side_space'></div>
					<div className='redirect_div' onClick={userList}>
						<div className='red_text'>User List</div>
						<img className='red_icon' src={red} alt="rdr_icon" height="40px" width="40px"/>
					</div>
					<div className='middle_space'></div>
					<div className='redirect_div' onClick={bookList}>
						<div className='red_text'>Book List</div>
						<img className='red_icon' src={red} alt="rdr_icon" height="40px" width="40px"/>
					</div>
					<div className='side_space'></div>
				</div>
				<div className='content_area'>
					{items[contentIndex].content}
				</div>
			</div>
		</div>
	);
}

export default MainPage;