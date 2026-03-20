# User Detail API Integration Guide

This implementation provides a complete solution for fetching user details from the `/General/GetUserDetail` endpoint with beautiful error handling and BLoC state management.

## 📋 Files Created

### 1. **Models** (`lib/features/customer/models/`)
- **user_detail_model.dart** - Data model for user details with JSON serialization

### 2. **Services** (`lib/features/customer/service/`)
- **user_detail_service.dart** - API service that calls `/General/GetUserDetail` endpoint
  - Handles network errors gracefully
  - Returns structured `ApiResponseData` with error messages
  - Supports query parameters and headers

### 3. **BLoC** (`lib/features/customer/bloc/`)
- **user_detail_bloc.dart** - Main BLoC class for state management
- **user_detail_event.dart** - Events: `FetchUserDetail`, `ResetUserDetailError`, `ClearUserDetail`
- **user_detail_state.dart** - States: `initial`, `loading`, `success`, `error`, `networkError`

### 4. **UI Widgets** (`lib/features/customer/widgets/`)
- **api_error_widget.dart** - Reusable error display components
  - Dialog version for modal error display
  - BottomSheet version for inline error display
  - Snackbar version for quick notifications
  - Beautiful, responsive UI with Sizer

### 5. **Example View** (`lib/features/customer/screen/`)
- **user_detail_view.dart** - Complete example showing how to use everything
  - Displays user details in a card-based layout
  - Handles loading, success, and error states
  - Includes retry functionality

### 6. **Integration Guide**
- **integration_guide.dart** - Comprehensive documentation with code examples

## 🚀 Quick Start

### Step 1: Add BLoC Provider

```dart
BlocProvider(
  create: (context) => UserDetailBloc(),
  child: YourApp(),
),
```

### Step 2: Fetch User Details

```dart
context.read<UserDetailBloc>().add(
  FetchUserDetail(userId: 1007),
);
```

### Step 3: Handle State with Listener

```dart
BlocListener<UserDetailBloc, UserDetailState>(
  listener: (context, state) {
    if (state.status == UserDetailStatus.error) {
      // Show error dialog
      showDialog(
        context: context,
        builder: (_) => ApiErrorWidget(
          errorMessage: state.errorMessage ?? 'Unknown error',
          isNetworkError: state.isNetworkError,
          onRetry: () {
            context.read<UserDetailBloc>().add(
              FetchUserDetail(userId: userId),
            );
          },
        ),
      );
    }
  },
  child: YourWidget(),
)
```

### Step 4: Display User Details

```dart
BlocBuilder<UserDetailBloc, UserDetailState>(
  builder: (context, state) {
    if (state.status == UserDetailStatus.loading) {
      return CircularProgressIndicator();
    }
    
    if (state.status == UserDetailStatus.success) {
      final userDetail = state.userDetail;
      return Text('Name: ${userDetail?.name}');
    }
    
    return SizedBox.shrink();
  },
)
```

## 🎨 Error Display Options

### Option 1: Dialog (Modal)
```dart
showDialog(
  context: context,
  builder: (_) => ApiErrorWidget(
    errorMessage: errorMessage,
    isNetworkError: false,
    onRetry: onRetry,
  ),
);
```

### Option 2: Bottom Sheet
```dart
showApiErrorBottomSheet(
  context,
  errorMessage: errorMessage,
  isNetworkError: false,
  onRetry: onRetry,
);
```

### Option 3: Snackbar
```dart
showApiErrorSnackbar(
  context,
  message: errorMessage,
  isNetworkError: false,
  durationSeconds: 5,
);
```

## 📡 API Endpoint Details

**Endpoint:** `GET /General/GetUserDetail`

**Query Parameters:**
```
userId: int (required) - User ID to fetch
```

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Request Example:**
```
GET /General/GetUserDetail?userId=1007
Headers: Authorization: Bearer <token>
```

## ✅ Response Model

The API returns a `UserDetailModel` with these fields:
- `userId` - User ID
- `userName` - Username
- `name` - Full name
- `email` - Email address
- `mobileNo` - Mobile number
- `companyName` - Company name
- `branch` - Branch/Department
- `address` - Complete address
- `photoPath` - Photo URL
- `isSuccess` - Success flag
- `responseMSG` - Message from server
- ... (and more)

## 🔄 BLoC Events

| Event | Description | Usage |
|-------|-------------|-------|
| `FetchUserDetail(userId)` | Fetch user details for a specific user ID | `context.read<UserDetailBloc>().add(FetchUserDetail(userId: 1007))` |
| `ResetUserDetailError()` | Clear error message | `context.read<UserDetailBloc>().add(ResetUserDetailError())` |
| `ClearUserDetail()` | Clear all data and reset | `context.read<UserDetailBloc>().add(ClearUserDetail())` |

## 📊 BLoC States

| State | Status | Description |
|-------|--------|-------------|
| `UserDetailState()` | `initial` | Initial state, no data loaded |
| `UserDetailState()` | `loading` | Fetching data from API |
| `UserDetailState()` | `success` | Data loaded successfully |
| `UserDetailState()` | `error` | API returned an error |
| `UserDetailState()` | `networkError` | Network/connectivity error |

## 🛡️ Error Handling

The service handles various error types:

- **Network Errors** - No internet connection, timeout
- **Server Errors** - 500, 502, 503, etc.
- **Client Errors** - 400, 401, 404, etc.
- **Timeout Errors** - Request took too long
- **Parsing Errors** - Invalid JSON response

Each error shows a user-friendly message and optionally a "Retry" button.

## 🎯 Complete Usage Example

```dart
class MyCustomerScreen extends StatefulWidget {
  final int customerId;
  
  const MyCustomerScreen({required this.customerId});

  @override
  State<MyCustomerScreen> createState() => _MyCustomerScreenState();
}

class _MyCustomerScreenState extends State<MyCustomerScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch user details when screen loads
    context.read<UserDetailBloc>().add(
      FetchUserDetail(userId: widget.customerId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Customer Details')),
      body: BlocListener<UserDetailBloc, UserDetailState>(
        listener: (context, state) {
          if (state.status == UserDetailStatus.error) {
            showApiErrorBottomSheet(
              context,
              errorMessage: state.errorMessage ?? 'Unknown error',
              isNetworkError: state.isNetworkError,
              onRetry: () {
                context.read<UserDetailBloc>().add(
                  FetchUserDetail(userId: widget.customerId),
                );
              },
            );
          }
        },
        child: BlocBuilder<UserDetailBloc, UserDetailState>(
          builder: (context, state) {
            return switch (state.status) {
              UserDetailStatus.loading => 
                Center(child: CircularProgressIndicator()),
              UserDetailStatus.success => 
                _buildSuccessUI(state.userDetail),
              UserDetailStatus.error => 
                _buildErrorUI(state.errorMessage),
              _ => Center(child: Text('No data')),
            };
          },
        ),
      ),
    );
  }

  Widget _buildSuccessUI(UserDetailModel? userDetail) {
    if (userDetail == null) return SizedBox.shrink();
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Name: ${userDetail.name}'),
          Text('Email: ${userDetail.emailId}'),
          Text('Company: ${userDetail.companyName}'),
          Text('Branch: ${userDetail.branch}'),
        ],
      ),
    );
  }

  Widget _buildErrorUI(String? errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, size: 50, color: Colors.red),
          SizedBox(height: 16),
          Text(errorMessage ?? 'Unknown error'),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<UserDetailBloc>().add(
                FetchUserDetail(userId: widget.customerId),
              );
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }
</code>
```

## 📝 Notes

- All UI components use **Sizer** for responsive sizing
- States are **immutable** using `Equatable`
- Services use **Dio** with token-based authentication
- Error messages are user-friendly and actionable
- Supports **retry functionality** for failed requests
- All errors include proper **logging and tracking**

## 🔧 Customization

You can customize:
- Error message translations
- UI colors and styling
- Timeout durations
- Retry button behavior
- Success/error animations

All of these can be easily modified in their respective files.
