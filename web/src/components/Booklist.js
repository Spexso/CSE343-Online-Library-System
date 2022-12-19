import { useState } from "react";

const Booklist = () => {
    // eslint-disable-next-line
    const [books, setBooks] = useState([
        { title: '1984', body: 'lorem ipsum...', author: 'mario', id: 1 },
        { title: 'Kurak Günler', body: 'lorem ipsum...', author: 'yoshi', id: 2 },
        { title: 'Rüyaların Yorumu', body: 'lorem ipsum', author: 'Freud', id: 3 }
    ]);

    return(  
        <div className="Books">
            <h2>
                {books.map((books) => (
                    <div className="book-display" key={books.id}>
                        <h2> { books.title }</h2>
                        <h2> { books.body  }</h2>
                        <p> Written By { books.author}</p>
                    </div>
                ))}
            </h2>
        </div>
    );
}
 
export default Booklist;