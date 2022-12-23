import React from "react";
import test from "../assets/book-icon-145.png";

const Board = () => {
    return ( 
        <>
            <div className="board">
                <img src={test} alt="test" />
                <div className="bottom">
                    <h3 className="title">React</h3>
                    <p className="amount">&#8377;3290</p>
                </div>
            </div>
        </>
     );
}
 
export default Board;
<>
    <div className="board">
        <div className="bottom"></div>
    </div>
</>