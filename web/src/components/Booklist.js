import { useState } from "react";
import '../components/Booklist.css';
import background from '../assets/book-icon-145.png';
import Board from "./Board";

const Booklist = () => {
    // eslint-disable-next-line
    const [search,setSearch]=useState("");
    const {REACT_APP_API_TOKEN} = process.env; 
    const searchBook=(evt)=> {
        if(evt.key === "Enter")
        {
            console.log("Test");
            /*fetch(`${REACT_APP_API_TOKEN}/guest/admin-login`, {
                method: 'POST',
                headers: { "Content-Type": "application/json"},
                body: JSON.stringify({
                    name: "bla",
                    password: "bla",
                }),
            }).then( res =>console.log(res))
              .catch(err=>console.log(err))
            */
        }
    }
    /*const [books, setBooks] = useState([
        { title: '1984', body: 'lorem ipsum...', author: 'mario', id: 1 },
        { title: 'Kurak Günler', body: 'lorem ipsum...', author: 'yoshi', id: 2 },
        { title: 'Rüyaların Yorumu', body: 'lorem ipsum', author: 'Freud', id: 3 }
    ]);
    */

    return(  
        <>
            <div className="header">
            
                <div className="row1"></div>

                <div className="row2">
                    <h2>Search for book</h2>
                    <div className="search">
                        <input type="text" placeholder="Enter Information" 
                         value={search} onChange={e=>setSearch(e.target.value)}
                         onKeyDown={searchBook}/>
                        <button><i class="fas fa-search"></i> </button>
                    </div>
                    <img src={background} alt="Background of Search Page" />
                </div>

            </div>
        <div className="container">
            <Board/>
            <Board/>
            <Board/>
            <Board/>
            <Board/>
            <Board/>
            <Board/>
            <Board/>
            <Board/>
        </div>
        </>
    );
}
 
export default Booklist;