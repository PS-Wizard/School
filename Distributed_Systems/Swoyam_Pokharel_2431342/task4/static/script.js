import { initializeApp} from "https://www.gstatic.com/firebasejs/11.7.1/firebase-app.js";
import {getFirestore , collection, doc, getDocs, addDoc, updateDoc, deleteDoc,  Timestamp} from 'https://www.gstatic.com/firebasejs/11.7.1/firebase-firestore.js'


const firebaseConfig = {
    apiKey: "AIzaSyArjiO-_4w_X7HGdNyhPilYWd0qeLjbbzU",
    authDomain: "swoyam-pokharel-2431342.firebaseapp.com",
    projectId: "swoyam-pokharel-2431342",
    storageBucket: "swoyam-pokharel-2431342.firebasestorage.app",
    messagingSenderId: "600290624989",
    appId: "1:600290624989:web:7cade8f54135d672d72234"
};

const app = initializeApp(firebaseConfig);
const db = getFirestore();
let movies = []
let currentSort = null;

async function fetchMovies(){
    try {
        const query = await getDocs(collection(db,"Movie_DB"));
        movies = []
        query.forEach(movie => {
            movies.push({ id: movie.id, ...movie.data() });
        });
        sortAndRenderMovies();
    }catch (err){
        alert("Failed to fetch movies: ",err);
    }
}

function renderMovies(moviesArray) {
    const tbody = document.getElementById('movies-body');
    tbody.innerHTML = moviesArray.map(movie => `
        <tr data-movie-id="${movie.id}">
            <td>${movie.id}</td>
            <td>${movie.movieName}</td>
            <td>${movie.rating}</td>
            <td>${movie.director}</td>
            <td>${formatDate(movie.releaseDate)}</td>
            <td class="flex gap-2">
                <button class="btn btn-sm btn-ghost edit-btn">Edit</button>
                <button class="btn btn-sm text-white btn-error delete-btn">Delete</button>
            </td>
        </tr>
    `).join('');
}


function formatDate(timestamp) {
    if (!timestamp) return 'N/A';
    const date = timestamp.toDate();
    return date.toLocaleDateString();
}

function toDateInputValue(date) {
    return new Date(date).toISOString().split('T')[0];
}

document.querySelector('input[placeholder="Search Movies"]').addEventListener('input', (e) => {
    const term = e.target.value.toLowerCase();
    const filtered = movies.filter(movie =>
        movie.movieName.toLowerCase().includes(term) ||
        movie.director.toLowerCase().includes(term)
    );
    renderMovies(filtered);
});

document.getElementById('movies-body').addEventListener('click', async (e) => {
    const movieId = e.target.closest('tr')?.dataset.movieId;
    const movie = movies.find(m => m.id === movieId);

    if (e.target.closest('.edit-btn') && movie) {
        const modal = document.getElementById('edit_movie_modal');
        modal.querySelector('input[placeholder="Movie Name"]').value = movie.movieName;
        modal.querySelector('input[placeholder="Movie Rating"]').value = movie.rating;
        modal.querySelector('input[placeholder="Movie Director/s"]').value = movie.director;
        modal.querySelector('input[type="date"]').value = toDateInputValue(movie.releaseDate.toDate());

        modal.showModal();

        modal.querySelector('.btn-primary').onclick = async () => {
            await updateMovie(movieId,
                modal.querySelector('input[placeholder="Movie Name"]').value,
                parseInt(modal.querySelector('input[placeholder="Movie Rating"]').value),
                modal.querySelector('input[placeholder="Movie Director/s"]').value,
                modal.querySelector('input[type="date"]').value
            );
            modal.close();
            clearModalForm('edit_movie_modal'); 
        };
    }
    else if (e.target.closest('.delete-btn') && movieId) {
        if (confirm('Delete this movie permanently?')) {
            await deleteMovie(movieId);
        }
    }
});


document.querySelector('#new_movie_modal .btn-primary').addEventListener('click', async () => {
    const modal = document.getElementById('new_movie_modal');
    await addMovie(
        modal.querySelector('input[placeholder="Movie Name"]').value,
        parseInt(modal.querySelector('input[placeholder="Movie Rating"]').value),
        modal.querySelector('input[placeholder="Movie Director/s"]').value,
        modal.querySelector('input[type="date"]').value
    );
    modal.close();
    clearModalForm('new_movie_modal'); 
});


async function addMovie(movieName, rating, director, releaseDate){

    if (rating > 5 || rating < 0) {
        alert ("Invalid Rating, Please Stay Within The Range Of 0 - 5");
        return;
    }

    try {
        const releaseDateObject = new Date(releaseDate);
        const releaseTimeStamp = Timestamp.fromDate(releaseDateObject);

        const newMovieReference = await addDoc(collection(db,"Movie_DB"),{
            movieName: movieName,
            rating: rating,
            director: director,
            releaseDate: releaseTimeStamp
        });
        alert("New Movie Added", newMovieReference.id);
        fetchMovies();
    } catch (err){
        console.error("Failed To Create New Movie: ",err);
    }
}

async function updateMovie(movieId, movieName, rating, director, releaseDate) {

    if (rating > 5 || rating < 0) {
        alert ("Invalid Rating, Please Stay Within The Range Of 0 - 5");
        return;
    }

    try {
        const movieRef = doc(db, "Movie_DB", movieId);
        const releaseDateObj = new Date(releaseDate);
        const releaseDateTimestamp = Timestamp.fromDate(releaseDateObj);

        await updateDoc(movieRef, {
            movieName: movieName,
            rating: rating,
            director: director,
            releaseDate: releaseDateTimestamp
        });

        alert("Movie updated successfully!");
        fetchMovies();
    } catch (err) {
        console.error("Error updating movie: ", err);
    }
}

async function deleteMovie(movieId) {
    try {
        const movieRef = doc(db, "Movie_DB", movieId);
        await deleteDoc(movieRef);
        alert("Movie deleted successfully!");
        fetchMovies();
    } catch (err) {
        console.error("Error deleting movie: ", err);
    }
}

function sortMovies(sortBy) {
    switch (sortBy) {
        case 'rating_asc':
            movies.sort((a, b) => a.rating - b.rating);
            break;
        case 'rating_desc':
            movies.sort((a, b) => b.rating - a.rating);
            break;
        case 'release_asc':
            movies.sort((a, b) => a.releaseDate.toDate().getTime() - b.releaseDate.toDate().getTime());
            break;
        case 'release_desc':
            movies.sort((a, b) => b.releaseDate.toDate().getTime() - a.releaseDate.toDate().getTime());
            break;
        default:
            break;
    }
    currentSort = sortBy;
    renderMovies(movies);
}

function sortAndRenderMovies() {
    if (currentSort) {
        sortMovies(currentSort);
    } else {
        renderMovies(movies);
    }
}

document.querySelector('.filter-button').addEventListener('click', () => {
    const sortBy = document.getElementById('sort-options').value;
    sortMovies(sortBy);
});

function clearModalForm(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
        const inputs = modal.querySelectorAll('input');
        inputs.forEach(input => {
            input.value = '';
        });
    }
}


fetchMovies();
