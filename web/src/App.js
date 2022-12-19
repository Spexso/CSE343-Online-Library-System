import LoginForm from '../src/components/LoginForm';
import { BrowserRouter as Router, Route, Switch, } from 'react-router-dom';
import MainPage from './MainPage';
import Booklist from "./components/Booklist";
import Userlist from "./components/Userlist";

function App() {
  
  /*const [guest, setGuest] = useState({name: "", password: ""}); */

  /*const Logout = () => {
    console.log("Logout");
    setGuest({
      email: "",
      password: "",
    });
    setError("");
  }
  */
  

  return (

    <Router>
    <Switch>
    
    <Route exact path="/CSE343-Online-Library-System" component={LoginForm}>
    <div className="App">
        <LoginForm/>
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
