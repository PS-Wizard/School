
## Getting Started With Google Firebase:

![dashboard](assets/dashboard.png)
    >

## Creating A New Project

![creating_new_project](assets/creating_new_project.png)
    >

## Continuing Creating New Project
![continuing_creation](assets/continuing_creation.png)
    >

##  Finalizing Creation
![finalizing_creation](assets/finalizing_creation.png)
    >

## Project Created
![project_created](assets/project_created.png)
    >

## Firebase Dashboard
![firebase_dashboard](assets/firebase_dashboard.png)
    >

## Creating Web App
![creating_web_app](assets/creating_web_app.png)
    > 

## Firebase SDK
![firebase_sdk](assets/firebase_sdk.png)
    >

    ```javascript

    // Import the functions you need from the SDKs you need
    import { initializeApp } from "firebase/app";
    import { getAnalytics } from "firebase/analytics";
    // TODO: Add SDKs for Firebase products that you want to use
    // https://firebase.google.com/docs/web/setup#available-libraries

    // Your web app's Firebase configuration
    // For Firebase JS SDK v7.20.0 and later, measurementId is optional
    const firebaseConfig = {
apiKey: "AIzaSyCjPfp4Or17D2x6T6ZLytbumL2Bd1O4LfE",
        authDomain: "swoyam-ba9c8.firebaseapp.com",
        projectId: "swoyam-ba9c8",
        storageBucket: "swoyam-ba9c8.firebasestorage.app",
        messagingSenderId: "1082002199568",
        appId: "1:1082002199568:web:e2cfa042d07ae85adba695",
        measurementId: "G-SYXY3PL581"
    };

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);
```

## Setting Up Cloud Firestore
![db_cloud_firestore](assets/db_cloud_firestore.png)
    >

## Setting Name And DB Location
![setting_name_and_db_location](assets/setting_name_and_db_location.png)
    >

## Starting In Test Mode
![starting_in_test_mode](assets/starting_in_test_mode.png)
    >

## Database Created:
![database_created](assets/database_created.png)
    >

## A New Collection And Document
    ![new_collection_and_document](assets/new_collection_and_document.png)
![created_new_document_and_collection](assets/created_new_document_and_collection.png)
    >

# Accessing your data from Javascript

    ```html
    <!DOCTYPE html>
    <html lang="en">
    <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet" />
    </head>
    <title>My Firebase app</title>
    </head>
    <body>
    <div class="container">
    <h1 id="mainTitle">My books</h1>
    <table class="table table-striped">
    <tbody id="reviewList">
    </tbody>
    </table>
    </div>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    </body>
    </html>
    ```

    ```javascript
    ~ From Part 1

    import { initializeApp } from "firebase/app";
    import { getAnalytics } from "firebase/analytics";
    // TODO: Add SDKs for Firebase products that you want to use
    // https://firebase.google.com/docs/web/setup#available-libraries

    // Your web app's Firebase configuration
    // For Firebase JS SDK v7.20.0 and later, measurementId is optional
    const firebaseConfig = {
apiKey: "AIzaSyCjPfp4Or17D2x6T6ZLytbumL2Bd1O4LfE",
        authDomain: "swoyam-ba9c8.firebaseapp.com",
        projectId: "swoyam-ba9c8",
        storageBucket: "swoyam-ba9c8.firebasestorage.app",
        messagingSenderId: "1082002199568",
        appId: "1:1082002199568:web:e2cfa042d07ae85adba695",
        measurementId: "G-SYXY3PL581"
    };

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);
```

Also Added:

```javascript

// Get a live data snapshot (i.e. auto-refresh) of our Reviews collection
const q = query(collection(db, "Reviews"), orderBy("book_name"));
const unsubscribe = onSnapshot(q, (snapshot) => {
        // Empty HTML table
        $('#reviewList').empty();
        // Loop through snapshot data and add to HTML table
        var tableRows = '';
        snapshot.forEach((doc) => {
                tableRows += '<tr>';
                tableRows += '<td>' + doc.data().book_name + '</td>';
                tableRows += '<td>' + doc.data().book_rating + '/5</td>';
                tableRows += '</tr>';
                });
        $('#reviewList').append(tableRows);
        // Display review count
        $('#mainTitle').html(snapshot.size + " book reviews in the list");
        });

```

## Updated HTML 
```html

<!DOCTYPE html>
<html lang="en">
<head>
<!-- Required meta tags -->
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<title>My Firebase app</title>
</head>
<body>
<div class="container">
<h1 id="mainTitle">My books</h1>
<table class="table table-striped"> <- Updated Here
<tbody id="reviewList"> <- Updated Here
</tbody> <- Updated Here
</table> <- Updated Here
</div>
<script src ="./myscripts.js" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

```

==Note: I've added cdn for firebase sdk since im not using a bundler== 

    ```
~ Updated Code ( All In One File )

    <!DOCTYPE html>
    <html lang="en">
    <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>My Firebase app</title> <!-- move title here -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet" />
    </head>
    <body>
    <div class="container">
    <h1 id="mainTitle">My books</h1>
    <table class="table table-striped">
    <tbody id="reviewList">
    </tbody>
    </table>
    </div>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script type="module">
    import { initializeApp } from "https://www.gstatic.com/firebasejs/9.22.2/firebase-app.js";
    import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.22.2/firebase-analytics.js";
    import { getFirestore, collection, query, orderBy, onSnapshot } from "https://www.gstatic.com/firebasejs/9.22.2/firebase-firestore.js";

    console.log("I am here");

    const firebaseConfig = {
apiKey: "AIzaSyCjPfp4Or17D2x6T6ZLytbumL2Bd1O4LfE",
        authDomain: "swoyam-ba9c8.firebaseapp.com",
        projectId: "swoyam-ba9c8",
        storageBucket: "swoyam-ba9c8.appspot.com",
        messagingSenderId: "1082002199568",
        appId: "1:1082002199568:web:e2cfa042d07ae85adba695",
        measurementId: "G-SYXY3PL581"
    };

const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);
const db = getFirestore(app);

const q = query(collection(db, "Reviews"), orderBy("book_name"));

onSnapshot(q, (snapshot) => {
        console.log("Snapshot received");
        $('#reviewList').empty();
        let tableRows = '';
        snapshot.forEach((doc) => {
                const data = doc.data();
                tableRows += `<tr><td>${data.book_name}</td><td>${data.book_rating}/5</td></tr>`;
                });
        $('#reviewList').append(tableRows);
        $('#mainTitle').html(`${snapshot.size} book reviews in the list`);
        }, (err) => {
        console.error("Snapshot error:", err);
        });
</script>

</body>
</html>
```
==NOTE: Firebase wont work with `file://` so, I created an http server with bun==
```
~

[wizard@archlinux tuto]$ bunx http-server .
Starting up http-server, serving .

http-server version: 14.1.1

http-server settings:
CORS: disabled
Cache: 3600 seconds
Connection Timeout: 120 seconds
Directory Listings: visible
AutoIndex: visible
Serve GZIP Files: false
Serve Brotli Files: false
Default File Extension: none

Available on:
http://127.0.0.1:8080
http://10.21.7.125:8080
Hit CTRL-C to stop the server

```

==Note: Updated Code==
```html
<!doctype html>
<html lang="en">
<head>
<!-- Required meta tags -->
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
<title>My Firebase app</title>
</head>
<body>
<div class="container mt-4">
<h1 id="mainTitle">My books</h1>

<div class="d-flex mb-3">
<input type="text" class="form-control" id="bookName" placeholder="Book name">
<select class="form-control mx-2 w-25" id="bookRating">
<option value="1">1/5</option>
<option value="2">2/5</option>
<option value="3">3/5</option>
<option value="4">4/5</option>
<option value="5">5/5</option>
</select>
<input type="date" class="form-control mx-2 w-25" id="bookDate">

<button type="button" class="btn btn-primary" id="addButton">Add</button>
</div>

<table class="table table-striped">
<tbody id="reviewList">
</tbody>
<thead>
<tr>
<th>Book Name</th>
<th>Rating</th>
<th>Date</th>
</tr>
</thead>
<tbody id="reviewList">
</tbody>
</table>
</div>

<!-- Firebase and custom scripts -->
<script type="module" src="myscripts.js"></script>
<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- Bootstrap JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
<script type="module">
import { initializeApp } from "https://www.gstatic.com/firebasejs/9.22.2/firebase-app.js";
import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.22.2/firebase-analytics.js";
import { getFirestore, collection, query, orderBy, onSnapshot, addDoc } from "https://www.gstatic.com/firebasejs/9.22.2/firebase-firestore.js";

console.log("I am here");

const firebaseConfig = {
apiKey: "AIzaSyCjPfp4Or17D2x6T6ZLytbumL2Bd1O4LfE",
        authDomain: "swoyam-ba9c8.firebaseapp.com",
        projectId: "swoyam-ba9c8",
        storageBucket: "swoyam-ba9c8.appspot.com",
        messagingSenderId: "1082002199568",
        appId: "1:1082002199568:web:e2cfa042d07ae85adba695",
        measurementId: "G-SYXY3PL581"
};

const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);
const db = getFirestore(app);

const q = query(collection(db, "Reviews"), orderBy("book_name"));

// Listen for real-time updates in Firestore
onSnapshot(q, (snapshot) => {
        console.log("Snapshot received");
        $('#reviewList').empty();
        let tableRows = '';
        snapshot.forEach((doc) => {
                const data = doc.data();
                tableRows += `<tr><td>${data.book_name}</td><td>${data.book_rating}/5</td><td>${data.book_date}</td></tr>`;
                });
        $('#reviewList').append(tableRows);
        $('#mainTitle').html(`${snapshot.size} book reviews in the list`);
        }, (err) => {
        console.error("Snapshot error:", err);
        });

// Handle "Add" button click
document.getElementById("addButton").addEventListener("click", async () => {
        const bookName = document.getElementById("bookName").value;
        const bookRating = document.getElementById("bookRating").value;
        const bookDate = document.getElementById("bookDate").value;

        if (bookName && bookRating && bookDate) {
        try {
        // Add a new review to Firestore
        await addDoc(collection(db, "Reviews"), {
book_name: bookName,
book_rating: bookRating,
book_date: bookDate
});
        console.log("Book review added successfully!");

        // Clear input fields after adding
        document.getElementById("bookName").value = "";
        document.getElementById("bookRating").value = "1";
        document.getElementById("bookDate").value = "";
        } catch (error) {
        console.error("Error adding review:", error);
        }
} else {
    alert("Please fill in all fields!");
}
});
</script>

</body>
</html>
```

![result_of_code](assets/result_of_code.png)
![adding_new_book_with_date](assets/adding_new_book_with_date.png)
