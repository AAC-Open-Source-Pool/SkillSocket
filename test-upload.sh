#!/bin/bash

# Test script for profile image upload endpoints

echo "🧪 Testing Profile Image Upload Endpoints"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

BASE_URL="http://localhost:3000"

# Test 1: Health Check
echo "📋 Test 1: Health Check"
echo "URL: $BASE_URL/api/health"
HEALTH_RESPONSE=$(curl -s -w "\n%{http_code}" $BASE_URL/api/health)
HTTP_CODE=$(echo "$HEALTH_RESPONSE" | tail -n1)
BODY=$(echo "$HEALTH_RESPONSE" | sed '$d')

if [ "$HTTP_CODE" = "200" ]; then
    echo -e "${GREEN}✅ Health check passed${NC}"
    echo "Response: $BODY"
else
    echo -e "${RED}❌ Health check failed (HTTP $HTTP_CODE)${NC}"
    echo "Response: $BODY"
fi
echo ""

# Test 2: Check if public upload endpoint exists
echo "📋 Test 2: Public Upload Endpoint (OPTIONS)"
echo "URL: $BASE_URL/api/user/upload-logo-public"
OPTIONS_RESPONSE=$(curl -s -X OPTIONS -w "\n%{http_code}" $BASE_URL/api/user/upload-logo-public)
HTTP_CODE=$(echo "$OPTIONS_RESPONSE" | tail -n1)

if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "204" ]; then
    echo -e "${GREEN}✅ Endpoint exists${NC}"
elif [ "$HTTP_CODE" = "404" ]; then
    echo -e "${RED}❌ Endpoint not found (404)${NC}"
    echo -e "${YELLOW}⚠️  Backend needs to be deployed with the new endpoint${NC}"
else
    echo -e "${YELLOW}⚠️  Unexpected response (HTTP $HTTP_CODE)${NC}"
fi
echo ""

# Test 3: Try upload without file (should fail with 400)
echo "📋 Test 3: Upload Without File (should return 400)"
echo "URL: $BASE_URL/api/user/upload-logo-public"
NO_FILE_RESPONSE=$(curl -s -X POST -w "\n%{http_code}" $BASE_URL/api/user/upload-logo-public)
HTTP_CODE=$(echo "$NO_FILE_RESPONSE" | tail -n1)
BODY=$(echo "$NO_FILE_RESPONSE" | sed '$d')

if [ "$HTTP_CODE" = "400" ]; then
    echo -e "${GREEN}✅ Correctly returns 400 for missing file${NC}"
    echo "Response: $BODY"
elif [ "$HTTP_CODE" = "404" ]; then
    echo -e "${RED}❌ Endpoint not found (404)${NC}"
    echo -e "${YELLOW}⚠️  Deploy backend with: git push origin main${NC}"
else
    echo -e "${YELLOW}⚠️  Unexpected response (HTTP $HTTP_CODE)${NC}"
    echo "Response: $BODY"
fi
echo ""

# Test 4: Check authenticated endpoint (should require auth)
echo "📋 Test 4: Authenticated Upload Endpoint (should require auth)"
echo "URL: $BASE_URL/api/user/upload-logo"
AUTH_RESPONSE=$(curl -s -X POST -w "\n%{http_code}" $BASE_URL/api/user/upload-logo)
HTTP_CODE=$(echo "$AUTH_RESPONSE" | tail -n1)
BODY=$(echo "$AUTH_RESPONSE" | sed '$d')

if [ "$HTTP_CODE" = "401" ]; then
    echo -e "${GREEN}✅ Correctly requires authentication${NC}"
    echo "Response: $BODY"
else
    echo -e "${YELLOW}⚠️  Unexpected response (HTTP $HTTP_CODE)${NC}"
    echo "Response: $BODY"
fi
echo ""

# Summary
echo "=========================================="
echo "📊 Test Summary"
echo "=========================================="
echo ""
echo "If all tests passed:"
echo "  ✅ Backend is deployed and working"
echo "  ✅ Public upload endpoint is available"
echo "  ✅ Ready to test from Flutter app"
echo ""
echo "If Test 2 or 3 failed with 404:"
echo "  ❌ Backend needs deployment"
echo "  📝 Run: git add . && git commit -m 'Add public upload' && git push"
echo "  ⏳ Wait 2-5 minutes for Render deployment"
echo "  🔄 Run this script again"
echo ""
echo "Next steps:"
echo "  1. Run Flutter app: flutter run"
echo "  2. Try signup with profile picture"
echo "  3. Check Flutter console for 🖼️ logs"
echo "  4. Check Render logs for backend errors"
echo ""
