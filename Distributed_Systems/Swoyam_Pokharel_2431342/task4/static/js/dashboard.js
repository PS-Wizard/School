import { initializeApp } from "https://www.gstatic.com/firebasejs/11.7.1/firebase-app.js";
import {
    getAuth,
    onAuthStateChanged
} from "https://www.gstatic.com/firebasejs/11.7.1/firebase-auth.js";
import {
    getFirestore,
    collection,
    addDoc,
    query,
    where,
    getDocs,
    serverTimestamp,
    doc,
    updateDoc,
    deleteDoc
} from "https://www.gstatic.com/firebasejs/11.7.1/firebase-firestore.js";

const firebaseConfig = {
    apiKey: "AIzaSyCkpwa8hE-wMEK2ZYnTqcZOoDDU9saV0Sk",
    authDomain: "swoyam-pokharel-2431342-a26cd.firebaseapp.com",
    projectId: "swoyam-pokharel-2431342-a26cd",
    storageBucket: "swoyam-pokharel-2431342-a26cd.firebasestorage.app",
    messagingSenderId: "81012309295",
    appId: "1:81012309295:web:eef1c4daa68bb4749bf5da"
};

const app = initializeApp(firebaseConfig);
const auth = getAuth();
const db = getFirestore();

let currentUser = null;
let movies = [];

onAuthStateChanged(auth, async (user) => {
    if (!user) {
        window.location.href = "/login.html";
        return;
    }
    currentUser = user;
    fetchMovies();
});

async function fetchMovies() {
    const q = query(collection(db, "Movie_DB"), where("ownerId", "==", currentUser.uid));
    const snapshot = await getDocs(q);

    movies = [];
    snapshot.forEach(doc => {
        movies.push({ id: doc.id, ...doc.data() });
    });
    renderMovies(movies);
}

function renderMovies(list) {
    const tbody = document.getElementById("movies-body");
    if (!tbody) return;

    tbody.innerHTML = list.map(movie => `
        <tr data-id="${movie.id}" class="row-animation">
            <td id="table-row-animation">${movie.id}</td>
            <td id="table-row-animation">${movie.movieName}</td>
            <td id="table-row-animation">${movie.movieRating || ""}</td>
            <td id="table-row-animation">${movie.movieDirectors?.join(", ") || ""}</td>
            <td id="table-row-animation">${movie.movieRelease || ""}</td>
            <td id="table-row-animation">${movie.movieGenre?.join(", ") || ""}</td>
            <td id="table-row-animation" class="max-w-xs whitespace-normal">${movie.movieDescription || ""}</td>
            <td id="table-row-animation"><img src="${movie.moviePoster}" class="w-16" /></td>
            <td id="table-row-animation">
                <button class="btn btn-sm btn-primary edit-btn">Edit</button>
                <button class="btn btn-ghost delete-btn">Delete</button>
            </td>
        </tr>
    `).join("");

    gsap.from(gsap.utils.toArray("#table-row-animation"), {
        y: -10,
        opacity: 0,
        stagger: 0.01,
        delay: 0.3,
        duration: 0.6,
        ease: "power2.out"
    });
}

window.createMovie = async function () {
    const name = document.getElementById("newMovieName").value;
    const desc = document.getElementById("newDescription").value;
    const genre = document.getElementById("newGenre").value.split(",").map(s => s.trim());
    const directors = document.getElementById("newDirectors").value.split(",").map(s => s.trim());
    const release = document.getElementById("newReleaseDate").value;
    const rating = parseFloat(document.getElementById("newRating").value);
    const posterFile = document.getElementById("newPoster").files[0];

    if (!posterFile) return alert("Please upload a poster!");
    if (rating < 1 || rating > 5) return alert("Please Enter Rating Between 1 and 5");

    try {
        const posterURL = await uploadToS3(posterFile);
        await addDoc(collection(db, "Movie_DB"), {
            movieName: name,
            movieDescription: desc,
            movieGenre: genre,
            movieDirectors: directors,
            movieRelease: release,
            movieRating: rating,
            moviePoster: posterURL,
            ownerId: currentUser.uid,
            createdAt: serverTimestamp()
        });

        document.getElementById("new_movie_modal").close();
        fetchMovies();
    } catch (err) {
        alert("Error creating movie: " + err.message);
    }
};

window.updateMovie = async function (docId) {
    const name = document.getElementById("editMovieName").value;
    const desc = document.getElementById("editDescription").value;
    const genre = document.getElementById("editGenre").value.split(",").map(s => s.trim());
    const directors = document.getElementById("editDirectors").value.split(",").map(s => s.trim());
    const release = document.getElementById("editReleaseDate").value;
    const rating = parseFloat(document.getElementById("editRating").value);
    const posterFile = document.getElementById("editPoster").files[0];

    if (rating < 1 || rating > 5) return alert("Please Enter Rating Between 1 and 5");

    const updateData = {
        movieName: name,
        movieDescription: desc,
        movieGenre: genre,
        movieDirectors: directors,
        movieRelease: release,
        movieRating: rating
    };

    try {
        if (posterFile) {
            const posterURL = await uploadToS3(posterFile);
            updateData.moviePoster = posterURL;
        }

        await updateDoc(doc(db, "Movie_DB", docId), updateData);
        document.getElementById("edit_movie_modal").close();
        fetchMovies();
    } catch (err) {
        alert("Error updating movie: " + err.message);
        console.log(err);
    }
};

async function deleteMovie(movieId) {
    const confirmed = confirm("Are you sure you want to delete this movie?");
    if (!confirmed) return;

    try {
        await deleteDoc(doc(db, "Movie_DB", movieId));
        fetchMovies();
    } catch (err) {
        alert("Error deleting movie: " + err.message);
    }
}

document.getElementById("movies-body")?.addEventListener("click", async (e) => {
    const row = e.target.closest("tr");
    const movieId = row?.dataset.id;
    const movie = movies.find(m => m.id === movieId);

    if (e.target.classList.contains("edit-btn") && movie) {
        const modal = document.getElementById("edit_movie_modal");

        document.getElementById("editMovieName").value = movie.movieName;
        document.getElementById("editDescription").value = movie.movieDescription;
        document.getElementById("editGenre").value = movie.movieGenre?.join(", ") || "";
        document.getElementById("editDirectors").value = movie.movieDirectors?.join(", ") || "";
        document.getElementById("editReleaseDate").value = movie.movieRelease;
        document.getElementById("editRating").value = movie.movieRating;

        modal.showModal();

        document.getElementById("editConfirmBtn").onclick = () => updateMovie(movieId);
    }

    if (e.target.classList.contains("delete-btn")) {
        await deleteMovie(movieId);
    }
});

window.filterMovies = () => {
    const term = document
        .querySelector('input[placeholder="Search Movies"]')
        .value
        .toLowerCase();
    const sort = document.getElementById('sort-options').value;

    let filtered = movies.filter(m =>
        m.movieName.toLowerCase().includes(term)
    );

    if (sort) {
        const [field, dir] = sort.split('_'); 
        filtered.sort((a, b) => {
            if (field === 'rating') {
                return dir === 'asc'
                    ? (a.movieRating || 0) - (b.movieRating || 0)
                    : (b.movieRating || 0) - (a.movieRating || 0);
            }
            if (field === 'release') {
                return dir === 'asc'
                    ? new Date(a.movieRelease) - new Date(b.movieRelease)
                    : new Date(b.movieRelease) - new Date(a.movieRelease);
            }
            return 0;
        });
    }

    renderMovies(filtered);
};

async function uploadToS3(file) {
    const timestamp = Date.now();
    const fileName = encodeURIComponent(`${timestamp}_${file.name}`);
    const uploadUrl = `https://swoyam-pokharel-2431342-movie.s3.amazonaws.com/${fileName}`;

    const res = await fetch(uploadUrl, {
        method: "PUT",
        headers: {
            "Content-Type": file.type
        },
        body: file
    });

    if (!res.ok) throw new Error("Upload failed");

    return uploadUrl;
}

