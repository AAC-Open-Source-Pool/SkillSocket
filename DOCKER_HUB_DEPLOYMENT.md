# 🐳 Docker Hub Deployment Guide (Private Repo)

This guide shows how to deploy your backend using Docker Hub without connecting GitHub to Render.

## 🚀 Quick Overview

```
GitHub (Private) → GitHub Actions → Docker Hub → Render → Live Backend
```

**No GitHub-Render connection needed!** ✅

## 📋 Step-by-Step Setup

### 1. 🐳 Docker Hub Setup

1. **Create Docker Hub Account**: [hub.docker.com](https://hub.docker.com)

2. **Create Repository**:
   - Click "Create Repository"
   - **Name**: `skillsocket-backend`
   - **Visibility**: Public (free) or Private (paid)
   - Click "Create"

3. **Generate Access Token**:
   - Go to Account Settings → Security → Access Tokens
   - Click "New Access Token"
   - **Description**: `GitHub Actions`
   - **Permissions**: Read, Write, Delete
   - **Copy the token** (you won't see it again!)

### 2. 🔧 GitHub Secrets Setup

Go to your GitHub repo → Settings → Secrets and variables → Actions

Add these **4 secrets**:

| Secret Name | Value | Example |
|-------------|-------|---------|
| `DOCKER_USERNAME` | Your Docker Hub username | `john_doe` |
| `DOCKER_PASSWORD` | The access token you just created | `dckr_pat_1234567890abcdef` |
| `RENDER_SERVICE_ID` | Your Render service ID (get this in step 3) | `srv-abcd1234efgh5678` |
| `RENDER_API_KEY` | Your Render API key (get this in step 3) | `rnd_xyz789abc123def456` |

### 3. 🌐 Render Setup (Manual - No GitHub Connection)

1. **Create Render Account**: [render.com](https://render.com)

2. **Create Web Service**:
   - Click "New +" → "Web Service"
   - **Choose**: "Deploy an existing image from a registry"
   - **Image URL**: `docker.io/yourusername/skillsocket-backend:latest`
     - Replace `yourusername` with your actual Docker Hub username
   - Click "Next"

3. **Configure Service**:
   - **Name**: `skillsocket-backend`
   - **Region**: Choose closest to your users
   - **Plan**: Free
   - **Health Check Path**: `/api/health`
   - **Auto-Deploy**: Yes (deploys when new image is pushed)

4. **Add Environment Variables**:
   Click "Advanced" → Add these environment variables:

   ```
   NODE_ENV=production
   PORT=3000
   MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/skillsocket
   JWT_SECRET=your-super-secret-jwt-key-here-make-it-long-and-random
   ```

   **Optional** (if you use these services):
   ```
   CLOUDINARY_CLOUD_NAME=your-cloudinary-name
   CLOUDINARY_API_KEY=your-cloudinary-key
   CLOUDINARY_API_SECRET=your-cloudinary-secret
   FIREBASE_PROJECT_ID=your-firebase-project-id
   FIREBASE_CLIENT_EMAIL=your-firebase-client-email
   FIREBASE_PRIVATE_KEY=your-firebase-private-key
   ```

5. **Get Service Details**:
   - After creation, copy the **Service ID** from URL (e.g., `srv-abcd1234efgh5678`)
   - Go to Account Settings → API Keys → Create new key
   - Copy the **API Key** (e.g., `rnd_xyz789abc123def456`)

6. **Add these to GitHub Secrets** (step 2 above)

### 4. 🎯 Test the Pipeline

1. **Make a small change** to your backend code
2. **Commit and push** to main branch:
   ```bash
   git add .
   git commit -m "test deployment pipeline"
   git push origin main
   ```

3. **Watch the magic happen**:
   - GitHub Actions builds Docker image
   - Pushes to Docker Hub
   - Render automatically deploys new image
   - Your backend is live! 🎉

## 📊 Monitoring Your Deployment

### GitHub Actions
- Go to your repo → Actions tab
- Watch the pipeline: Test → Build → Deploy

### Docker Hub
- Check your images at: `https://hub.docker.com/r/yourusername/skillsocket-backend`
- See build history and tags

### Render Dashboard
- Monitor deployments at: `https://dashboard.render.com`
- View logs, metrics, and health status

### Health Check
- Test your deployed backend: `https://your-app.onrender.com/api/health`

## 🔄 How Auto-Deployment Works

1. **You push code** to main branch
2. **GitHub Actions triggers**:
   - Runs tests
   - Builds Docker image
   - Tags with `latest` and commit hash
   - Pushes to Docker Hub
3. **Render detects new image**:
   - Pulls latest image from Docker Hub
   - Deploys automatically
   - Health check ensures it's working
4. **Your backend is updated** with zero downtime!

## 🚨 Troubleshooting

### Common Issues:

**❌ Docker build fails**
- Check Dockerfile syntax
- Ensure all dependencies in package.json
- Review GitHub Actions logs

**❌ Render deployment fails**
- Verify environment variables are set
- Check Render logs for errors
- Ensure health check endpoint works

**❌ Can't connect to database**
- Verify MONGODB_URI is correct
- Check database allows connections from Render IPs
- Test connection string locally

### Debug Commands:

**Test Docker image locally:**
```bash
cd lib/backend
docker build -t skillsocket-backend .
docker run -p 3000:3000 -e NODE_ENV=production skillsocket-backend
curl http://localhost:3000/api/health
```

**Check if image exists on Docker Hub:**
```bash
docker pull yourusername/skillsocket-backend:latest
```

## ✅ Success Checklist

- [ ] Docker Hub account created
- [ ] Docker Hub repository created
- [ ] GitHub secrets added (4 secrets)
- [ ] Render web service created (from Docker image)
- [ ] Environment variables configured in Render
- [ ] Test push to main branch
- [ ] Pipeline runs successfully
- [ ] Backend is live and healthy

## 🎉 You're Done!

Your backend now auto-deploys whenever you push to main branch. No GitHub-Render connection needed!

**Your deployment URL**: `https://your-service-name.onrender.com`

---

💡 **Pro Tip**: Bookmark your Render dashboard and Docker Hub repository for easy monitoring!
