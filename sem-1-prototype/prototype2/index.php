<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Content-Type: application/json');

$username = "root";
$password = "";
$dbname = "weather_app";
$tablename = "weather_info";
$apiKey = "a350376b5ed6504aaae4f8ce08895c27";
$defaultCity = "Biratnagar";
header('Content-Type: application/json');
function fetchWeatherData($cityName, $apiKey) {
    $url = "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric";
    $response = file_get_contents($url);
    $weatherData = json_decode($response, true);

    if (isset($weatherData['cod']) && $weatherData['cod'] == 200) {
        return $weatherData;
    } else {
        return null;
    }
}

function createDatabase($conn, $dbname) {
    $sql = "CREATE DATABASE IF NOT EXISTS $dbname";
    if ($conn->query($sql) !== TRUE) {
        die(json_encode(["error" => "Error creating database: " . $conn->error]));
    }
}

function createTable($conn, $dbname, $tablename) {
    $conn->select_db($dbname);

    $sql = "CREATE TABLE IF NOT EXISTS $tablename (
        id INT AUTO_INCREMENT PRIMARY KEY,
        city_name VARCHAR(100) NOT NULL,
        humidity DECIMAL(5,2) NOT NULL,
        temperature DECIMAL(5,2) NOT NULL,
        wind_speed DECIMAL(5,2) NOT NULL,
        wind_direction VARCHAR(10) NOT NULL,
        pressure DECIMAL(7,2) NOT NULL,
        weather_icon VARCHAR(100) NOT NULL,
        timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    )";

    if ($conn->query($sql) !== TRUE) {
        die(json_encode(["error" => "Error creating table: " . $conn->error]));
    }
}

$cityName = isset($_GET['city']) ? $_GET['city'] : $defaultCity;

$conn = new mysqli("localhost", $username, $password);

if ($conn->connect_error) {
    die(json_encode(["error" => "Connection failed: " . $conn->connect_error]));
}

createDatabase($conn, $dbname);
createTable($conn, $dbname, $tablename);
$conn->select_db($dbname);

$sql = "SELECT * FROM $tablename WHERE city_name = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $cityName);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $data = $result->fetch_assoc();

    date_default_timezone_set('Asia/Kathmandu');
    $dataAge = strtotime($data['timestamp']);
    $currentTime = time();

    if (($currentTime - $dataAge) > 7200) { 
        $weatherData = fetchWeatherData($cityName, $apiKey);

        if ($weatherData) {
            $humidity = $weatherData['main']['humidity'];
            $temperature = $weatherData['main']['temp'];
            $wind_speed = $weatherData['wind']['speed'];
            $wind_direction = $weatherData['wind']['deg'];
            $pressure = $weatherData['main']['pressure'];
            $weather_icon = $weatherData['weather'][0]['icon'];

            $updateSQL = "UPDATE $tablename SET 
                humidity = ?, temperature = ?, wind_speed = ?, 
                wind_direction = ?, pressure = ?, weather_icon = ?, timestamp = NOW()
                WHERE city_name = ?";
            $updateStmt = $conn->prepare($updateSQL);
            $updateStmt->bind_param("ddddsss", $humidity, $temperature, $wind_speed, $wind_direction, $pressure, $weather_icon, $cityName);

            if ($updateStmt->execute()) {
                $data['humidity'] = $humidity;
                $data['temperature'] = $temperature;
                $data['wind_speed'] = $wind_speed;
                $data['wind_direction'] = $wind_direction;
                $data['pressure'] = $pressure;
                $data['weather_icon'] = $weather_icon;
                $data['timestamp'] = date("Y-m-d H:i:s");
            } else {
                echo json_encode(["error" => "Failed to update data in the database."]);
                $conn->close();
                exit;
            }
        } else {
            echo json_encode(["error" => "Unable to fetch updated weather data for city: $cityName."]);
            $conn->close();
            exit;
        }
    }

    echo json_encode($data);
} else {
    $weatherData = fetchWeatherData($cityName, $apiKey);

    if ($weatherData) {
        $city_name = $weatherData['name'];
        $humidity = $weatherData['main']['humidity'];
        $temperature = $weatherData['main']['temp'];
        $wind_speed = $weatherData['wind']['speed'];
        $wind_direction = $weatherData['wind']['deg'];
        $pressure = $weatherData['main']['pressure'];
        $weather_icon = $weatherData['weather'][0]['icon'];

        $insertSQL = "INSERT INTO $tablename (city_name, humidity, temperature, wind_speed, wind_direction, pressure, weather_icon)
                      VALUES (?, ?, ?, ?, ?, ?, ?)";
        $insertStmt = $conn->prepare($insertSQL);
        $insertStmt->bind_param("sddddss", $city_name, $humidity, $temperature, $wind_speed, $wind_direction, $pressure, $weather_icon);

        if ($insertStmt->execute()) {
            $data = [
                "city_name" => $city_name,
                "humidity" => $humidity,
                "temperature" => $temperature,
                "wind_speed" => $wind_speed,
                "wind_direction" => $wind_direction,
                "pressure" => $pressure,
                "weather_icon" => $weather_icon,
                "timestamp" => date("Y-m-d H:i:s")
            ];
            echo json_encode($data);
        } else {
            echo json_encode(["error" => "Failed to insert data into the database."]);
        }
    } else {
        echo json_encode(["error" => "Unable to fetch weather data for city: $cityName."]);
    }
}

$conn->close();
?>
