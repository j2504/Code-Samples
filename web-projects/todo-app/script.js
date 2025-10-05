// Todo App JavaScript
// Demonstrates DOM manipulation, event handling, and data management

let todos = [];
let todoId = 0;

// Add new todo
function addTodo() {
    const input = document.getElementById('todoInput');
    const todoText = input.value.trim();
    
    // Validate input
    if (todoText === '') {
        alert('Please enter a task');
        return;
    }
    
    // Create todo object
    const todo = {
        id: todoId++,
        text: todoText,
        completed: false
    };
    
    // Add to array
    todos.push(todo);
    
    // Clear input
    input.value = '';
    
    // Update display
    renderTodos();
}

// Render all todos
function renderTodos() {
    const todoList = document.getElementById('todoList');
    todoList.innerHTML = '';
    
    // Create list items
    todos.forEach(function(todo) {
        const li = document.createElement('li');
        li.className = 'todo-item';
        if (todo.completed) {
            li.classList.add('completed');
        }
        
        // Todo text
        const span = document.createElement('span');
        span.textContent = todo.text;
        span.onclick = function() {
            toggleComplete(todo.id);
        };
        span.style.cursor = 'pointer';
        
        // Delete button
        const deleteBtn = document.createElement('button');
        deleteBtn.textContent = 'Delete';
        deleteBtn.className = 'delete-btn';
        deleteBtn.onclick = function() {
            deleteTodo(todo.id);
        };
        
        li.appendChild(span);
        li.appendChild(deleteBtn);
        todoList.appendChild(li);
    });
    
    // Update stats
    updateStats();
}

// Toggle todo completion
function toggleComplete(id) {
    const todo = todos.find(function(t) {
        return t.id === id;
    });
    
    if (todo) {
        todo.completed = !todo.completed;
        renderTodos();
    }
}

// Delete todo
function deleteTodo(id) {
    todos = todos.filter(function(todo) {
        return todo.id !== id;
    });
    renderTodos();
}

// Update statistics
function updateStats() {
    const totalTasks = document.getElementById('totalTasks');
    totalTasks.textContent = todos.length;
}

// Allow Enter key to add todo
document.addEventListener('DOMContentLoaded', function() {
    const input = document.getElementById('todoInput');
    input.addEventListener('keypress', function(event) {
        if (event.key === 'Enter') {
            addTodo();
        }
    });
});
