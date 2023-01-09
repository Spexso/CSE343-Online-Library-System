import { useEffect } from "react";
import { useHistory } from "react-router-dom";
import { useState } from "react";
import { HiUsers } from "react-icons/hi";
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
        <div className="input-icons">
        <HiUsers className="IconU"/>
        <input className="inputUser" type="text" placeholder="Enter User Name" onChange={(e) => setRegex(e.target.value)} onKeyDown={searhUsers} onBlur={searhUsers}></input>
        </div>
        <br/>
        <br/>
        <button className="MB" onClick={BackToMain}>Main Page</button>
                <ul id="L">
                    {
                        users?.map((users,index) => {
                            return <ol type="1">
                            <li class="sub" value={index + 1}>Name: {users.name} <br></br>Surname: {users.surname} <br></br> Email: {users.email} <br></br> Phone: {users.phone}</li>   
                            </ol>    

                        })
                    }
                </ul>
        </div>
     );
}
 
export default Userlist;