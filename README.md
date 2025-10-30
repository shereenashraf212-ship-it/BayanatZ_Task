# Request Tracking & Approval System

A Flutter-based request management and approval system with Firebase integration, featuring real-time status updates, advanced filtering, and responsive design.

## 📋 Overview

This application provides a comprehensive solution for managing employee requests such as sick leave, transactions, and other approval workflows. Built with Flutter and Firebase, it offers a clean, responsive interface for tracking and processing requests across mobile, tablet, and desktop platforms.

## ✨ Features

### Core Functionality
- **Real-time Request Management**: View, approve, reject, or cancel requests instantly
- **Advanced Filtering**: Filter requests by status (All, Approved, Pending, Rejected, Canceled)
- **Multi-criteria Search**: Filter by job title, department, and request type
- **Smart Search**: Search requests by employee name with real-time updates
- **Responsive Design**: Optimized layouts for mobile, tablet, and desktop views
- **Firebase Integration**: Cloud-based storage with automatic synchronization

### Request Status Types
- ✅ **Approved**: Requests that have been accepted
- ⏳ **Pending**: Requests awaiting review
- ❌ **Rejected**: Requests that have been denied
- 🚫 **Canceled**: Requests that have been withdrawn

### UI Features
- Dynamic status counters showing request distribution
- Grid-based card layout adapting to screen size
- Light/dark mode support
- Search with debouncing for optimal performance
- Empty state handling with contextual messages

## 🏗️ Architecture

### Project Structure
```
lib/
├── features/
│   └── approvals/
│       ├── presentation/
│       │   ├── ui/
│       │   │   ├── screens/
│       │   │   │   └── approval_screen.dart
│       │   │   └── widgets/
│       │   │       ├── card_item.dart
│       │   │       ├── filter.dart
│       │   │       ├── filter_icon_widget.dart
│       │   │       └── header_employee.dart
│       │   └── controller/
│       │       ├── requestcubit_cubit.dart
│       │       └── requestcubit_state.dart
│       ├── domain/
│       │   └── repo.dart
│       └── data/
│           ├── model/
│           │   └── employee_model.dart
│           └── repository/
│               └── request_repository_impl.dart
├── core/
│   ├── extention.dart
│   └── search_widget.dart
└── firebase_options.dart
```

### Architecture Pattern
The application follows **Clean Architecture** principles with **BLoC** (Business Logic Component) pattern:

- **Presentation Layer**: UI components and state management
- **Domain Layer**: Business logic and repository interfaces
- **Data Layer**: Data models and repository implementations

## 🔧 Technical Stack

### Core Dependencies
```yaml
dependencies:
  flutter: sdk
  flutter_bloc: ^8.x.x           # State management
  flutter_screenutil: ^5.x.x     # Responsive sizing
  flutter_svg: ^2.x.x            # SVG asset support
  firebase_core: ^2.x.x          # Firebase initialization
  cloud_firestore: ^4.x.x        # Cloud database
```

## 📦 Data Model

### RequestModel

## 🎯 Key Components

### 1. ApprovalScreen (Main UI)
The primary screen managing the entire request approval workflow.

**State Management:**
- `selectedFilter`: Current status filter (All/Approved/Pending/Rejected)
- `searchQuery`: Search text for filtering by employee name
- `selectedJobTitle`: Job title filter
- `selectedDepartment`: Department filter
- `selectedRequestType`: Request type filter

**Key Methods:**
- `_filterRequests()`: Applies all active filters to the request list
- `_showMessageDialog()`: Displays message dialog (placeholder)

### 2. RequestCubit (State Management)
Manages all business logic and Firebase interactions.

**Methods:**
- `getRequests()`: Fetches all requests from Firestore
- `updateStatus(requestId, status)`: Updates request status
- `deleteRequest(requestId)`: Removes a request from the database

**States:**
- `RequestcubitInitial`: Initial state
- `RequestcubitLoading`: Loading requests
- `RequestcubitLoaded`: Requests loaded successfully
- `RequestcubitError`: Error occurred
- `RequestcubitStatusUpdated`: Status updated successfully

### 3. RequestRepository
Abstraction layer for data operations.

**Interface Methods:**
```dart
Future<void> uploadRequests(List<RequestModel> requests);
Future<List<RequestModel>> getRequests();
Future<void> updateRequestStatus(String requestId, String status);
Future<void> deleteRequest(String requestId);
```

### 4. RequestRepositoryImpl
Firebase implementation of the repository pattern.

**Firestore Collection:** `Request_Data`

**Features:**
- Batch operations for bulk uploads
- Ordered queries (by requestDate, descending)
- Error handling with descriptive exceptions

## 🔄 Data Flow

1. **User Interaction** → Widget triggers event
2. **Event Handling** → ApprovalScreen calls RequestCubit method
3. **Business Logic** → Cubit processes request and calls repository
4. **Data Layer** → Repository interacts with Firestore
5. **State Emission** → Cubit emits new state
6. **UI Update** → BlocBuilder rebuilds affected widgets

## 🎨 UI Components

### Filter System
- **Status Tabs**: Visual counters for each status category
- **Search Bar**: Real-time search with debouncing
- **Advanced Filters**: Dialog-based multi-criteria filtering

### Request Cards
Each card displays:
- Request type icon
- Employee information
- Job title and department
- Request and timeframe dates
- Total duration
- Action buttons (Approve/Reject) or status indicator

### Responsive Grid
- **Mobile**: Single column layout
- **Tablet**: 2-column grid
- **Desktop**: 3-column grid

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Firebase project with Firestore enabled
- Valid `firebase_options.dart` configuration

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd task_bayanat
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Configure Firebase**
- Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
- Enable Firestore Database
- Download configuration files for your platforms
- Run FlutterFire CLI (optional):
```bash
flutterfire configure
```

4. **Run the application**
```bash
flutter run
```

## 🗄️ Firestore Structure

### Collection: `Request_Data`
```javascript
{
  requestedBy: "Ahmed Wael",
  jobTitle: "Marketing Manager",
  department: "UI/UX Design",
  requestDate: Timestamp,
  totalTime: 3.0,
  requestedTimeframe: "15 Oct 2024 To 17 Oct 2024",
  status: "pending"
}
```

### Indexes Required
Firestore automatically creates indexes for simple queries. For complex filtering, you may need composite indexes:
```
Collection: Request_Data
Fields: status (Ascending), requestDate (Descending)
```

## 🔐 Firebase Security Rules

Recommended Firestore security rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /Request_Data/{document} {
      // Allow read access to all authenticated users
      allow read: if request.auth != null;
      
      // Allow write access to authenticated users with admin role
      allow write: if request.auth != null && 
                      request.auth.token.role == 'admin';
      
      // Allow status updates by authenticated users
      allow update: if request.auth != null && 
                       request.resource.data.diff(resource.data).affectedKeys()
                       .hasOnly(['status']);
    }
  }
}
```

## 📱 Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| Android  | ✅ Supported | API 21+ |
| iOS      | ✅ Supported | iOS 12+ |
| Web      | ✅ Supported | All modern browsers |
| macOS    | ✅ Supported | macOS 10.14+ |
| Windows  | ✅ Supported | Windows 10+ |
| Linux    | ⚠️ Not Configured | Firebase options needed |

## 🧪 Testing

### Running Tests
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test/
```

### Test Structure
```
test/
├── features/
│   └── approvals/
│       ├── presentation/
│       │   └── controller/
│       │       └── requestcubit_test.dart
│       └── data/
│           └── repository/
│               └── request_repository_impl_test.dart
└── mock/
    └── mock_firebase.dart
```

## 🐛 Troubleshooting

### Common Issues

**Issue**: Requests not loading
- **Solution**: Check Firebase configuration and internet connectivity
- Verify Firestore rules allow read access

**Issue**: Status update fails
- **Solution**: Ensure the request ID is valid
- Check Firestore write permissions

**Issue**: UI not responsive on tablet
- **Solution**: Verify `flutter_screenutil` initialization in main.dart


**Issue**: Search not working
- **Solution**: Verify `searchController` is properly initialized
- Check that `onChanged` callback is firing

## 🔮 Future Enhancements

- [ ] Add request type filtering (currently commented out)
- [ ] Implement real-time messaging functionality
- [ ] Add notification system for status changes
- [ ] Export requests to PDF/Excel
- [ ] Implement user authentication and role-based access
- [ ] Add request history and audit trail
- [ ] Support for file attachments
- [ ] Calendar view for timeframe visualization
- [ ] Analytics dashboard
- [ ] Multi-language support (Arabic/English toggle)

## 📄 Code Examples

### Creating a New Request

### Filtering Requests


### Updating Request Status

## 👥 Contributors

- **Amro Handousa** - Marketing Manager (UI Character)
- Development Team - Implementation

## 📞 Support

For issues, questions, or contributions:
- Open an issue on GitHub
- Contact the development team
- Check documentation at `/docs`

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Last Updated**: October 2025  
**Version**: 1.0.0  
**Flutter Version**: 3.24.0+  
**Firebase SDK**: Compatible with latest stable versions