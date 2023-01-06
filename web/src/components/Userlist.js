import { useEffect } from "react";
import { useHistory } from "react-router-dom";
import { useState } from "react";
import './Userlist.css';

const Userlist = () => {
    // eslint-disable-next-line
    const historyN = useHistory();
    const BackToMain = () => historyN.push("/main");
    let token = sessionStorage.getItem("token");
    var bearer = 'Bearer ' + token;
    const {REACT_APP_API_TOKEN} = process.env;
    


    /*const nameList = names.map*/

    const [users, setUsers] = useState([]);
    
    useEffect( () => {
        
        const getUsers = async () => {
            const response = await fetch(`${REACT_APP_API_TOKEN}/admin/user-list`, {
                method: 'POST',
                    headers: { 
                        'Content-Type': 'application/json',
                        'Authorization': bearer,
                    },
                    body: JSON.stringify(
                        {
                            "per-page": "20",
                            "page": "1"
                        }
                    )
            });
            const jsonResponse = await response.json();
            console.log(jsonResponse);
            setUsers(jsonResponse);
        };
        
        getUsers();

    }, []);

    return ( 
        <div className="List">
            <p>Users</p>
                <ul id="L">
                    {
                        users.map((users) => {
                            return <li class="sub">Name: {users.name} <br></br>Surname: {users.surname} <br></br> Email: {users.email} <br></br> Phone: {users.phone}</li>       
                        })
                    }
                </ul>
            <br></br>
            <button className="MB" onClick={BackToMain}>Main Page</button>
        </div>
     );
}
 
export default Userlist;