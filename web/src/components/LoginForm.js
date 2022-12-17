import React, { useState } from 'react';
import { useHistory } from 'react-router-dom';
import logo from '../assets/books-stack-of-three.png';
import Loading from './Loading';
import '../Loading.css';


function LoginForm({Login, error}) {
    

    const [name, setName] = useState("");
    const [password, setPassword] = useState("");
    const history = useHistory();
    const [isPending, setIsPending] = useState('false');
    

    const submitHandler = e => {
        console.log(name);
        console.log(password);
        setIsPending(true);
        e.preventDefault();
        
            fetch('http://localhost:8080/guest/admin-login', {
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
                console.log(data);

                if(data.message === "name is not registered") 
                {
                    console.log("Invalid name");
                    setIsPending(true);
                }
                else if(data.message === "malformed json input")
                {
                    console.log("Empty string");
                    setIsPending(true);
                }
                else
                {   
                    const token = data.token;
                    console.log("------------");
                    console.log(token);
                    console.log("------------");
                    setIsPending(false);
                    history.push('/main');
                    console.log(data.message);
                }               
            }).catch( err => {
                console.log("Catch here");
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

            {(error !== "") ? ( 
            <div className="error">
                {error}
            </div>
            ) : ""}

            { !isPending && <Loading></Loading> }
            <input type="submit" value="LOGIN" />
            <div className="form-logo">
                <img src={logo} alt="LoginPageLogo"/>
            </div>
        
        </div>
    </form>
  )
}

export default LoginForm
