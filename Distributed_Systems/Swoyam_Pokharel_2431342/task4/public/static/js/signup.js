import { initializeApp } from "https://www.gstatic.com/firebasejs/11.7.1/firebase-app.js";

import {
    getAuth,
    createUserWithEmailAndPassword,
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

// Email/Password Signup
window.signupWithEmail = async function () {
    const email = document.getElementById("email").value;
    const password = document.getElementById("password").value;

    try {
        const userCred = await createUserWithEmailAndPassword(auth, email, password);
        alert("Signup successful");
        console.log("User:", userCred.user);
    } catch (err) {
        alert("Signup failed: " + err.message);
    }
};

const googleProvider = new GoogleAuthProvider();
window.signupWithGoogle = async function () {
    try {
        const result = await signInWithPopup(auth, googleProvider);
        const user = result.user;
        alert("Signed in with Google");
        console.log(user);
    } catch (err) {
        alert("Google signup failed: " + err.message);
    }
};

onAuthStateChanged(auth, async (user) => {
    if (user) {
        window.location.href = "/dashboard.html";
        return;
    }
});
