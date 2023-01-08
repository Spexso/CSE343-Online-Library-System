import LoginForm from '../src/components/LoginForm';
import { BrowserRouter as Router, Route, Switch, } from 'react-router-dom';
import { MainPage } from './components/MainPage';
import { Redirect } from 'react-router-dom';
import { useState } from 'react';
import Booklist from "./components/Booklist";
import Userlist from "./components/Userlist";
import './App.css';

function App() {
  
  const [LoginStatus, setLStatus] = useState("");
  // eslint-disable-next-line
  const [token, setT] = useState("");

  const getToken = (dataToken) => {
    setT(dataToken);
    sessionStorage.setItem("token", dataToken);
   };
 
  const getLoginStatus = (dataLogin) => {
   setLStatus(dataLogin);
  };

  return (

    <Router>
    <Switch>

      

    <Route exact path="/CSE343-Online-Library-System" >
    <div className="App">
        <LoginForm getLoginV={getLoginStatus} getTokenV={getToken} />
    </div>
    </Route>

    <Route exact path="/main"  render = {() => (LoginStatus==="true" ?  (<MainPage />) : (<Redirect to="/CSE343-Online-Library-System" />))}/>

    <Route exact path="/booklist"  render = {() => (LoginStatus==="true" ?  (<Booklist />) : (<Redirect to="/CSE343-Online-Library-System" />))}/>

    <Route exact path="/userlist"  render = {() => (LoginStatus==="true" ?  (<Userlist />) : (<Redirect to="/CSE343-Online-Library-System" />))}/>
    
    <Route path="*"  render = {() => (LoginStatus==="true" ?  (<LoginForm />) : (<Redirect to="/CSE343-Online-Library-System" />))}/>

    </Switch>
    </Router>
  
  );
}

export default App;
