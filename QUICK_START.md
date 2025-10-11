# 🚀 Quick Start - Deploy Todo Backend in 5 Minutes

## What You're Deploying
A MongoDB-backed todo list API that replaces the local-only todo storage in your home page.

## Prerequisites
- ✅ Git installed
- ✅ Render account with existing backend service
- ✅ MongoDB connection string configured in Render

## Step 1: Deploy Backend (2 minutes)

```bash
# Navigate to your project root
cd c:\dev\GitHub\25AACR02

# Stage all changes
git add .

# Commit with descriptive message
git commit -m "Add MongoDB-backed todo list with CRUD API"

# Push to trigger Render auto-deploy
git push origin main
```

## Step 2: Verify Deployment (1 minute)

1. Go to https://dashboard.render.com
2. Find your `skillsocket-backend` service
3. Wait for deployment to complete (green checkmark)
4. Click "Logs" and verify:
   ```
   MongoDB connected
   🚀 Server running on port 3000
   ```

## Step 3: Test API (1 minute)

Open browser or terminal:

```bash
# Health check
curl http://localhost:3000/api/health
```

Expected response:
```json
{
  "status": "healthy",
  "database": "connected"
}
```

## Step 4: Test in Flutter App (1 minute)

1. **Run your Flutter app**
2. **Login** with valid credentials
3. **Navigate to home page**
4. **Add a todo** - Type and click checkmark
5. **Restart app** - Todo should still be there ✅

## ✅ Success Indicators

- ✅ Render shows "Live" status
- ✅ Health endpoint returns `database: "connected"`
- ✅ Todos persist after app restart
- ✅ No errors in Flutter console

## 🐛 Quick Troubleshooting

**Render deployment failed?**
- Check Render logs for specific error
- Verify all files are committed: `git status`

**401 Unauthorized in app?**
- User must be logged in
- Check token exists: SharedPreferences

**Todos not showing?**
- Check Flutter console for errors
- Verify backend URL in `lib/services/todo_service.dart`

## 📚 Full Documentation

- **TODO_INTEGRATION_SUMMARY.md** - Overview and features
- **TODO_BACKEND_README.md** - Technical details
- **DEPLOYMENT_CHECKLIST.md** - Complete testing guide

## 🎉 You're Done!

Your todo list now:
- ✅ Saves to MongoDB
- ✅ Works across devices
- ✅ Persists forever
- ✅ Is user-specific
- ✅ Is production-ready

---

**Need Help?** Check the full documentation files or Render logs for detailed error messages.
