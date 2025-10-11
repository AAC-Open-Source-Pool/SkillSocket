# Todo Backend Integration Guide

## Overview
The todo list on the home page is now fully integrated with a MongoDB backend deployed on Render. Users can add, edit (toggle completion), and delete todos, with all data persisted per user and per date.

## Backend Architecture

### 1. **MongoDB Model** (`lib/backend/models/Todo.js`)
- **Fields:**
  - `user`: Reference to User (ObjectId, indexed)
  - `date`: Date at UTC midnight (indexed for efficient queries)
  - `task`: String (the todo text)
  - `done`: Boolean (completion status)
  - `timestamps`: Auto-generated createdAt/updatedAt

### 2. **API Routes** (`lib/backend/routes/todoRoutes.js`)
All routes are protected by JWT authentication (`verifyToken` middleware).

| Method | Endpoint | Body | Description |
|--------|----------|------|-------------|
| GET | `/api/todos?date=YYYY-MM-DD` | - | Get all todos for a specific date |
| POST | `/api/todos` | `{ date: "YYYY-MM-DD", task: "string" }` | Create a new todo |
| PATCH | `/api/todos/:id` | `{ task?: "string", done?: boolean }` | Update todo (task or completion) |
| DELETE | `/api/todos/:id` | - | Delete a todo |

### 3. **Server Registration** (`lib/backend/server.js`)
- Imported `todoRoutes` and mounted at `/api/todos`
- Uses existing MongoDB connection and JWT middleware

## Frontend Integration

### 1. **Service Layer** (`lib/services/todo_service.dart`)
- `getTodos(DateTime date)`: Fetch todos for a date
- `createTodo(DateTime date, String task)`: Create new todo
- `updateTodo(String id, {String? task, bool? done})`: Update todo
- `deleteTodo(String id)`: Delete todo
- Automatically includes JWT token from SharedPreferences in all requests

### 2. **UI Updates** (`lib/home.dart`)
- **State Management:**
  - Changed from `Map<DateTime, List<Todo>>` to single `List<Todo>` for current date
  - Added `_loadingTodos` flag for loading indicator
  - Added `initState()` to load todos on mount
  - Load todos when date changes in calendar

- **User Actions:**
  - **Add**: Calls `TodoService.createTodo()`, appends to list on success
  - **Toggle**: Calls `TodoService.updateTodo()` with new `done` status
  - **Delete**: Calls `TodoService.deleteTodo()`, removes from list on success

- **Loading State**: Shows `CircularProgressIndicator` while fetching

## Deployment Instructions

### Prerequisites
- MongoDB Atlas cluster (or any MongoDB instance)
- Render account with existing backend service
- Environment variables configured in Render

### Step 1: Deploy Backend Code
```bash
# Navigate to backend directory
cd lib/backend

# Ensure dependencies are installed
npm install

# Test locally (optional)
# Set MONGODB_URI and JWT_SECRET in .env file
node server.js

# Commit and push changes
git add .
git commit -m "Add todo backend with MongoDB integration"
git push origin main
```

### Step 2: Verify Render Deployment
1. Go to your Render dashboard
2. Your service should auto-deploy from the GitHub push
3. Check deployment logs for:
   - `MongoDB connected`
   - `🚀 Server running on port 3000`
4. Test health endpoint: `http://localhost:3000/api/health`

### Step 3: Test API Endpoints
Use Postman or curl to test:

```bash
# Get auth token first (login)
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"password"}'

# Get todos for a date
curl -X GET "http://localhost:3000/api/todos?date=2025-10-11" \
  -H "Authorization: Bearer YOUR_TOKEN"

# Create a todo
curl -X POST http://localhost:3000/api/todos \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"date":"2025-10-11","task":"Complete project"}'

# Update todo (toggle done)
curl -X PATCH http://localhost:3000/api/todos/TODO_ID \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"done":true}'

# Delete todo
curl -X DELETE http://localhost:3000/api/todos/TODO_ID \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### Step 4: Test Flutter App
1. Ensure the app has valid auth token (user must be logged in)
2. Navigate to home page
3. Select a date in calendar
4. Add a todo → should persist after app restart
5. Toggle completion → should update in database
6. Delete todo → should remove from database

## Database Schema

### Todos Collection
```javascript
{
  _id: ObjectId("..."),
  user: ObjectId("..."),  // Reference to users collection
  date: ISODate("2025-10-11T00:00:00.000Z"),  // UTC midnight
  task: "Complete project documentation",
  done: false,
  createdAt: ISODate("2025-10-11T11:20:30.000Z"),
  updatedAt: ISODate("2025-10-11T11:20:30.000Z")
}
```

### Indexes
- `{ user: 1, date: 1 }` - Efficient queries for user's todos on specific date
- `{ user: 1 }` - User-level queries

## Security

### Authentication
- All todo endpoints require valid JWT token
- Token must be in `Authorization: Bearer TOKEN` header
- Todos are scoped to authenticated user (can't access other users' todos)

### Authorization
- Users can only CRUD their own todos
- Backend validates `req.user.userId` matches todo owner

## Error Handling

### Backend
- Returns appropriate HTTP status codes:
  - `200`: Success
  - `201`: Created
  - `400`: Bad request (missing fields)
  - `401`: Unauthorized (invalid/missing token)
  - `404`: Todo not found
  - `500`: Server error

### Frontend
- Gracefully handles API failures
- Shows empty state if fetch fails
- Logs errors to console for debugging
- Maintains local state until API confirms changes

## Future Enhancements

### Potential Features
1. **Offline Support**: Cache todos locally, sync when online
2. **Recurring Todos**: Add recurrence patterns (daily, weekly, etc.)
3. **Categories/Tags**: Organize todos by category
4. **Priority Levels**: High/medium/low priority
5. **Due Times**: Add specific times to todos (not just dates)
6. **Subtasks**: Nested todo items
7. **Sharing**: Share todos with other users
8. **Reminders**: Push notifications for upcoming todos
9. **Search**: Full-text search across all todos
10. **Analytics**: Track completion rates, productivity metrics

### Performance Optimizations
1. **Pagination**: For users with many todos
2. **Caching**: Redis cache for frequently accessed dates
3. **Batch Operations**: Bulk create/update/delete
4. **WebSocket Updates**: Real-time sync across devices

## Troubleshooting

### Common Issues

**Issue**: Todos not loading
- **Check**: User is logged in (token exists in SharedPreferences)
- **Check**: Backend is running (visit health endpoint)
- **Check**: MongoDB connection is active
- **Solution**: Check Flutter console for error logs

**Issue**: 401 Unauthorized
- **Check**: Token is valid and not expired
- **Solution**: Log out and log back in to refresh token

**Issue**: Todos not persisting
- **Check**: API calls are returning 200/201 status
- **Check**: MongoDB connection string is correct
- **Solution**: Check Render logs for database errors

**Issue**: Wrong date todos showing
- **Check**: Date formatting is consistent (YYYY-MM-DD)
- **Check**: Timezone handling (backend uses UTC midnight)
- **Solution**: Verify `_formatDate()` in TodoService

## Support
For issues or questions, check:
1. Render deployment logs
2. Flutter debug console
3. MongoDB Atlas logs (if using Atlas)
4. Backend error logs in Render dashboard
