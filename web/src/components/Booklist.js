import { useState } from "react";
import '../components/Booklist.css';
import background from '../assets/book-icon-145.png';
import Board from "./Board";
import { useHistory } from "react-router-dom";

const Booklist = () => {
    // eslint-disable-next-line
    const [search,setSearch]=useState("");
    const [bookDatas, setBooks] = useState([]);
    const historyN = useHistory();
    const [status, setStatus]=useState(false);
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
                console.log("H")
                console.log(res)
                console.log("H")
                return res.json();  
            })
            .then((data) => {
                console.log(data['isbn-list'])
                setBooks(data['isbn-list'])
                setStatus(true)       
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
                <Board books={bookDatas} search={search} status={status}/>
            }          
        </div>
        </>
    );
}
 
export default Booklist;