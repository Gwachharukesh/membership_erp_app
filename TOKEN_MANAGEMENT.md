# Token Management - Fixed Implementation

## Overview
The app now properly manages two types of tokens for different API endpoints:
- **Login Token (accessToken)**: Used for most API calls after user login
- **Master Token (masterToken)**: Used only for OTP generation, OTP verification, and customer registration

## Token Flow

### 1. Login Flow
When user logs in:
```dart
AuthRepository.signin(username, password, isForMasterToken: false)
↓
API calls: POST /token
↓
Response saved as:
- accessToken (key: "accessToken") - for most API calls
- loginUserName, userId, customerCode, etc.
```

### 2. Master Token Flow
When admin credentials are used:
```dart
AuthRepository.signin(username: "admin", password: "...", isForMasterToken: true)
↓
API calls: POST /token
↓
Response saved as:
- masterToken (key: "masterToken") - for Pre-login endpoints only
```

## Token Usage by Endpoint

### Endpoints Using Login Token (accessToken)
These endpoints use the **AuthorizationInterceptor** which automatically adds the login token:
- `POST /Customer/GetSalesPoint` - Dashboard summary (now explicitly sets header)
- `GET /General/GetUserDetail` - User details
- All other authenticated endpoints after login

**Implementation:**
```dart
// Dashboard Service - NOW FIXED
SharedPreferences prefs = await SharedPreferences.getInstance();
String? accessToken = prefs.getString(SharedConstant.accessToken);

response = await dioClient.post(
  '/Customer/GetSalesPoint',
  options: Options(
    headers: {
      'Authorization': 'Bearer $accessToken',
    },
  ),
);
```

### Endpoints Using Master Token (masterToken)
These endpoints explicitly set the master token in headers:
- `POST /Customer/GenerateOTP` - Generate OTP (Pre-login)
- `POST /Customer/IsValidOTP` - Verify OTP (Pre-login)
- `PUT /Customer/Register` - Create new customer (Pre-login)

**Implementation:**
```dart
// OTP Service
var token = pref.getString(SharedConstant.masterToken) ?? 
            pref.getString(SharedConstant.accessToken); // Fallback

response = await dioClient.post(
  Endpoints.generateOtp,
  data: jsonEncode(otpData.toJson()),
  options: Options(headers: {'Authorization': 'Bearer $token'}),
);
```

## Fixes Applied

### 1. ✅ Dashboard Service Token Header
**Problem:** Service didn't explicitly set Authorization header, causing 401 errors
**Solution:** Added explicit Bearer token header reading from SharedPreferences

### 2. ✅ masterToken Key Typo Fixed
**Problem:** Key was `'masterTOken'` (capital O) instead of `'masterToken'`
**Solution:** Corrected in SharedConstant.dart

### 3. ✅ Token Fallback Logic
**Problem:** If master token not set, services would fail
**Solution:** Added fallback logic to use accessToken if masterToken not found
```dart
var token = pref.getString(SharedConstant.masterToken) ?? 
            pref.getString(SharedConstant.accessToken);
```

### 4. ✅ Customer Registration Token Validation
**Problem:** No null check for token before API call
**Solution:** Added validation that returns meaningful error if token missing

## SharedConstant Keys Reference

```dart
accessToken = 'accessToken'        // Login user's token
masterToken = 'masterToken'        // Master/admin token (FIXED: was 'masterTOken')
tokenType = 'tokenType'            // Bearer
refreshToken = 'refreshToken'      // For token refresh
userId = 'userId'
userName = 'userName'
customerCode = 'customerCode'
```

## Interceptor Chain
When a request is made, interceptors process in this order:
1. **CustomRetryInterceptor** - Retries failed requests (not PUT/idempotent updates)
2. **ChuckerDioInterceptor** - Logs HTTP requests/responses for debugging
3. **AuthorizationInterceptor** - Adds "Bearer accessToken" header (if token exists)

**Note:** Endpoints that explicitly set Authorization headers (OTP, Customer Registration) bypass the automatic header injection, allowing use of different tokens.

## Error Handling

### 401 Unauthorized Response
When API returns 401:
1. AuthorizationInterceptor catches it
2. Attempts to refresh token using stored credentials
3. If refresh fails, redirects to login screen
4. For explicit token endpoints: Returns meaningful error message

### Missing Token Error
When token is not found in SharedPreferences:
- Dashboard: EasyLoading.showError() and returns empty DashboardSummaryModel
- OTP Service: Uses fallback to accessToken if available
- Customer Registration: Returns explicit error message "Authentication token not found"

## Testing Checklist

- [ ] Login with regular user credentials → accessToken saved
- [ ] Dashboard GetSalesPoint endpoint returns data (401 error fixed)
- [ ] OTP Generation works with master token
- [ ] OTP Verification works with master token
- [ ] Customer Registration works with master token
- [ ] Logout clears tokens properly
- [ ] Re-login after logout works correctly
- [ ] 401 errors show proper error messages (not silent failures)

## Key Changes Summary

| File | Change | Reason |
|------|--------|--------|
| dashboard_summary_service.dart | Added explicit Authorization header | Fix 401 invalid user error |
| shared_constant.dart | Fixed masterToken key typo | Prevent null token reads |
| otp_service.dart | Added token fallback logic | Robust token handling |
| add_customer_service.dart | Added token validation | Better error messages |

