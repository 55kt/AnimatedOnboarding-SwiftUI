# ✨ Elegant Onboarding Flow (SwiftUI + Animations)

## ✨ Features
- 🌀 **Animated Onboarding Slides** – Smooth appearance of icons, titles, and cards  
- 📋 **Informative Cards** – Structured highlights for each feature of your app  
- 🔒 **User Agreement Sheet** – Accept Terms & Privacy Policy before entering the app  
- 🎨 **Customizable Tint** – Change the accent color in one place  
- 🚀 **Reusable Architecture** – Easy to extend with new slides or cards  

---

## 📸 Screenshots


---

## 🚀 How It Works
1. **First Launch**  
   - App shows onboarding slides with animated content.  
   - User reviews features through **cards** and **slides**.  

2. **Final Slide**  
   - A **Continue button** opens the **Agreement sheet**.  
   - User must toggle acceptance of Terms & Privacy Policy.  

3. **Agreement Accepted**  
   - `hasAgreed` is saved in memory (can be persisted with `@AppStorage`).  
   - Onboarding flow is skipped on next launch.  

---

## 🛠 Requirements
- iOS 18+  
- Xcode 16+  
- Swift 5.9+

---

## ⚡ Notes
- Animations are handled via **async/await** delays to create smooth entry effects.  
- Onboarding flow is **non-dismissible** until the final slide, ensuring Terms acceptance.  
- Icons are powered by **SF Symbols** — replace them easily for your own branding.  
- Rules text in the agreement is stored in `AgreementSheetView`.  

---

## 📜 License
MIT License. Free to use and adapt in your projects.
