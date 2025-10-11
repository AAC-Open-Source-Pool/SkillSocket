# Todo Backend Deployment Checklist

## ✅ Files Created/Modified

### Backend Files
- ✅ `lib/backend/models/Todo.js` - MongoDB schema for todos
- ✅ `lib/backend/routes/todoRoutes.js` - CRUD API endpoints
- ✅ `lib/backend/server.js` - Registered todo routes

### Frontend Files
- ✅ `lib/services/todo_service.dart` - API client for todos
- ✅ `lib/home.dart` - Updated to use backend instead of local state

### Documentation
- ✅ `TODO_BACKEND_README.md` - Complete integration guide
- ✅ `DEPLOYMENT_CHECKLIST.md` - This file

## 🚀 Pre-Deployment Steps

### 1. Local Testing (Optional but Recommended)
```bash
cd lib/backend

# Create .env file with:
# MONGODB_URI=your_mongodb_connection_string
# JWT_SECRET=your_jwt_secret

# Install dependencies (if not already done)
npm install

# Start server
npm start

# Should see:
# MongoDB connected
# 🚀 Server running on port 3000
```

### 2. Test API Locally
```bash
# Health check
curl http://localhost:3000/api/health

# Should return JSON with database: "connected"
```

## 📦 Deployment to Render

### Step 1: Commit Changes
```bash
git add .
git commit -m "Add MongoDB-backed todo list with CRUD operations"
git push origin main
```

### Step 2: Verify Render Auto-Deploy
1. Go to https://dashboard.render.com
2. Find your `skillsocket-backend` service
3. Check "Events" tab - should show new deployment starting
4. Wait for deployment to complete (usually 2-5 minutes)

### Step 3: Check Deployment Logs
Look for these success messages:
```
MongoDB connected
🚀 Server running on port 3000
```

### Step 4: Test Production API
```bash
# Health check
curl http://localhost:3000/api/health

# Expected response:
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

## 🧪 Testing the Todo Feature

### Backend API Tests

#### 1. Get Auth Token
```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"yourpassword"}'

# Save the token from response
```

#### 2. Create a Todo
```bash
curl -X POST http://localhost:3000/api/todos \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"date":"2025-10-11","task":"Test todo from API"}'

# Should return 201 with todo object including _id
```

#### 3. Get Todos for Date
```bash
curl -X GET "http://localhost:3000/api/todos?date=2025-10-11" \
  -H "Authorization: Bearer YOUR_TOKEN"

# Should return array of todos
```

#### 4. Update Todo (Toggle Done)
```bash
curl -X PATCH http://localhost:3000/api/todos/TODO_ID \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"done":true}'

# Should return updated todo with done: true
```

#### 5. Delete Todo
```bash
curl -X DELETE http://localhost:3000/api/todos/TODO_ID \
  -H "Authorization: Bearer YOUR_TOKEN"

# Should return {"success": true}
```

### Flutter App Tests

#### 1. Login
- Open app
- Login with valid credentials
- Verify token is stored (check SharedPreferences)

#### 2. Navigate to Home Page
- Should see calendar and todo section
- Should show loading indicator briefly
- Should load existing todos for today (if any)

#### 3. Add Todo
- Type task in input field
- Click checkmark button
- Todo should appear in list immediately
- Reload app → todo should still be there (persisted)

#### 4. Toggle Completion
- Click checkbox next to todo
- Text should get strikethrough
- Reload app → checkbox should remain checked

#### 5. Delete Todo
- Click delete icon (trash)
- Todo should disappear from list
- Reload app → todo should not reappear

#### 6. Change Date
- Select different date in calendar
- Should load todos for that date
- Add todo on new date
- Switch back to original date → should see original todos

## 🔍 Verification Checklist

- [ ] Backend deployed successfully on Render
- [ ] Health endpoint returns `database: "connected"`
- [ ] Can create todo via API (returns 201)
- [ ] Can fetch todos via API (returns 200)
- [ ] Can update todo via API (returns 200)
- [ ] Can delete todo via API (returns 200)
- [ ] Flutter app loads todos on home page
- [ ] Can add todo from app
- [ ] Can toggle todo completion from app
- [ ] Can delete todo from app
- [ ] Todos persist after app restart
- [ ] Todos are date-specific (different dates show different todos)
- [ ] Loading indicator shows while fetching
- [ ] No console errors in Flutter debug output

## 🐛 Troubleshooting

### Backend Issues

**Deployment Failed**
- Check Render logs for errors
- Verify all files are committed and pushed
- Ensure package.json has all dependencies

**Database Connection Error**
- Verify MONGODB_URI environment variable in Render
- Check MongoDB Atlas IP whitelist (should allow 0.0.0.0/0 for Render)
- Test connection string locally

**401 Unauthorized on API Calls**
- Verify JWT_SECRET is set in Render environment variables
- Check token is being sent in Authorization header
- Token might be expired → login again

### Frontend Issues

**Todos Not Loading**
- Check Flutter console for errors
- Verify user is logged in (token exists)
- Check network connectivity
- Verify API URL is correct in `todo_service.dart`

**Todos Not Persisting**
- Check if API calls are succeeding (look for 200/201 status)
- Verify backend is saving to database (check MongoDB Atlas)
- Check Render logs for errors

**Wrong Todos Showing**
- Verify date formatting (YYYY-MM-DD)
- Check timezone handling
- Ensure `_loadTodos()` is called on date change

## 📊 Monitoring

### Render Dashboard
- Monitor CPU/Memory usage
- Check request logs
- Set up alerts for downtime

### MongoDB Atlas (if using)
- Monitor database size
- Check query performance
- Set up backup schedule

### Application Logs
- Backend: Render dashboard → Logs tab
- Frontend: Flutter debug console
- Look for error patterns

## 🎉 Success Criteria

Your todo backend is successfully deployed when:
1. ✅ All API endpoints return expected responses
2. ✅ Todos persist across app restarts
3. ✅ Multiple users can have separate todo lists
4. ✅ Todos are correctly scoped by date
5. ✅ No errors in production logs
6. ✅ App works smoothly with no lag

## 📞 Next Steps

After successful deployment:
1. Monitor for 24 hours to ensure stability
2. Gather user feedback
3. Consider implementing enhancements (see TODO_BACKEND_README.md)
4. Set up automated backups for MongoDB
5. Add monitoring/alerting (e.g., Sentry, LogRocket)

---

**Deployment Date**: _________________  
**Deployed By**: _________________  
**Production URL**: http://localhost:3000  
**Status**: ⬜ Pending | ⬜ In Progress | ⬜ Complete
