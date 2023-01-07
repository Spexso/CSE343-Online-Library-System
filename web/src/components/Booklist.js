import { useState } from "react";
import '../components/Booklist.css';
import background from '../assets/book-icon-145.png';
import Board from "./Board";
import { useHistory } from "react-router-dom";

const Booklist = () => {
    // eslint-disable-next-line
    const [search,setSearch]=useState("");
    const [bookData, setBook] = useState([]);
    const historyN = useHistory();
    const {REACT_APP_API_TOKEN} = process.env;

    const BackToMain = () => historyN.push("/main");


    const token = sessionStorage.getItem("token");
    var bearer = 'Bearer ' + token;

    const searchBook=(evt)=> {
        if(evt.key === "Enter")
        {
            
            /*console.log(sessionStorage.getItem("token"));*/
            fetch(`${REACT_APP_API_TOKEN}/admin/isbn-list`, {
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
            }).then( res => {   
                return res.json();  
            })
            .then((data) => {
                console.log(data['isbn-list'])
                setBook(data)
                
            }).catch( err => {
                console.log("False");
            })
            
        }
    }


    return(  
        <>
            <div className="header">
            
                <div className="row1"></div>

                <div className="row2">
                    <h2>Search For Book</h2>
                    <div className="search">
                        <input type="text" placeholder="Enter Information" 
                         value={search} onChange={e=>setSearch(e.target.value)}
                         onKeyDown={searchBook}/>
                        <button><i class="fas fa-search"></i> </button>            
                    </div>
                    <img src={background} alt="Background of Search Page" />
                    <br></br>
                    <button type="button" className="MB" onClick={BackToMain}> Main Page </button>
                </div>

            </div>
        <div className="container">
            {
                <Board books={bookData['isbn-list']} search={search}/>
            }          
        </div>
        </>
    );
}
 
export default Booklist;