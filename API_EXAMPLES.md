# Todo API Examples

Complete examples for testing the todo API endpoints using curl, Postman, or any HTTP client.

## Base URL
```
https://skillsocket-backend.onrender.com
```

## Authentication

All todo endpoints require a valid JWT token. First, login to get a token.

### Login
```bash
curl -X POST https://skillsocket-backend.onrender.com/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "yourpassword"
  }'
```

**Response (200 OK):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "_id": "507f191e810c19729de860ea",
    "email": "user@example.com",
    "name": "John Doe"
  }
}
```

**Save the token** - you'll need it for all subsequent requests.

---

## Todo Endpoints

### 1. Get Todos for a Date

Fetch all todos for a specific date.

**Request:**
```bash
curl -X GET "https://skillsocket-backend.onrender.com/api/todos?date=2025-10-11" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

**Response (200 OK):**
```json
[
  {
    "_id": "671234567890abcdef123456",
    "user": "507f191e810c19729de860ea",
    "date": "2025-10-11T00:00:00.000Z",
    "task": "Complete project documentation",
    "done": false,
    "createdAt": "2025-10-11T10:30:00.000Z",
    "updatedAt": "2025-10-11T10:30:00.000Z"
  },
  {
    "_id": "671234567890abcdef123457",
    "user": "507f191e810c19729de860ea",
    "date": "2025-10-11T00:00:00.000Z",
    "task": "Review pull requests",
    "done": true,
    "createdAt": "2025-10-11T11:00:00.000Z",
    "updatedAt": "2025-10-11T14:30:00.000Z"
  }
]
```

**Empty Response (200 OK):**
```json
[]
```

**Error Responses:**
- `400 Bad Request` - Missing date parameter
- `401 Unauthorized` - Invalid or missing token

---

### 2. Create a Todo

Add a new todo for a specific date.

**Request:**
```bash
curl -X POST https://skillsocket-backend.onrender.com/api/todos \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -H "Content-Type: application/json" \
  -d '{
    "date": "2025-10-11",
    "task": "Buy groceries"
  }'
```

**Response (201 Created):**
```json
{
  "_id": "671234567890abcdef123458",
  "user": "507f191e810c19729de860ea",
  "date": "2025-10-11T00:00:00.000Z",
  "task": "Buy groceries",
  "done": false,
  "createdAt": "2025-10-11T15:45:00.000Z",
  "updatedAt": "2025-10-11T15:45:00.000Z"
}
```

**Error Responses:**
- `400 Bad Request` - Missing date or task
  ```json
  { "message": "date and task are required" }
  ```
- `401 Unauthorized` - Invalid or missing token
- `500 Server Error` - Database error

---

### 3. Update a Todo

Update a todo's task text or completion status.

#### Toggle Completion Status

**Request:**
```bash
curl -X PATCH https://skillsocket-backend.onrender.com/api/todos/671234567890abcdef123458 \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -H "Content-Type: application/json" \
  -d '{
    "done": true
  }'
```

**Response (200 OK):**
```json
{
  "_id": "671234567890abcdef123458",
  "user": "507f191e810c19729de860ea",
  "date": "2025-10-11T00:00:00.000Z",
  "task": "Buy groceries",
  "done": true,
  "createdAt": "2025-10-11T15:45:00.000Z",
  "updatedAt": "2025-10-11T16:20:00.000Z"
}
```

#### Edit Task Text

**Request:**
```bash
curl -X PATCH https://skillsocket-backend.onrender.com/api/todos/671234567890abcdef123458 \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -H "Content-Type: application/json" \
  -d '{
    "task": "Buy groceries and cook dinner"
  }'
```

**Response (200 OK):**
```json
{
  "_id": "671234567890abcdef123458",
  "user": "507f191e810c19729de860ea",
  "date": "2025-10-11T00:00:00.000Z",
  "task": "Buy groceries and cook dinner",
  "done": true,
  "createdAt": "2025-10-11T15:45:00.000Z",
  "updatedAt": "2025-10-11T16:25:00.000Z"
}
```

#### Update Both

**Request:**
```bash
curl -X PATCH https://skillsocket-backend.onrender.com/api/todos/671234567890abcdef123458 \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -H "Content-Type: application/json" \
  -d '{
    "task": "Buy groceries and cook dinner",
    "done": false
  }'
```

**Error Responses:**
- `404 Not Found` - Todo doesn't exist or doesn't belong to user
  ```json
  { "message": "Todo not found" }
  ```
- `401 Unauthorized` - Invalid or missing token
- `500 Server Error` - Database error

---

### 4. Delete a Todo

Remove a todo permanently.

**Request:**
```bash
curl -X DELETE https://skillsocket-backend.onrender.com/api/todos/671234567890abcdef123458 \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

**Response (200 OK):**
```json
{
  "success": true
}
```

**Error Responses:**
- `404 Not Found` - Todo doesn't exist or doesn't belong to user
  ```json
  { "message": "Todo not found" }
  ```
- `401 Unauthorized` - Invalid or missing token
- `500 Server Error` - Database error

---

## Postman Collection

### Setup
1. Create a new collection: "SkillSocket Todos"
2. Add environment variable: `baseUrl` = `https://skillsocket-backend.onrender.com`
3. Add environment variable: `token` = (leave empty, will be set after login)

### Requests

#### 1. Login (to get token)
- **Method**: POST
- **URL**: `{{baseUrl}}/api/auth/login`
- **Body** (JSON):
  ```json
  {
    "email": "user@example.com",
    "password": "yourpassword"
  }
  ```
- **Tests** (to auto-save token):
  ```javascript
  pm.environment.set("token", pm.response.json().token);
  ```

#### 2. Get Todos
- **Method**: GET
- **URL**: `{{baseUrl}}/api/todos?date=2025-10-11`
- **Headers**: `Authorization: Bearer {{token}}`

#### 3. Create Todo
- **Method**: POST
- **URL**: `{{baseUrl}}/api/todos`
- **Headers**: `Authorization: Bearer {{token}}`
- **Body** (JSON):
  ```json
  {
    "date": "2025-10-11",
    "task": "Test todo from Postman"
  }
  ```
- **Tests** (to save todo ID):
  ```javascript
  pm.environment.set("todoId", pm.response.json()._id);
  ```

#### 4. Update Todo
- **Method**: PATCH
- **URL**: `{{baseUrl}}/api/todos/{{todoId}}`
- **Headers**: `Authorization: Bearer {{token}}`
- **Body** (JSON):
  ```json
  {
    "done": true
  }
  ```

#### 5. Delete Todo
- **Method**: DELETE
- **URL**: `{{baseUrl}}/api/todos/{{todoId}}`
- **Headers**: `Authorization: Bearer {{token}}`

---

## JavaScript (Fetch API)

```javascript
const baseUrl = 'https://skillsocket-backend.onrender.com';
let token = 'YOUR_TOKEN_HERE';

// Get todos for a date
async function getTodos(date) {
  const response = await fetch(`${baseUrl}/api/todos?date=${date}`, {
    headers: {
      'Authorization': `Bearer ${token}`
    }
  });
  return await response.json();
}

// Create a todo
async function createTodo(date, task) {
  const response = await fetch(`${baseUrl}/api/todos`, {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({ date, task })
  });
  return await response.json();
}

// Update a todo
async function updateTodo(id, updates) {
  const response = await fetch(`${baseUrl}/api/todos/${id}`, {
    method: 'PATCH',
    headers: {
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(updates)
  });
  return await response.json();
}

// Delete a todo
async function deleteTodo(id) {
  const response = await fetch(`${baseUrl}/api/todos/${id}`, {
    method: 'DELETE',
    headers: {
      'Authorization': `Bearer ${token}`
    }
  });
  return await response.json();
}

// Usage
(async () => {
  // Get todos for today
  const todos = await getTodos('2025-10-11');
  console.log('Todos:', todos);

  // Create a new todo
  const newTodo = await createTodo('2025-10-11', 'Test from JS');
  console.log('Created:', newTodo);

  // Toggle completion
  const updated = await updateTodo(newTodo._id, { done: true });
  console.log('Updated:', updated);

  // Delete todo
  const deleted = await deleteTodo(newTodo._id);
  console.log('Deleted:', deleted);
})();
```

---

## Python (requests)

```python
import requests
import json

BASE_URL = 'https://skillsocket-backend.onrender.com'
token = 'YOUR_TOKEN_HERE'

headers = {
    'Authorization': f'Bearer {token}',
    'Content-Type': 'application/json'
}

# Get todos for a date
def get_todos(date):
    response = requests.get(
        f'{BASE_URL}/api/todos',
        params={'date': date},
        headers=headers
    )
    return response.json()

# Create a todo
def create_todo(date, task):
    response = requests.post(
        f'{BASE_URL}/api/todos',
        headers=headers,
        json={'date': date, 'task': task}
    )
    return response.json()

# Update a todo
def update_todo(todo_id, **updates):
    response = requests.patch(
        f'{BASE_URL}/api/todos/{todo_id}',
        headers=headers,
        json=updates
    )
    return response.json()

# Delete a todo
def delete_todo(todo_id):
    response = requests.delete(
        f'{BASE_URL}/api/todos/{todo_id}',
        headers=headers
    )
    return response.json()

# Usage
if __name__ == '__main__':
    # Get todos
    todos = get_todos('2025-10-11')
    print('Todos:', todos)
    
    # Create todo
    new_todo = create_todo('2025-10-11', 'Test from Python')
    print('Created:', new_todo)
    
    # Toggle completion
    updated = update_todo(new_todo['_id'], done=True)
    print('Updated:', updated)
    
    # Delete todo
    deleted = delete_todo(new_todo['_id'])
    print('Deleted:', deleted)
```

---

## Common Error Responses

### 400 Bad Request
```json
{
  "message": "date and task are required"
}
```

### 401 Unauthorized
```json
{
  "message": "Access denied. No token provided."
}
```

```json
{
  "message": "Invalid token. Please log in again."
}
```

```json
{
  "message": "Token expired. Please log in again."
}
```

### 404 Not Found
```json
{
  "message": "Todo not found"
}
```

### 500 Server Error
```json
{
  "message": "Server error"
}
```

---

## Testing Workflow

1. **Login** to get token
2. **Create** a few todos for today
3. **Get** todos to verify they were created
4. **Update** one todo (toggle done)
5. **Get** again to verify update
6. **Delete** one todo
7. **Get** again to verify deletion
8. **Create** todos for different dates
9. **Get** each date to verify date scoping
10. **Test with different user** to verify isolation

---

## Rate Limiting

Currently, there is no rate limiting implemented. In production, consider:
- Max 100 requests per minute per user
- Max 1000 requests per hour per user
- Use Redis for distributed rate limiting

---

## Monitoring

Check these endpoints to monitor API health:

### Health Check
```bash
curl https://skillsocket-backend.onrender.com/api/health
```

**Response:**
```json
{
  "uptime": 123.45,
  "message": "OK",
  "timestamp": 1728650000000,
  "status": "healthy",
  "database": "connected",
  "version": "1.0.0",
  "environment": "production"
}
```

### Root Endpoint
```bash
curl https://skillsocket-backend.onrender.com/
```

**Response:**
```json
{
  "message": "Backend server is running!",
  "status": "OK"
}
```

---

**Happy Testing! 🚀**
