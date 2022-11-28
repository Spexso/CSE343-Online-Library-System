import React, { useState } from "react";
import LoginForm from './LoginForm';

function App() {
  const adminUser = {
    email: "admin@admin.com",
    password: "admin123"
  }

  const [user, setUser] = useState({email: ""});
  const [error, setError] = useState("");

  const Login = details => {
    console.log(details);

    if(details.email === adminUser.email && details.password === adminUser.password){
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
    console.log("Email and password wrong");
    setError("Wrong email and password");
  }
}

  const Logout = () => {
    console.log("Logout");
    setUser({
      email: "",
    });
    setError("");
  }


  return (
    <div className="App">
      {(user.email !== "") ? (
        <div className="welcome">
          <h2> Welcome, <span> Admin </span></h2>
          <button onClick={Logout}>Logout</button>
        </div>
      ) : (
        <LoginForm Login={Login} error={error} />
      )}
    </div>
  );
}

export default App;
