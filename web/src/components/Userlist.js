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
    const [regex, setRegex] = useState("");
    const [users, setUsers] = useState([]);

    const searhUsers = async () => {
            const response = await fetch(`${REACT_APP_API_TOKEN}/admin/user-list`, {
                method: 'POST',
                    headers: { 
                        'Content-Type': 'application/json',
                        'Authorization': bearer,
                    },
                    body: JSON.stringify(
                        {
                            "name": regex,
                            "per-page": "20",
                            "page": "1"
                        }
                    )
            });
            const jsonResponse = await response.json();
            setUsers(jsonResponse);
        };
        

    
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
                            "name": regex,
                            "per-page": "20",
                            "page": "1"
                        }
                    )
            });
            const jsonResponse = await response.json();
            setUsers(jsonResponse)
        };
        
        getUsers();
    // eslint-disable-next-line
    }, []);

    return ( 
        <div className="List">
        <p>Users</p> 
                <ul id="L">
                    {
                        users?.map((users,index) => {
                            return <ol type="1">
                            <li class="sub" value={index + 1}>Name: {users.name} <br></br>Surname: {users.surname} <br></br> Email: {users.email} <br></br> Phone: {users.phone}</li>   
                            </ol>    

                        })
                    }
                </ul>
            <br></br>
            <input className="inputUser" type="text" placeholder="Enter User Info" onChange={(e) => setRegex(e.target.value)} onKeyDown={searhUsers} onBlur={searhUsers}></input>
            <br></br>
            <button className="MB" onClick={BackToMain}>Main Page</button>
        </div>
     );
}
 
export default Userlist;