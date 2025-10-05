// Form Validation Example
// Demonstrates input validation and error handling

// Validate email format
function validateEmail(email) {
    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailPattern.test(email);
}

// Validate form on submit
function validateForm(event) {
    event.preventDefault(); // Prevent form submission
    
    const name = document.getElementById('name').value;
    const email = document.getElementById('email').value;
    const errors = [];
    
    // Check if name is empty
    if (name.trim() === '') {
        errors.push('Name is required');
    }
    
    // Check if name is at least 2 characters
    if (name.trim().length < 2) {
        errors.push('Name must be at least 2 characters');
    }
    
    // Validate email format
    if (!validateEmail(email)) {
        errors.push('Please enter a valid email address');
    }
    
    // Display errors or success
    if (errors.length > 0) {
        displayErrors(errors);
        return false;
    } else {
        displaySuccess('Form submitted successfully!');
        return true;
    }
}

// Display error messages
function displayErrors(errors) {
    const errorDiv = document.getElementById('errors');
    errorDiv.innerHTML = '';
    
    errors.forEach(function(error) {
        const errorItem = document.createElement('p');
        errorItem.textContent = error;
        errorItem.style.color = 'red';
        errorDiv.appendChild(errorItem);
    });
}

// Display success message
function displaySuccess(message) {
    const errorDiv = document.getElementById('errors');
    errorDiv.innerHTML = '<p style="color: green;">' + message + '</p>';
}

// Attach event listener when page loads
document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('contactForm');
    if (form) {
        form.addEventListener('submit', validateForm);
    }
});
