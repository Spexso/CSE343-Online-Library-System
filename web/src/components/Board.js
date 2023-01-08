import React from "react";
import { useState } from "react";
import PopBook from "./popBook";


const Board = ({books, search, status}) => {
    
    const [show, setShow] = useState(false);
    const [bookItem,setItem] = useState();

    return ( 
        <>
            {
                books?.map(item => {
                    if(status)
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