// DOM Manipulation Example - Interactive Button Counter
// This demonstrates event handling and DOM updates

// Get button and display elements
const button = document.getElementById('incrementBtn');
const display = document.getElementById('counter');

// Initialize counter
let count = 0;

// Add click event listener
button.addEventListener('click', function() {
    count++;
    display.textContent = count;
    console.log('Button clicked! Count is now: ' + count);
});

// Function to reset counter
function resetCounter() {
    count = 0;
    display.textContent = count;
    console.log('Counter reset');
}

// Example of DOM manipulation
function changeColor() {
    display.style.color = count % 2 === 0 ? 'blue' : 'red';
}
