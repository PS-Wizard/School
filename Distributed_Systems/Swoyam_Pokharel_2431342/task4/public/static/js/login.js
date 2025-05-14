import { initializeApp } from "https://www.gstatic.com/firebasejs/11.7.1/firebase-app.js";
import {
    getAuth,
    signInWithEmailAndPassword,
    onAuthStateChanged,
    GoogleAuthProvider,
    signInWithPopup,
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
const googleProvider = new GoogleAuthProvider();

// Email/Password Login
window.loginWithEmail = async function () {
    const email = document.getElementById("email").value;
    const password = document.getElementById("password").value;

    try {
        const userCred = await signInWithEmailAndPassword(auth, email, password);
        window.location.href = "/dashboard.html";
        console.log("User:", userCred.user);
    } catch (err) {
        alert("Login failed: " + err.message);
    }
};

// Google Login
window.loginWithGoogle = async function () {
    try {
        const result = await signInWithPopup(auth, googleProvider);
        const user = result.user;
        window.location.href = "/dashboard.html";
        console.log(user);
    } catch (err) {
        alert("Google login failed: " + err.message);
    }
};

onAuthStateChanged(auth, async (user) => {
    if (user) {
        window.location.href = "/dashboard.html";
        return;
    }
});
