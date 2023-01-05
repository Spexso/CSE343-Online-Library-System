import React from "react";
import { useState } from "react";
import PopBook from "./popBook";

const Board = ({book, search}) => {
    console.log(book);
    console.log(search);

    const [show, setShow] = useState(false);
    const [bookItem,setItem] = useState();
    return ( 
        <>
            {
                book.map(item => {
                    if(item.name === search || item["publication-year"] === search || item.author === search || item.publisher === search)
                    {
                        return(
                        <>
                        <div className="board" onClick={()=>{setShow(true);setItem(item)}}>
                            <div className="bottom">
                                <h3 className="title">{item.name}</h3>
                                <p className="author">{item.author}</p>
                                <p className="year">{item["publication-year"]}</p>
                                <p className="publisher">{item.publisher}</p>
                            </div>
                        </div> 
                        <PopBook show={show} item={bookItem} onClose={() => setShow(false)}/>
                        </>
                        )
                    }
                     return null;
                })
            }    
        </>
     );
}
 
export default Board;
<>
    <div className="board">
        <div className="bottom"></div>
    </div>
</>