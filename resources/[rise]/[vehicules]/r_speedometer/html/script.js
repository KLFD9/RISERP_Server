window.addEventListener('message', function(event) {
    var data = event.data;

    switch(data.type) {
        case 'updateSpeed':
            document.getElementById('speedometer').innerText = `${data.speed} km/h`;
            break;
        case 'updateGear':
            document.getElementById('gearbox').innerText = data.gear;
            break;
        case 'updateFuel':
            document.getElementById('fuelLevel').innerText = `${data.fuel}%`;
            break;
        case 'updateHealth':
            document.getElementById('vehicleHealth').innerText = `${data.health}%`;
            break;
        case 'hideSpeedometer':
            document.getElementById('contSpeedo').style.display = 'none';
            break;
        case 'showSpeedometer':
            document.getElementById('contSpeedo').style.display = 'block';
            break;
    }
});
