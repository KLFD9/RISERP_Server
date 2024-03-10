window.addEventListener('message', function(event) {
    var item = event.data;

    if (item.type === "speedometer") {
        document.getElementById('speedometer').innerText = item.speed + " km/h";
        document.getElementById('gearbox').innerText = item.gear;
        document.getElementById('fuelLevel').innerText = Math.round(item.fuel) + "%";
        document.getElementById('vehicleHealth').innerText = Math.round(item.health) + "%";
        document.getElementById('contSpeedo').style.display = 'block';  // Afficher le compteur de vitesse
    } else if (item.type === "hideSpeedometer") {
        // Masquer le compteur de vitesse quand le joueur n'est pas dans un véhicule
        document.getElementById('contSpeedo').style.display = 'none';
    }
});