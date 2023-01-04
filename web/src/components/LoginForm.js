import React, { useState } from 'react';
import { useHistory } from 'react-router-dom';
import logo from '../assets/books-stack-of-three.png';
import './Loading.css';
import './LoginForm.css';


function LoginForm() {
    /*guest/admin-login*/
    const {REACT_APP_API_TOKEN} = process.env;
    const [name, setName] = useState("");
    const [password, setPassword] = useState("");
    const history = useHistory();
    /*const [isPending, setIsPending] = useState('false');*/
    const [error, setError] = useState("");
    

    const submitHandler = e => {
        console.log(name);
        console.log(password);
        e.preventDefault();
        

            fetch(`${REACT_APP_API_TOKEN}/guest/admin-login`, {
                method: 'POST',
                headers: { "Content-Type": "application/json"},
                body: JSON.stringify({
                    name: name,
                    password: password,
                }),
            }).then( res => {   
                return res.json();  
            })
            .then((data) => {
                console.log("Requested login to Server");
                setError("");
                console.log(data);

                if(data.message === "name is not registered") 
                {
                    setError("Invalid Name");
                    console.log("Invalid name");
                }
                else if(data.message === "malformed json input")
                {
                    setError("Missing Information");
                    console.log("Empty string");
                }
                else if(data.message === "password is invalid")
                {
                    setError("Password is invalid");
                    console.log("Empty string");
                }
                else
                {   
                    const token = data.token;
                    console.log("------------");
                    console.log(token);
                    console.log("------------");

                    history.push('/main');
                    console.log(data.message);
                }               
            }).catch( err => {
                setError("Can not reach to server!");
                console.log("Server is offline");
                console.log(err);
            })
            
    }

  return (
    <form onSubmit={submitHandler}>
        <div className="form-inner">
            <div className="Log">
            <h2>Login</h2>
            </div>
            
            <div className="form-group">
                <label htmlFor="name">Name</label>
                <input type="name" name="name" onChange={ (e) => setName(e.target.value)} />
            </div>
            <div className="form-group">
                <label htmlFor="password">Password</label>
                <input type="password" name="password"  onChange={ (e) => setPassword(e.target.value)}  />
            </div>
            <div>
                <h1 className='error' >{error}</h1>
            </div>

            
            <input type="submit" value="LOGIN"/>
            <div className="form-logo">
                <img src={logo} alt="LoginPageLogo"/>
            </div>
            
        </div>
    </form>
  )
}

export default LoginForm;
