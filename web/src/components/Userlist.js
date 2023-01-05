import { useState } from "react";

const Userlist = () => {
    // eslint-disable-next-line
    const [users, setUsers] = useState([
        { name: 'Mario', body: 'student', author: 'mario', id: 1 },
        { name: 'Kurak Günler', body: 'teacher', author: 'yoshi', id: 2 },
        { name: 'Rüyaların Yorumu', body: 'student', author: 'Freud', id: 3 }
    ]);
    
    let data = sessionStorage.getItem("token");

    return ( 
        <div className="Users">
            <h2>
                {users.map((users) => (
                <div className="user-display" key={users.id}>
                    <h2>{ users.name }</h2>
                    <h2>{ users.body }</h2>
                    
                </div>
                ))}
            </h2>
            <h2>{data}ANAN</h2>
        </div>
     );
}
 
export default Userlist;