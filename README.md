# Earth Rhythm - Premium Clean Skincare App
A modern, high-fidelity Flutter e-commerce mobile application featuring organic skincare products, smooth animations, interactive cart checkouts, and a live order tracking system.
## 🎥 Video Demonstration
🎥 **https://youtu.be/Lff2Ya_ZOJs?si=_eA8diU6b-mXzVTk**  

---
## 🌟 Key Features
*   **Interactive Checkout Journey**: Experience a complete checkout flow using Cash on Delivery (COD) that transitions into a dynamic confirmation screen thanking the customer with detailed transaction receipts.
*   **Theme Management**: `ThemeProvider` supporting custom forest-green visual palettes
*   **Data Models**: Clean representation of `Product`, `CartItem`, and `MockOrder`
## 📁 Directory Structure
---
```text
lib/
├── data/
│   └── mock_data.dart         # Mock product inventory & category structures
├── models/
│   ├── cart_item_model.dart   # Cart item structure
│   ├── order_model.dart       # Order receipt & tracking step model
│   └── product_model.dart     # Product database schema
├── providers/
│   ├── cart_provider.dart     # Handles cart items, coupons, & order histories
│   ├── theme_provider.dart    # Manages light & dark mode theme values
│   └── wishlist_provider.dart # Manages favorited items state
├── screens/
│   ├── all_products_screen.dart # Catalog sorting, grid representation
│   ├── cart_screen.dart       # Interactive bag checkout & success receipts
│   ├── home_screen.dart       # Homepage shell, promotions, & categories
│   ├── login_screen.dart      # Welcome onboarding screen
│   ├── product_details_screen.dart # Active tabs, highlights, & ingredients
│   └── profile_screen.dart    # User profile, wishlist cards, & order tracker
└── widgets/
    └── add_to_cart_animation.dart # Premium auto-dismissing checkmark dialog
## 🔗 Connecting Your Repository (Git Setup)
Run the following commands in your terminal to initialize and connect this project to your remote Git repository (GitHub / GitLab / Bitbucket):
```bash
# 1. Initialize git in the project root
git init
# 2. Add your remote repository origin
# (Replace the URL below with your actual repository URL)
git remote add origin https://github.com/your-username/your-repo-name.git
# 3. Add and commit all changed files
git add .
git commit -m "feat: complete interactive checkout, order tracking, and cart animations"
# 4. Rename default branch to main and push
git branch -M main
git push -u origin main
```

## 🚀 Getting Started
---
## 🚀 Running the Project
### Prerequisites
*   Flutter SDK installed (v3.0.0 or higher recommended)
*   Android Studio / Xcode or VS Code with Flutter extensions
*   An active Emulator, Simulator, or Physical device connected
### Installation
### How to Run
1. Clone the repository and navigate to the project directory:
1. Open your terminal and navigate to the project directory:
   ```bash
   cd flutter_application_1
   ```
2. Fetch all dependencies:
2. Verify that your Flutter environment is correctly configured:
   ```bash
   flutter doctor
   ```
3. View available target devices:
   ```bash
   flutter devices
   ```
4. Fetch all project package dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application on your connected emulator or device:
5. Launch the application:
   ```bash
   # Run on default connected device
   flutter run
   # Or run specifically on a target device (e.g., chrome, android, ios)
   flutter run -d <DEVICE_ID>
   ```
