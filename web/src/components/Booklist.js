import { useState } from "react";
import '../components/Booklist.css';
import background from '../assets/book-icon-145.png';
import Board from "./Board";

const Booklist = () => {
    // eslint-disable-next-line
    const [books, setBooks] = useState([
        { title: '1984', body: 'lorem ipsum...', author: 'mario', id: 1 },
        { title: 'Kurak Günler', body: 'lorem ipsum...', author: 'yoshi', id: 2 },
        { title: 'Rüyaların Yorumu', body: 'lorem ipsum', author: 'Freud', id: 3 }
    ]);
    

    return(  
        <>
            <div className="header">
            
                <div className="row1"></div>

                <div className="row2">
                    <h2>Search for book</h2>
                    <div className="search">
                        <input type="text" placeholder="Enter Information" />
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