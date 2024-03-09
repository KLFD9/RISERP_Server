window.addEventListener('message', (event) => {
    const { type, speed, gear, fuel, health } = event.data; 
    const speedometerElement = document.getElementById('speedometer');
    const gearboxElement = document.getElementById('gearbox');
    const fuelLevelElement = document.getElementById('fuelLevel');
    const vehicleHealthElement = document.getElementById('vehicleHealth');
    const contSpeedoElement = document.getElementById('contSpeedo');
    switch(event.data.type) {
        case 'onNuiReady':
            break;
    }
    
    switch (type) {
        case 'updateSpeed':
            speedometerElement.textContent = `${speed}`;
            contSpeedoElement.classList.remove('hidden');
            break;
        case 'updateGear':
            gearboxElement.textContent = gear;
            break;
        case 'updateFuel':
            fuelLevelElement.textContent = `${fuel}%`;
            break;
        case 'updateHealth':
            vehicleHealthElement.textContent = `${health}%`;
            break;
        case 'hideSpeedometer':
            contSpeedoElement.classList.add('hidden');
            break;
        case 'updateIndicators':
            if (hazardLights) {
                leftIndicatorElement.classList.add('blink');
                rightIndicatorElement.classList.add('blink');
            } else {
                leftIndicatorElement.className = leftIndicator ? 'blink' : '';
                rightIndicatorElement.className = rightIndicator ? 'blink' : '';
            }
            break;
}
});

window.addEventListener('message', function(event) {
    switch(event.data.type) {
        case 'updateFuel':
            var fuelIcon = document.getElementById('fuelIcon');
            var fuelLevel = document.getElementById('fuelLevel');
            if (event.data.fuel <= 20) {
                fuelIcon.style.color = 'red';
                fuelLevel.style.color = 'red';
                fuelIcon.classList.add('blink');  
                fuelLevel.classList.add('blink');
            } else {
                fuelIcon.style.color = '#f8b34c';
                fuelLevel.style.color = '#fff';
                fuelIcon.classList.remove('blink');
                fuelLevel.classList.remove('blink');
            }
            break;
    }
});

window.addEventListener('message', function(event) {
    switch(event.data.type) {
        case 'updateIndicators':
            var leftIndicatorElement = document.getElementById('leftIndicator');
            var rightIndicatorElement = document.getElementById('rightIndicator');
            var hazardLights = event.data.hazardLights;
            var leftIndicator = event.data.leftIndicator;
            var rightIndicator = event.data.rightIndicator;
            if (hazardLights) {
                leftIndicatorElement.classList.add('blink');
                rightIndicatorElement.classList.add('blink');
                leftIndicator.style.color = 'orange';
                rightIndicator.style.color = 'orange';
            } else {
                leftIndicatorElement.className = leftIndicator ? 'blink' : '';
                rightIndicatorElement.className = rightIndicator ? 'blink' : '';
                leftIndicator.style.color = 'red';
                rightIndicator.style.color = 'green';
            }
            break;
    }
});