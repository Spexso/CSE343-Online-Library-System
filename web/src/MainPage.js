import React from "react";
import './components/Sidebar'
import { Sidebar } from "./components/Sidebar";

const MainPage = () => {


    return (
        <div className="text">
            <h1>
            <Sidebar></Sidebar>
            </h1>
        </div>
    );
}

export default MainPage;


