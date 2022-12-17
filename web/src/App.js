import React, { useState } from "react";
import LoginForm from '../src/components/LoginForm';
import { BrowserRouter as Router, Route, Switch, } from 'react-router-dom';
import { Link } from "react-router-dom"; 
import Loading from "./components/Loading";
import MainPage from './MainPage';
import Booklist from "./components/Booklist";
import Userlist from "./components/Userlist";

function App() {

  
  const [guest, setGuest] = useState({name: "", password: ""});
  const [error, setError] = useState("");

  const Login = details => {
    console.log(details);

    if(details.name === "" && details.password === "" ){
      console.log("Empty Sections");
      setError("E-mail and password are empty");
    }
    else if(details.name === "" ){
      console.log("Empty E-mail");
      setError("E-mail is empty");
    }
    else if(details.password === ""){
      console.log("Empty password");
      setError("Password is empty");
    }
    else if(details.name === guest.name && details.password === guest.password){
    console.log("Details matched");
    setGuest({
      name: details.name,
      password: details.password,
    });
  } else if( details.password === guest.password && details.name !== guest.name){
    console.log("name invalid");
    setError("name is wrong");
  } 
    else if( details.password !== guest.password && details.name === guest.name){
    console.log("Password invalid");
    setError("Password is wrong");
  }
  else if( details.password !== guest.password && details.name !== guest.name){
    console.log("name and password invalid");
    setError("Wrong name and password");
  }
}


  const Logout = () => {
    console.log("Logout");
    setGuest({
      email: "",
      password: "",
    });
    setError("");
  }

  

  return (

    <Router>
    <Switch>
    
    <Route exact path="/CSE343-Online-Library-System" component={LoginForm}>
    <div className="App">
      { (guest.email !== "") ? (
        <div className="welcome">
          <Link to="/main"> HERE </Link>
          <button onClick={Logout}> Logout </button>
          <h2> Welcome, <span> Admin </span></h2>
          <Loading/>
      </div>
      ) : (
        <LoginForm Login={Login} error={error} />
      ) }
    </div>
    </Route>

    <Route exact path="/main">
      <MainPage/>
    </Route>

    <Route exact path="/bookList">
      <Booklist/>
    </Route>

    <Route exact path="/userlist">
      <Userlist/>
    </Route>
    
    </Switch>
    </Router>
  
  );
}

export default App;
