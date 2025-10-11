# Test script for profile image upload endpoints (PowerShell)

Write-Host "🧪 Testing Profile Image Upload Endpoints" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

$BASE_URL = "https://skillsocket-backend.onrender.com"

# Test 1: Health Check
Write-Host "📋 Test 1: Health Check" -ForegroundColor Yellow
Write-Host "URL: $BASE_URL/api/health"
try {
    $response = Invoke-WebRequest -Uri "$BASE_URL/api/health" -Method GET -UseBasicParsing
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ Health check passed" -ForegroundColor Green
        Write-Host "Response: $($response.Content)"
    }
} catch {
    Write-Host "❌ Health check failed" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)"
}
Write-Host ""

# Test 2: Check if public upload endpoint exists
Write-Host "📋 Test 2: Public Upload Endpoint (POST without file)" -ForegroundColor Yellow
Write-Host "URL: $BASE_URL/api/user/upload-logo-public"
try {
    $response = Invoke-WebRequest -Uri "$BASE_URL/api/user/upload-logo-public" -Method POST -UseBasicParsing
    Write-Host "Response Code: $($response.StatusCode)"
    Write-Host "Response: $($response.Content)"
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    if ($statusCode -eq 400) {
        Write-Host "✅ Endpoint exists (returns 400 for missing file - expected)" -ForegroundColor Green
        try {
            $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
            $responseBody = $reader.ReadToEnd()
            Write-Host "Response: $responseBody"
        } catch {}
    } elseif ($statusCode -eq 404) {
        Write-Host "❌ Endpoint not found (404)" -ForegroundColor Red
        Write-Host "⚠️  Backend needs to be deployed with the new endpoint" -ForegroundColor Yellow
    } else {
        Write-Host "⚠️  Unexpected response (HTTP $statusCode)" -ForegroundColor Yellow
        Write-Host "Error: $($_.Exception.Message)"
    }
}
Write-Host ""

# Test 3: Check authenticated endpoint (should require auth)
Write-Host "📋 Test 3: Authenticated Upload Endpoint (should require auth)" -ForegroundColor Yellow
Write-Host "URL: $BASE_URL/api/user/upload-logo"
try {
    $response = Invoke-WebRequest -Uri "$BASE_URL/api/user/upload-logo" -Method POST -UseBasicParsing
    Write-Host "Response Code: $($response.StatusCode)"
    Write-Host "Response: $($response.Content)"
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    if ($statusCode -eq 401) {
        Write-Host "✅ Correctly requires authentication (401)" -ForegroundColor Green
        try {
            $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
            $responseBody = $reader.ReadToEnd()
            Write-Host "Response: $responseBody"
        } catch {}
    } else {
        Write-Host "⚠️  Unexpected response (HTTP $statusCode)" -ForegroundColor Yellow
        Write-Host "Error: $($_.Exception.Message)"
    }
}
Write-Host ""

# Summary
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "📊 Test Summary" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "If all tests passed:" -ForegroundColor Green
Write-Host "  ✅ Backend is deployed and working"
Write-Host "  ✅ Public upload endpoint is available"
Write-Host "  ✅ Ready to test from Flutter app"
Write-Host ""
Write-Host "If Test 2 failed with 404:" -ForegroundColor Yellow
Write-Host "  ❌ Backend needs deployment"
Write-Host "  📝 Run: git add . && git commit -m 'Add public upload' && git push"
Write-Host "  ⏳ Wait 2-5 minutes for Render deployment"
Write-Host "  🔄 Run this script again"
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Run Flutter app: flutter run"
Write-Host "  2. Try signup with profile picture"
Write-Host "  3. Check Flutter console for 🖼️ logs"
Write-Host "  4. Check Render logs for backend errors"
Write-Host ""
