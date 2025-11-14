<img width="1472" height="140" alt="image" src="https://github.com/user-attachments/assets/c80d2c61-60a2-4b62-8022-d245ef6dbeb3" /># 📱 Task List

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Material Design](https://img.shields.io/badge/Material%20Design%203-757575?style=for-the-badge&logo=material-design&logoColor=white)
![Parse](https://img.shields.io/badge/Parse%20Server-169CEE?style=for-the-badge&logo=parse&logoColor=white)

**A modern, feature-rich task management application built with Flutter and Parse Server**

[Features](#-features) • [Screenshots](#-screenshots) • [Installation](#-installation) • [Usage](#-usage) • [Contributing](#-contributing)

</div>

---

## 📖 About

Task Manager Pro is a cross-platform mobile application designed to help users organize, prioritize, and track their daily tasks efficiently. Built with Flutter and powered by Parse Server (Back4App), it offers a seamless experience with cloud synchronization, real-time updates, and a beautiful Material Design 3 interface.

### ✨ Highlights

- 🎨 **Beautiful UI** - Modern Material Design 3 with smooth animations
- 🌓 **Dark Mode** - Eye-friendly theme with persistent preference
- ☁️ **Cloud Sync** - Real-time data synchronization across devices
- 🔐 **Secure** - User authentication with Parse Server
- 📊 **Analytics** - Task statistics and completion tracking
- 🎯 **Smart Organization** - Priority levels, categories, and due dates
- 👆 **Intuitive Gestures** - Swipe to complete or delete tasks
- 🔍 **Advanced Search** - Find tasks quickly with filters

---

## 🚀 Features

### Core Functionality

#### 🔐 **Authentication**
- Secure user registration and login
- Email-based authentication
- Session management with auto-login
- Profile management

#### ✅ **Task Management**
- Create, read, update, and delete tasks
- Mark tasks as complete/incomplete
- Task titles and descriptions
- Organized task listing

#### 🎯 **Priority System**
- Three priority levels: High, Medium, Low
- Color-coded priority indicators
- Filter tasks by priority
- Visual priority badges

#### 🏷️ **Categories**
- Organize tasks by categories (Work, Personal, Shopping, etc.)
- Custom category creation
- Category-based filtering
- Autocomplete suggestions

#### 📅 **Due Dates**
- Set deadlines for tasks
- Visual overdue indicators
- Date picker integration
- Overdue task alerts

### Advanced Features

#### 📊 **Statistics Dashboard**
- Total, completed, and pending task counts
- Completion rate percentage
- Priority breakdown with visual bars
- Category distribution
- Overdue task tracking

#### 🔍 **Search & Filter**
- Real-time search functionality
- Filter by priority (High/Medium/Low)
- Filter by status (Completed/Pending)
- Filter by category
- Combined filter support

#### 🌓 **Dark Mode**
- Beautiful dark theme
- Toggle in settings
- Persistent preference storage
- Smooth theme transitions

#### 👆 **Swipe Gestures**
- Swipe right to mark complete
- Swipe left to delete
- Visual feedback
- Confirmation dialogs

#### ⚙️ **Settings**
- Theme customization
- Default priority selection
- Default category selection
- Notification preferences
- Profile management

#### 📱 **User Experience**
- Pull-to-refresh
- Loading indicators
- Success/error messages
- Smooth animations
- Responsive design

---

## 📸 Screenshots

<div align="center">

## https://drive.google.com/drive/folders/1O9WrLEauVo_3I0C_RULgjGeozVy6r7Jg?usp=sharing

</div>

---

## 🛠️ Tech Stack

### Frontend
- **Flutter 3.x** - UI framework
- **Dart** - Programming language
- **Material Design 3** - Design system
- **Provider** - State management
- **SharedPreferences** - Local storage

### Backend
- **Parse Server** - Backend as a Service
- **Back4App** - Cloud hosting
- **Parse SDK** - Flutter integration

### Key Packages
```yaml
dependencies:
  flutter:
    sdk: flutter
  parse_server_sdk_flutter: ^7.0.0
  provider: ^6.1.1
  shared_preferences: ^2.2.2
```

---

## 📦 Installation

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK (2.17 or higher)
- Android Studio / VS Code
- Git

### Setup Steps

1. **Clone the repository**
```bash
git clone https://github.com/CommitSage-web/TaskList.git
cd TaskList
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Configure Parse Server**

Create a `lib/config/parse_config.dart` file:
```dart
class ParseConfig {
  static const String appId = 'YOUR_APP_ID';
  static const String clientKey = 'YOUR_CLIENT_KEY';
  static const String serverUrl = 'https://parseapi.back4app.com';
}
```

Or update directly in `lib/services/parse_service.dart`:
```dart
static Future<void> initializeParse() async {
  const appId = 'YOUR_APP_ID';
  const clientKey = 'YOUR_CLIENT_KEY';
  const serverUrl = 'https://parseapi.back4app.com';
  // ...
}
```

4. **Run the app**
```bash
# For Android
flutter run

# For iOS
flutter run -d ios

# For specific device
flutter devices
flutter run -d <device_id>
```

### Getting Parse Server Credentials

1. Sign up at [Back4App](https://www.back4app.com/)
2. Create a new app
3. Go to **App Settings** → **Security & Keys**
4. Copy your **Application ID** and **Client Key**

---

## 📱 Usage

### User Registration & Login

1. **Register a new account**
   - Enter email and password
   - Password confirmation required
   - Minimum 6 characters

2. **Login to existing account**
   - Enter credentials
   - Auto-login on subsequent launches

### Managing Tasks

1. **Create a task**
   - Tap the **+ New Task** button
   - Enter title and description
   - Select priority level
   - Choose or create category
   - (Optional) Set due date
   - Tap **Create Task**

2. **Edit a task**
   - Tap on any task card
   - Update details
   - Tap **Update Task**

3. **Complete a task**
   - Tap the checkbox
   - Or swipe right

4. **Delete a task**
   - Tap delete icon
   - Or swipe left
   - Confirm deletion

### Using Filters

1. **Search tasks**
   - Tap search icon in AppBar
   - Type task name
   - Results update in real-time

2. **Apply filters**
   - Tap filter icon
   - Select priority filter
   - Select status filter
   - Tap **Clear All Filters** to reset

3. **View statistics**
   - Tap menu → **Statistics**
   - View completion rates
   - Check task breakdowns

### Customization

1. **Enable Dark Mode**
   - Tap menu → **Settings**
   - Toggle **Dark Mode**
   - Theme persists across sessions

2. **Set Defaults**
   - Go to **Settings**
   - Select default priority
   - Select default category

---

## 📂 Project Structure

```
lib/
├── main.dart                      # App entry point
├── providers/
│   └── theme_provider.dart        # Theme state management
├── services/
│   └── parse_service.dart         # Backend API service
└── screens/
    ├── login_screen.dart          # User login
    ├── register_screen.dart       # User registration
    ├── home_screen.dart           # Main task list
    ├── task_form_screen.dart      # Create/Edit tasks
    ├── profile_screen.dart        # User profile
    ├── stats_screen.dart          # Analytics dashboard
    └── settings_screen.dart       # App settings
```

### Architecture

- **MVVM Pattern** - Model-View-ViewModel separation
- **Provider** - For state management
- **Service Layer** - Centralized API calls
- **Reusable Widgets** - Component-based UI

---

## 🔧 Configuration

### Parse Server Setup

The app uses Parse Server for backend services. Configure in `parse_service.dart`:

```dart
static Future<void> initializeParse() async {
  const appId = 'YOUR_APP_ID';
  const clientKey = 'YOUR_CLIENT_KEY';
  const serverUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(
    appId,
    serverUrl,
    clientKey: clientKey,
    autoSendSessionId: true,
    debug: false, // Set to true for development
  );
}
```

### Database Schema

**Task Class:**
- `title` (String) - Task title
- `description` (String) - Task description
- `priority` (String) - "high", "medium", or "low"
- `category` (String) - Task category
- `isCompleted` (Boolean) - Completion status
- `dueDate` (Date) - Optional deadline
- `user` (Pointer to User) - Task owner

**User Class:**
- `username` (String) - User email
- `email` (String) - User email
- `displayName` (String) - Optional display name

---

## 🎨 Customization

### Changing Theme Colors

Update `theme_provider.dart`:

```dart
static ThemeData get lightTheme {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple, // Change this color
      brightness: Brightness.light,
    ),
    // ...
  );
}
```

### Adding New Categories

Update the default categories in `task_form_screen.dart`:

```dart
final List<String> _defaultCategories = [
  'General',
  'Work',
  'Personal',
  'Shopping',
  'Health',
  'Finance',
  'Education',
  'Home',
  'Your New Category', // Add here
];
```

---

## 🚀 Building for Production

### Android

1. **Create keystore**
```bash
keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
```

2. **Configure signing**
Create `android/key.properties`:
```
storePassword=<password>
keyPassword=<password>
keyAlias=key
storeFile=<path-to-key.jks>
```

3. **Build APK/Bundle**
```bash
# APK
flutter build apk --release

# App Bundle
flutter build appbundle --release
```

### iOS

1. **Configure signing in Xcode**
2. **Build**
```bash
flutter build ios --release
```

---

## 🧪 Testing

### Run tests
```bash
# All tests
flutter test

# With coverage
flutter test --coverage
```

### Test Structure
```
test/
├── unit/
│   ├── services/
│   └── providers/
├── widget/
│   └── screens/
└── integration/
```

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Commit your changes**
   ```bash
   git commit -m 'Add some amazing feature'
   ```
4. **Push to the branch**
   ```bash
   git push origin feature/amazing-feature
   ```
5. **Open a Pull Request**

### Coding Guidelines

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) style guide
- Write meaningful commit messages
- Add comments for complex logic
- Update documentation for new features
- Write tests for new functionality

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2024 Task Manager Pro

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev/) - UI framework
- [Back4App](https://www.back4app.com/) - Backend hosting
- [Material Design](https://m3.material.io/) - Design system
- [Parse Platform](https://parseplatform.org/) - Backend framework
- Icons by [Material Icons](https://fonts.google.com/icons)

---

## 🗺️ Roadmap

- [ ] Push notifications for due tasks
- [ ] Task collaboration and sharing
- [ ] File attachments
- [ ] Recurring tasks
- [ ] Home screen widget
- [ ] Offline mode with sync
- [ ] Voice input
- [ ] Task templates
- [ ] Export to PDF/CSV
- [ ] Multi-language support

---

## 💡 FAQ

**Q: Can I use this app without internet?**  
A: Currently, the app requires internet for authentication and sync. Offline mode is planned for future releases.

**Q: Is my data secure?**  
A: Yes, all data is stored securely on Parse Server with user-specific ACLs. Only you can access your tasks.

**Q: Can I export my tasks?**  
A: Export functionality is planned for the next release.

**Q: Does it support multiple languages?**  
A: Currently, only English is supported. Multi-language support is on the roadmap.

**Q: Can I collaborate with others?**  
A: Task sharing and collaboration features are planned for future versions.

---

<div align="center">

⭐ Star this repo if you find it helpful!

</div>
