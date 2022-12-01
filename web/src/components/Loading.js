import React from "react";
import ReactLoading from 'react-loading';
import '../Loading.css';

export default function Loading() {



    return (
        <div className="loadW">
            <h2> Loading </h2>
            <ReactLoading type="bubbles" color="#0000FF"
            height={100} width={50} />
        </div>
    )
}