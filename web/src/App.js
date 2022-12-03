import React, { useState } from "react";
import LoginForm from '../src/components/LoginForm';
import { BrowserRouter as Router, Route, Switch, } from 'react-router-dom';
import { Link } from "react-router-dom"; 
import Loading from "./components/Loading";
import MainPage from './MainPage';

function App() {

  const adminUser = {
    email: "admin@admin.com",
    password: "admin123"
  }


  const [user, setUser] = useState({email: ""});
  const [error, setError] = useState("");

  const Login = details => {
    console.log(details);

    if(details.email === "" && details.password === "" ){
      console.log("Empty Sections");
      setError("E-mail and password are empty");
    }
    else if(details.email === "" ){
      console.log("Empty E-mail");
      setError("E-mail is empty");
    }
    else if(details.password === ""){
      console.log("Empty password");
      setError("Password is empty");
    }
    else if(details.email === adminUser.email && details.password === adminUser.password){
    console.log("Details matched");
    setUser({
      email: details.email,
      password: details.password,
    });
  } else if( details.password === adminUser.password && details.email !== adminUser.email){
    console.log("Email invalid");
    setError("Email is wrong");
  } 
    else if( details.password !== adminUser.password && details.email === adminUser.email){
    console.log("Password invalid");
    setError("Password is wrong");
  }
  else if( details.password !== adminUser.password && details.email !== adminUser.email){
    console.log("Email and password invalid");
    setError("Wrong email and password");
  }
}


  const Logout = () => {
    console.log("Logout");
    setUser({
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
      { (user.email !== "") ? (
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
    
    </Switch>
    </Router>
  
  );
}

export default App;
