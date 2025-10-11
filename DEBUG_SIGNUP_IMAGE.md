# Debug Guide - Signup Profile Image Upload

## Enhanced Debugging

I've added comprehensive logging to help identify the exact issue with profile image uploads during signup.

## Changes Made

### File: `lib/signup2.dart`

#### 1. Detailed Upload Logging
Added extensive console logs to track the upload process:

```dart
Future<String?> _uploadProfileImageToCloudinary(File profileImageFile) async {
  try {
    print('🖼️ Starting profile image upload...');
    print('🖼️ File path: ${profileImageFile.path}');
    print('🖼️ File exists: ${await profileImageFile.exists()}');
    print('🖼️ Upload URL: ${request.url}');
    print('🖼️ File added to request. Sending...');
    print('🖼️ Response status code: ${streamedResponse.statusCode}');
    print('🖼️ Response body: ${response.body}');
    
    if (response.statusCode == 200) {
      print('🖼️ Upload successful! URL: ${responseData['logoUrl']}');
      return responseData['logoUrl'];
    } else {
      print('❌ Profile image upload error: ${response.statusCode}');
      print('❌ Response body: ${response.body}');
      return null;
    }
  } catch (e, stackTrace) {
    print('❌ Profile image upload exception: $e');
    print('❌ Stack trace: $stackTrace');
    return null;
  }
}
```

#### 2. User Feedback
Added visual feedback during upload:

```dart
// Show uploading message
ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
    content: Text('Uploading profile picture...'),
    duration: Duration(seconds: 2),
  ),
);
```

#### 3. Better Error Messages
Improved error message to be more helpful:

```dart
_errorMessage = 'Failed to upload profile image. Please check your internet connection and try again.';
```

## How to Debug

### Step 1: Run the App with Logs
```bash
cd c:\dev\GitHub\25AACR02
flutter run
```

### Step 2: Attempt Signup with Profile Picture
1. Open the app
2. Navigate to Signup
3. Fill in all fields on page 1
4. **Select a profile picture**
5. Click NEXT
6. Fill in fields on page 2
7. Click SUBMIT

### Step 3: Check Console Logs

Look for these log messages in the Flutter console:

#### Success Flow:
```
📸 Profile image file found, starting upload...
🖼️ Starting profile image upload...
🖼️ File path: /data/user/0/.../cache/image_picker...
🖼️ File exists: true
🖼️ Upload URL: https://skillsocket-backend.onrender.com/api/user/upload-logo-public
🖼️ File added to request. Sending...
🖼️ Response status code: 200
🖼️ Response body: {"msg":"Profile image uploaded successfully","logoUrl":"https://..."}
🖼️ Upload successful! URL: https://cloudinary.../image.jpg
✅ Profile image uploaded successfully: https://...
```

#### Failure Scenarios:

**Scenario 1: Network Error**
```
📸 Profile image file found, starting upload...
🖼️ Starting profile image upload...
🖼️ File path: /data/user/0/.../cache/image_picker...
🖼️ File exists: true
🖼️ Upload URL: https://skillsocket-backend.onrender.com/api/user/upload-logo-public
🖼️ File added to request. Sending...
❌ Profile image upload exception: SocketException: Failed host lookup...
❌ Stack trace: ...
❌ Profile image upload returned null
```
**Solution**: Check internet connection

**Scenario 2: Backend Not Deployed**
```
📸 Profile image file found, starting upload...
🖼️ Starting profile image upload...
...
🖼️ Response status code: 404
🖼️ Response body: {"error":"Not Found"}
❌ Profile image upload error: 404
❌ Response body: {"error":"Not Found"}
❌ Profile image upload returned null
```
**Solution**: Deploy backend changes to Render

**Scenario 3: Backend Error**
```
📸 Profile image file found, starting upload...
🖼️ Starting profile image upload...
...
🖼️ Response status code: 500
🖼️ Response body: {"msg":"Internal server error","error":"..."}
❌ Profile image upload error: 500
❌ Response body: {"msg":"Internal server error",...}
❌ Profile image upload returned null
```
**Solution**: Check Render backend logs for errors

**Scenario 4: File Not Found**
```
📸 Profile image file found, starting upload...
🖼️ Starting profile image upload...
🖼️ File path: /data/user/0/.../cache/image_picker...
🖼️ File exists: false
❌ Profile image upload exception: FileSystemException: Cannot open file...
❌ Profile image upload returned null
```
**Solution**: Image picker issue, try different image

**Scenario 5: No File Selected**
```
ℹ️ No profile image file provided
```
**This is normal** - user didn't select a profile picture

## Common Issues & Solutions

### Issue 1: Backend Not Deployed
**Symptoms**:
- Status code: 404
- Response: "Not Found" or "Cannot GET /api/user/upload-logo-public"

**Solution**:
```bash
# Deploy backend
cd c:\dev\GitHub\25AACR02
git add .
git commit -m "Add public upload endpoint for signup"
git push origin main

# Wait for Render deployment (2-5 minutes)
# Check: https://skillsocket-backend.onrender.com/api/health
```

### Issue 2: Cloudinary Not Configured
**Symptoms**:
- Status code: 500
- Response body mentions "cloudinary" or "upload_stream"

**Solution**:
Check Render environment variables:
- `CLOUDINARY_CLOUD_NAME`
- `CLOUDINARY_API_KEY`
- `CLOUDINARY_API_SECRET`

### Issue 3: Multer/Upload Middleware Issue
**Symptoms**:
- Status code: 400
- Response: "No logo file provided"

**Solution**:
Check backend logs for multer errors. Verify the field name is 'logo':
```dart
// Frontend
await http.MultipartFile.fromPath('logo', profileImageFile.path)

// Backend
router.post('/upload-logo-public', upload.single('logo'), ...)
```

### Issue 4: Network/Timeout
**Symptoms**:
- Exception: SocketException, TimeoutException
- No response received

**Solution**:
- Check device internet connection
- Try on WiFi instead of mobile data
- Check if Render backend is awake (first request after idle takes ~30s)

### Issue 5: File Permissions
**Symptoms**:
- Exception: FileSystemException
- File exists: false

**Solution**:
- Check app permissions for storage/camera
- Try selecting image from gallery instead of camera
- Restart app and try again

## Testing Checklist

### Pre-Test Setup
- [ ] Backend deployed to Render
- [ ] Health endpoint returns 200: `curl https://skillsocket-backend.onrender.com/api/health`
- [ ] Cloudinary credentials configured in Render
- [ ] App has storage/camera permissions

### Test Cases

#### Test 1: Signup WITHOUT Profile Picture
1. Fill signup form (don't select image)
2. Submit
3. **Expected**: Should succeed, user created without profileImage
4. **Check logs**: `ℹ️ No profile image file provided`

#### Test 2: Signup WITH Profile Picture (Small Image)
1. Fill signup form
2. Select small image (< 1MB)
3. Submit
4. **Expected**: Upload succeeds, user created with profileImage
5. **Check logs**: `✅ Profile image uploaded successfully: https://...`
6. **Verify**: Profile picture appears in profile page

#### Test 3: Signup WITH Profile Picture (Large Image)
1. Fill signup form
2. Select large image (> 5MB)
3. Submit
4. **Expected**: May take longer but should succeed
5. **Check logs**: Watch for timeout or success

#### Test 4: Network Failure
1. Fill signup form
2. Select image
3. Turn off internet
4. Submit
5. **Expected**: Error message about connection
6. **Check logs**: `❌ Profile image upload exception: SocketException...`

#### Test 5: Backend Down
1. Stop Render backend (or use wrong URL for testing)
2. Fill signup form
3. Select image
4. Submit
5. **Expected**: Error message
6. **Check logs**: `❌ Profile image upload error: 404` or timeout

## Backend Verification

### Check Backend Logs (Render Dashboard)

Look for these messages:

**Success**:
```
🖼️ Public upload logo called (signup)
🖼️ Profile image uploaded successfully (public): https://res.cloudinary.com/...
```

**Failure**:
```
Upload profile image error (public): [error details]
```

### Test Backend Directly

Use curl or Postman to test the endpoint:

```bash
# Test public upload endpoint
curl -X POST https://skillsocket-backend.onrender.com/api/user/upload-logo-public \
  -F "logo=@/path/to/test-image.jpg"

# Expected response:
{
  "msg": "Profile image uploaded successfully",
  "logoUrl": "https://res.cloudinary.com/.../image.jpg"
}
```

## Quick Fixes

### Fix 1: Restart Backend
If backend is sleeping (Render free tier):
1. Visit: https://skillsocket-backend.onrender.com/api/health
2. Wait 30 seconds for backend to wake up
3. Try signup again

### Fix 2: Clear App Cache
```bash
flutter clean
flutter pub get
flutter run
```

### Fix 3: Test with Different Image
- Try smaller image
- Try different format (JPG vs PNG)
- Try image from gallery vs camera

### Fix 4: Bypass Image Upload (Temporary)
For testing other signup functionality:
1. Don't select a profile picture
2. Complete signup
3. Add profile picture later from profile page

## Monitoring

### Real-Time Debugging

**Terminal 1 - Flutter App**:
```bash
flutter run
# Watch for 🖼️ and ❌ emoji logs
```

**Terminal 2 - Backend Logs** (if running locally):
```bash
cd lib/backend
npm start
# Watch for 🖼️ logs
```

**Browser - Render Dashboard**:
- Go to your service → Logs tab
- Watch for upload-related logs in real-time

## Success Criteria

Upload is working correctly when you see:

1. ✅ Flutter logs show: `✅ Profile image uploaded successfully`
2. ✅ Backend logs show: `🖼️ Profile image uploaded successfully (public)`
3. ✅ Signup completes without error
4. ✅ Profile picture appears in profile page
5. ✅ Image URL starts with `https://res.cloudinary.com/`

## Next Steps After Debugging

Once you identify the issue from logs:

1. **If 404 Error** → Deploy backend
2. **If 500 Error** → Check Cloudinary config
3. **If Network Error** → Check internet connection
4. **If File Error** → Check app permissions
5. **If Success** → Test profile page to verify image displays

## Report Format

When reporting issues, include:

```
**Device**: [Android/iOS]
**Flutter Version**: [run: flutter --version]
**Backend Status**: [Check health endpoint]
**Error Logs**: [Copy from console]
**Steps**: [What you did]
**Expected**: [What should happen]
**Actual**: [What actually happened]
```

---

**Run the app now and check the console logs to see exactly where the upload is failing!**
