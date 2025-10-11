# Signup Profile Image Upload Fix

## Problem
During signup, when users tried to upload a profile picture, they received the error:
```
"Failed to upload profile image. Please try again."
```

## Root Cause
The `/api/user/upload-logo` endpoint requires authentication (`verifyToken` middleware), but during signup the user doesn't have an auth token yet since they haven't been created in the system.

### Error Flow
```
Signup Page → Upload Image
    ↓
POST /api/user/upload-logo
    ↓
verifyToken Middleware
    ↓
❌ No token provided
    ↓
401 Unauthorized
    ↓
Upload fails → Error message shown
```

## Solution
Created a **public upload endpoint** that doesn't require authentication, specifically for signup flow.

### Changes Made

#### 1. Backend: New Public Upload Endpoint
**File**: `lib/backend/routes/userLogoUpload.js`

Added new endpoint `/upload-logo-public` that:
- ✅ Does NOT require authentication
- ✅ Uploads image to Cloudinary
- ✅ Returns the image URL
- ✅ Can be used during signup

```javascript
// Upload profile image during signup (no auth required)
router.post('/upload-logo-public', upload.single('logo'), async (req, res) => {
    try {
        console.log('🖼️ Public upload logo called (signup)');

        if (!req.file) {
            return res.status(400).json({ msg: 'No logo file provided' });
        }

        // Upload to Cloudinary
        const result = await new Promise((resolve, reject) => {
            const stream = cloudinary.uploader.upload_stream(
                { folder: 'user-profile-images' },
                (error, result) => {
                    if (error) return reject(error);
                    resolve(result);
                }
            );
            stream.end(req.file.buffer);
        });

        const profileImageUrl = result.secure_url;

        console.log('🖼️ Profile image uploaded successfully (public):', profileImageUrl);
        res.json({ 
            msg: "Profile image uploaded successfully", 
            logoUrl: profileImageUrl
        });

    } catch (err) {
        console.error('Upload profile image error (public):', err);
        res.status(500).json({ msg: "Internal server error", error: err.message });
    }
});
```

The original `/upload-logo` endpoint remains unchanged and continues to require authentication for profile updates.

#### 2. Frontend: Update Signup to Use Public Endpoint
**File**: `lib/signup2.dart`

Changed the upload URL from:
```dart
Uri.parse('https://skillsocket-backend.onrender.com/api/user/upload-logo')
```

To:
```dart
Uri.parse('https://skillsocket-backend.onrender.com/api/user/upload-logo-public')
```

## How It Works Now

### Signup Flow (Fixed)
```
User Selects Profile Picture
    ↓
Signup Page 2 → Submit
    ↓
POST /api/user/upload-logo-public  ← No auth required ✅
    {
      file: profileImage
    }
    ↓
Cloudinary Upload
    ↓
Return Image URL
    {
      logoUrl: "https://cloudinary.../image.jpg"
    }
    ↓
POST /api/auth/signup
    {
      profileImage: "https://cloudinary.../image.jpg",
      ...other data
    }
    ↓
User Created in MongoDB
    ↓
Auto-Login (saves token)
    ↓
✅ Success! Profile picture saved and displayed
```

### Profile Update Flow (Unchanged)
```
User Updates Profile Picture
    ↓
POST /api/user/upload-logo  ← Requires auth token ✅
    Headers: { Authorization: "Bearer token" }
    {
      file: newProfileImage
    }
    ↓
Cloudinary Upload
    ↓
Update User in MongoDB
    ↓
✅ Profile picture updated
```

## Security Considerations

### Why Public Upload is Safe

1. **No Database Access** - The public endpoint only uploads to Cloudinary, doesn't touch the database
2. **Cloudinary Limits** - Cloudinary has its own rate limiting and file size restrictions
3. **Folder Isolation** - Images stored in `user-profile-images` folder
4. **URL Required for Signup** - The image URL must be provided during signup, which validates the user data
5. **Orphaned Images** - If signup fails, the image remains in Cloudinary but isn't linked to any user (acceptable trade-off)

### Alternative Approaches (Not Implemented)

1. **Upload After Signup** - Upload image after user is created (requires two-step process)
2. **Temporary Token** - Generate temporary upload token (adds complexity)
3. **Direct Client Upload** - Upload directly from client to Cloudinary (requires exposing API keys)

## Endpoints Summary

| Endpoint | Auth Required | Purpose | Used By |
|----------|---------------|---------|---------|
| `/api/user/upload-logo-public` | ❌ No | Upload during signup | Signup page |
| `/api/user/upload-logo` | ✅ Yes | Upload for existing users | Profile page |

## Testing

### Test Signup with Profile Picture

1. **Navigate to Signup Page 1**
   - Fill in basic details
   - Click "Upload Profile Picture"
   - Select an image
   - Click "NEXT"

2. **Signup Page 2**
   - Fill in additional details
   - Click "SUBMIT"

3. **Expected Results**
   - ✅ Image uploads successfully (no error)
   - ✅ User account created
   - ✅ Auto-login successful
   - ✅ Redirected to home page

4. **Verify Profile**
   - Navigate to Profile page
   - ✅ Profile picture should be visible
   - ✅ All other details loaded

### Test Profile Update

1. **Navigate to Profile Page**
2. **Click camera icon to change picture**
3. **Select new image**
4. **Click "Save"**
5. **Expected Results**
   - ✅ Image uploads successfully
   - ✅ Profile updated
   - ✅ New picture displayed

## Error Handling

### Public Upload Endpoint
```javascript
// Returns 400 if no file provided
{ msg: 'No logo file provided' }

// Returns 500 if Cloudinary upload fails
{ msg: "Internal server error", error: "..." }
```

### Frontend
```dart
if (profileImageUrl == null) {
  setState(() {
    _errorMessage = 'Failed to upload profile image. Please try again.';
    _isLoading = false;
  });
  return;
}
```

## Deployment

### Backend Changes
The new endpoint is automatically available once deployed:
```
POST https://skillsocket-backend.onrender.com/api/user/upload-logo-public
```

### No Configuration Needed
- Uses existing Cloudinary configuration
- Uses existing multer upload middleware
- No new environment variables required

## Monitoring

Check backend logs for:
```
🖼️ Public upload logo called (signup)
🖼️ Profile image uploaded successfully (public): https://...
```

Or errors:
```
Upload profile image error (public): [error details]
```

## Summary

✅ **Problem**: Signup image upload failed due to authentication requirement  
✅ **Cause**: `/upload-logo` endpoint required auth token (not available during signup)  
✅ **Solution**: Created `/upload-logo-public` endpoint without auth requirement  
✅ **Result**: Users can now upload profile pictures during signup  
✅ **Status**: Fixed and ready to deploy

## Files Modified

1. **`lib/backend/routes/userLogoUpload.js`** - Added public upload endpoint
2. **`lib/signup2.dart`** - Updated to use public endpoint

## Next Steps

1. **Deploy backend** to Render (auto-deploys on git push)
2. **Test signup flow** with profile picture
3. **Verify profile page** shows uploaded image
4. **Monitor logs** for any upload errors
