# Earth Rhythm - Premium Mini E-commerce Mobile Application

A premium, interactive, and highly aesthetic Flutter mini e-commerce application built for the **CyphLab Flutter Developer Intern** practical task. This application is inspired by the organic skincare & cosmetics brand **Earth Rhythm** and implements advanced UI/UX layouts, state management, validations, and animations.

---

## 📱 Key Features & Screens

### 1. Onboarding & Authentication Simulation
- **Splash Screen**: Features smooth fade and translation entry animations displaying the brand identity.
- **Login Screen**: An elegant onboarding interface with form validation (email format checks and password length constraint) and password visibility toggling. Includes a **"Continue as Guest"** option for frictionless access.

### 2. Shop & Explore Hub
- **Product Home Screen**: 
  - **Dynamic Promo Carousel**: An auto-scrolling horizontal banner page-view with dot-slide indicators displaying custom offers.
  - **Real-Time Product Search**: Instantly filters products by name, category, or ingredients as the user types.
  - **Category Filter Chips**: Horizontal scrolling selector to filter by *Face*, *Serum*, *Sun*, *Hair*, *Make Up*, and *Body*.
  - **Dermal Trust Indicators**: Highlights brand promises (Cruelty-free, Vegan, Clinically Tested).
- **Product Cards**: Clean borders, floating product badges (e.g., "New Launch", "20% off"), ratings breakdown, and quick-add actions.

### 3. Skincare Details & Wishlist
- **Product Details Screen**:
  - Parallax scrolling background header.
  - **Interactive Detail Tabs**: Responsive tab layout switching between **Details**, **Ingredients**, and **The Promise** with fade animations.
  - **Pre-cart Quantity Selector**: Increment/decrement items before adding to the bag.
  - **Active Wishlist (Favorites)**: Add/remove items with a heart toggle which saves items globally.
  
### 4. Checkout & Cart Flow
- **Bag/Cart Screen**:
  - Quantity adjustments (+/-) and swipe-to-remove (Dismissible) cards.
  - **Interactive Coupon Field**: Apply coupon code `EARTH20` to instantly calculate and deduct a 20% discount on the grand total.
  - **Animated Order Confirmation**: Placing an order triggers a full-screen success checkmark animation, clearing the cart and resetting state.

### 5. Profile & Settings
- **Profile Screen**:
  - Displays user account data and mock shipping details.
  - **Live Favorites Shelf**: Displays wishlisted items horizontally with direct click-to-view navigation.
  - **Recent Orders Ledger**: Displays receipt list with transaction statuses (e.g., *Delivered*, *Processing*).
  - **Active Theme Toggle Switch**: Switches light and dark themes on the fly.
  - **Reset Onboarding**: Logging out resets the auth state and redirects back to the login screen.

---

## 🛠️ Technical Implementation

### Project Directory Structure
```text
lib/
  data/
    mock_data.dart            # Mock skincare dataset (Unsplash assets)
  models/
    cart_item_model.dart      # Holds cart product reference and quantity count
    product_model.dart        # Defines product properties (prices, rating, category, details)
  providers/
    cart_provider.dart        # Manages cart entries, discount math, and checkout
    theme_provider.dart       # Manages dark/light theme state
    wishlist_provider.dart    # Manages favorited items
  screens/
    cart_screen.dart          # My Bag details, coupons, and checkouts
    home_screen.dart          # Banner sliders, search bars, category list, grids
    login_screen.dart         # Email/password form validation and onboarding
    product_details_screen.dart # Parallax scroll, quantity toggle, tabbed benefits
    profile_screen.dart       # Theme switchers, wishlist collections, order statuses
    splash_screen.dart        # Entry animated screens
  widgets/
    product_card.dart         # Grid item card with wishlist actions
  main.dart                   # Application configurations and theme settings
```

### State Management & Design System
- **State management**: Powered by `Provider` (`ChangeNotifier`) for reactive and separated UI logic.
- **Themes**: Restructured light and dark themes around **Earth Rhythm's** signature green (`#174A33`) and coral (`#D67A60`) brand colors, utilizing clean border lines and high-contrast typography.
- **Lints**: Checked against `flutter_lints` rules, resolving all deprecated properties and syntax warnings (runs with **0 issues** under `flutter analyze`).

---

## 🚀 Run Instructions

### 1. Set Up Environment
Ensure you have the Flutter SDK installed.

### 2. Download Dependencies
```bash
flutter pub get
```

### 3. Execute Static Analysis
```bash
flutter analyze
```

### 4. Execute Unit Tests
```bash
flutter test
```

### 5. Run the Application
```bash
flutter run
```

---

## 🤖 AI Development Disclosure
This project was pair-programmed with the AI coding assistant **Antigravity by Google DeepMind**.
- **AI Assisted Tasks**: Refactoring layouts into light/dark themes, writing the sliding carousel banner animation logic, configuring the tab switcher on the detail page, implementing the coupon calculation provider, and cleaning up standard Flutter lints.
- **Developer Input**: Code layout architecture, product mock dataset integration, verification testing, and git repository configuration.
