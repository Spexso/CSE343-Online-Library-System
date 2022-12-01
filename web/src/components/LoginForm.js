import React, { useState } from 'react';
import { useHistory } from 'react-router-dom';
import logo from '../assets/books-stack-of-three.png';
import Loading from './Loading';
import '../Loading.css';


function LoginForm({Login, error}) {
    
    const history = useHistory();
    const [details, setDetails] = useState({email: "", password: ""});
    const [isPending, setIsPending] = useState('false');
    

    const submitHandler = e => {
        e.preventDefault();
        
        setIsPending(true);

        Login(details);
        
        if(details.email === "admin@admin.com" && details.password === "admin123")
        {
            fetch('http://localhost:8080/guest/admin-login', {
                method: 'POST',
                headers: { "Content-Type": "application/json"},
                body: JSON.stringify({
                    name: details.email,
                    password: details.password,
                }),
            }).then(() => {
                console.log("Details sent to Server");
                setIsPending(false);
            })
            history.push('/main');
        }
    }

  return (
    <form onSubmit={submitHandler}>
        <div className="form-inner">
            <div className="Log">
            <h2>Login</h2>
            </div>
            
            <div className="form-group">
                <label htmlFor="email">Email</label>
                <input type="email" name="email" id="email" onChange={e => setDetails({...details, email: e.target.value})} value={details.email}/>
            </div>
            <div className="form-group">
                <label htmlFor="password">Password</label>
                <input type="password" name="password" id="password" onChange={e => setDetails({...details, password: e.target.value})} value={details.password} />
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
