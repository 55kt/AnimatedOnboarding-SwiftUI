# ✨ Elegant Onboarding Flow (SwiftUI + Animations)

## ✨ Features
- 🌀 **Animated Onboarding Slides** – Smooth appearance of icons, titles, and cards  
- 📋 **Informative Cards** – Structured highlights for each feature of your app  
- 🔒 **User Agreement Sheet** – Accept Terms & Privacy Policy before entering the app  
- 🎨 **Customizable Tint** – Change the accent color in one place  
- 🚀 **Reusable Architecture** – Easy to extend with new slides or cards  

---

## 📸 Screenshots
<img width="200" alt="Image" src="https://github.com/user-attachments/assets/7dddec6b-f37a-43a6-875b-f78330fe055b" />
<img width="200" alt="Image" src="https://github.com/user-attachments/assets/22e8fa06-56e3-4f34-9f90-a25791563783" />
<img width="200" alt="Image" src="https://github.com/user-attachments/assets/259279fa-7daf-4f08-8035-b139b0eabcf9" />
<img width="200" alt="Image" src="https://github.com/user-attachments/assets/e3851538-2b94-434e-88a4-ce8ee59ce1c5" />
<img width="200" alt="Image" src="https://github.com/user-attachments/assets/4ddaeaf2-6633-4450-aa66-597bd9a0464b" />
<img width="200" alt="Image" src="https://github.com/user-attachments/assets/9c651e06-7942-47db-8471-bbda7814cb47" />

---

## 📽️ Video
https://github.com/user-attachments/assets/9b8a2219-20d9-4c57-95c3-27a41eb608af

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
