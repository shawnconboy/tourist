# TouristApp – Charleston Travel Companion

**TouristApp** is a SwiftUI-based mobile application designed to serve as a modern travel guide for visitors in Charleston, SC. It combines local recommendations, event listings, referral mechanics for Uber drivers, and business partnerships to enhance user experience while offering monetization opportunities.

---

## 🌟 Core Features

- **Curated Home View** with top category shortcuts and featured places
- **Refined UI Theme** with consistent card design and styling across the app
- **Top Shortcut Categories**: Deals, Food & Drink, Beaches, Things To Do
- **Featured Places Section** pulled from JSON
- **Live Events Feed** displayed at the bottom of the home screen
- **Detailed Event Pages** with navigation, date, price, and location
- **QR Referral System** for Uber/Lyft drivers
- **Driver Dashboard** showing personal referral counts
- **Admin Panel** with authentication and full driver management
- **Firebase Integration** for Firestore and Auth

---

## 🧱 Project Structure Overview

- `HomeView.swift`: Main screen with top shortcuts, featured places, and live events
- `PlaceDetailView.swift`: Details for locations like restaurants or parks
- `Event.swift`: Codable model for events
- `EventDetailView.swift`: Detail UI for selected event
- `events.json`: List of upcoming local events
- `allPlaces.json`: List of recommended places (with category info)
- `SettingsView.swift`: Admin access + app version info
- `LoginSheetView.swift`: Authentication entry for admin role
- `QRCodeView.swift`: QR generator view
- `ReferralManager.swift`: Captures referrals from scanned URLs
- `DriverDashboardView.swift`: In-app driver profile and QR

---

## 🔮 Future Plans

- Add in-app event RSVP or save-to-calendar integration
- Display map pins for all locations + events in real-time
- Create business dashboard for managing deals and insights
- Enable drivers to track bonuses, payout eligibility, and history
- Introduce personalized recommendations based on behavior
- Build multi-city support for future TouristApp expansions
- Local push notifications for nearby deals or upcoming events
- Add in-app purchases for premium exposure or featured placement
- Launch marketing portal for Uber/Lyft onboarding kits
- Integrate app analytics dashboard (e.g. daily active users, usage patterns)

---

## 🔒 Admin Mode

- Accessible from Settings tab
- Admin login triggers visibility of driver controls
- Admin features:
  - View current drivers
  - Add/edit/delete driver info
  - Generate QR code per driver
  - Sort by referrals or redemptions

---

## 🧾 Project Log (Reverse Chronological Order)

- ✅ **Added full-width event cards styled like Places section**
- ✅ **Created tappable EventDetailView for each event**
- ✅ **Replaced "Explore by Category" with new Live Events section**
- ✅ **Added events.json and Event.swift model**
- ✅ **Finalized QR code referral system for drivers**
- ✅ **Admin Settings now includes driver management panel**
- ✅ **Added driver ID auto-generation and toast confirmations**
- ✅ **Created custom Admin login sheet embedded in Settings tab**
- ✅ **DriverDashboardView shows referral counts and QR code**
- ✅ **Integrated Firebase Auth and Firestore**
- ✅ **ReferralManager saves scanned ref codes and logs installs**
- ✅ **Created scan-ready QR ornament mockups for Uber seatbacks**
- ✅ **App structured for public use first, but accepts QR activation**
- ✅ **Created custom HomeView layout with top shortcuts and card UI**
- ✅ **Refactored layout to match Husk-style detail pages with consistent padding**
- ✅ **Introduced consistent styling using Theme.swift + Layout.swift**
- ✅ **Switched tab order: Home, Deals, Food, Beaches, Things, Map, Settings**
- ✅ **Developed driver referral bonus system with tracking**
- ✅ **Established app icon and splash concept with rounded aesthetic**
- ✅ **Built foundational tabbed app with Beaches, Food, Map views**
- ✅ **Created Place model + loaded data from allPlaces.json**
- ✅ **Connected JSON parsing to dynamic place listings**
- ✅ **Launched MVP project in Xcode using SwiftUI + NavigationView**

---

> This file should serve as a live status reference for TouristApp's progress, major milestones, and implementation history.


