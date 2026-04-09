async function fetchTemperature() {
    const response = await fetch("/api/sensor/temperature");
    const data = await response.json();

    document.getElementById("temp").textContent =
        `${data.value.toFixed(1)} °C`;
}

setInterval(fetchTemperature, 5000);
fetchTemperature();
