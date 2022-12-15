import { useState } from "react";

const Userlist = () => {
    
    const [users, setBooks] = useState([
        { name: '1984', body: 'lorem ipsum...', author: 'mario', id: 1 },
        { title: 'Kurak Günler', body: 'lorem ipsum...', author: 'yoshi', id: 2 },
        { title: 'Rüyaların Yorumu', body: 'lorem ipsum', author: 'Freud', id: 3 }
    ]);
    
    return ( 
        <div>
            <h2>
                Users
            </h2>
        </div>
     );
}
 
export default Userlist;