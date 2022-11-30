import React, { useState } from "react";
import './MainPage.css'

const MainPage = () => {

    const Warn  = useState("MAIN PAGE HERE");

    return (
        <div className="text">
            <h1>
                {Warn}
            </h1>
        </div>
    );
}

export default MainPage;


