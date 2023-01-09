import './popBook.css';

const popBook = ({show, item, onClose}) => {
    if(!show)
    {
        return null;
    }

    var img = `data:image/jpeg;base64, ${item.picture}`

    return (
        <>
            <div className='overlay'>
                <div className='overlay-inner'>
                    <button className='close'><i class="fas fa-times" onClick={onClose}></i></button>
                    <div className="inner-box">
                        <img alt='' src={img}/>
                        <div className="info">
                            <div className='Name'>Name: </div>
                            <div>{item.name}</div><br/>
                            <div className='Name'>ISBN: </div>
                            <div >{item.isbn}</div><br/>
                            <div className='Name'>Author: </div>
                            <div >{item.author}</div><br/>
                            <div className='Name'>Publisher: </div>
                            <div>{item.publisher}</div><br/>
                            <div className='Name'>Class-number: </div>
                            <div >{item["class-number"]}</div><br/>
                            <div className='Name'>Cutter-number: </div>
                            <div >{item["cutter-number"]}</div><br/>
                            <div className='Name'>Publication-year: </div>
                            <div ><span>{item["publication-year"]}</span></div><br/>
                        </div>
                    </div>
                </div>
            </div>
        </>
    )
}
export default popBook;