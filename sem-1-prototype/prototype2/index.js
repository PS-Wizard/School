async function fetchWeather(city = "") {
    const baseUrl = "http://localhost:8080/index.php";
    const url = city ? `${baseUrl}?city=${city}` : baseUrl;

    try {
        const response = await fetch(url);
        if (!response.ok) throw new Error("Failed to fetch weather data");

        const data = await response.json();

        updateWeatherUI(data);
    } catch (error) {
        console.error("Error:", error);
        alert("Failed to fetch weather data. Please try again.");
    }
}

function updateWeatherUI(data) {
    document.querySelector("#city-name span").textContent = data.city_name || "N/A";
    document.querySelector("#humidity span").textContent = data.humidity || "N/A";
    document.querySelector("#temperature span").textContent = data.temperature || "N/A";
    document.querySelector("#wind-speed span").textContent = data.wind_speed || "N/A";
    document.querySelector("#wind-direction span").textContent = data.wind_direction || "N/A";
    document.querySelector("#pressure span").textContent = data.pressure || "N/A";
    document.querySelector("#weather-icon img").src = `https://openweathermap.org/img/wn/${data.weather_icon}.png`;
    document.querySelector("#weather-icon img").alt = "Weather Icon";
}

document.querySelector("#search-button").addEventListener("click", () => {
    const city = document.querySelector("#search-input").value.trim();
    if (city) {
        fetchWeather(city);
    } else {
        alert("Please enter a city name.");
    }
});

document.addEventListener("DOMContentLoaded", () => {
    fetchWeather(); // Fetch weather for the default city
});
