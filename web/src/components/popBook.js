import './popBook.css';
import icon from '../assets/book.png'

const popBook = ({show, item, onClose}) => {
    if(!show)
    {
        return null;
    }
    return (
        <>
            <div className='overlay'>
                <div className='overlay-inner'>
                    <button className='close'><i class="fas fa-times" onClick={onClose}></i></button>
                    <div className="inner-box">
                        <img src={icon} alt='' />
                        <div className="info">
                            <h1>Name: {item.name}</h1>
                            <h3>ISBN: {item.isbn}</h3>
                            <h2>Author: {item.author}</h2>
                            <h2>Publisher: {item.publisher}</h2>
                            <h2>Class-number: {item["class-number"]}</h2>
                            <h2>Cutter-number: {item["cutter-number"]}</h2>
                            <h4><span>Date: {item["publication-year"]}</span></h4><br/>
                        </div>
                    </div>
                </div>
            </div>
        </>
    )
}
export default popBook;