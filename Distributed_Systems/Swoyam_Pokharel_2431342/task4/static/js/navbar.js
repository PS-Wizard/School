import { initializeApp } from "https://www.gstatic.com/firebasejs/11.7.1/firebase-app.js";
import {
    getAuth,
    onAuthStateChanged
} from "https://www.gstatic.com/firebasejs/11.7.1/firebase-auth.js";


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

function updateNavbar(user) {
    const navbarAuth = document.getElementById("navbar-auth");
    if (!navbarAuth) return;

    if (user) {
        navbarAuth.innerHTML = `
            <details class="dropdown dropdown-end nav-link">
                <summary class="rounded-full border bg-yellow-100 text-base font-medium nav-link">${user.email}</summary>
                <ul class="p-2 shadow menu dropdown-content bg-base-100 rounded-box w-52 z-[999]">
                    <li><a id="logout-btn">Logout</a></li>
                </ul>
            </details>
        `;

        document.getElementById("logout-btn").onclick = () => {
            auth.signOut().then(() => location.reload());
        };
    } else {
        navbarAuth.innerHTML = `
        <div class="flex gap-2">
            <a class="btn btn-sm bg-yellow-100 text-black font-medium nav-link" href="/login.html">Login</a>
            <a class="btn btn-sm btn-outline nav-link" href="/signup.html">Signup</a>
        </div>
        `;
    }
}

onAuthStateChanged(auth, async (user) => {
    updateNavbar(user);
});

updateNavbar();
