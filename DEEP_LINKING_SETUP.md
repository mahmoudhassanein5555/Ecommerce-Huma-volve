# Deep Linking Setup for Huma Volve E-Commerce App

## Overview
This document explains how deep linking has been configured to allow users to open the app directly from web links like `https://hume-volve-ecommerce.web.app/products/1`.

## What Was Implemented

### 1. Go Router Configuration (app_routing.dart)
- Updated the product details route to accept an ID parameter: `/productDetails/:id`
- The route now handles both:
  - Internal navigation (with product object via `state.extra`)
  - Deep linking (with product ID from URL parameter)

### 2. Android Configuration (AndroidManifest.xml)
Added an intent filter to handle deep links from `hume-volve-ecommerce.web.app`:
```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="https" />
    <data android:host="hume-volve-ecommerce.web.app" />
    <data android:pathPrefix="/products" />
</intent-filter>
```

### 3. Share Product Button Updated
The share button now generates links with the product ID:
```
https://hume-volve-ecommerce.web.app/products/{productId}
```

## How It Works

1. **When a user clicks a shared link** (e.g., `https://hume-volve-ecommerce.web.app/products/123`):
   - Android will check if the app is installed
   - If installed, it opens the app and navigates to the product details
   - If not installed, it opens the web page

2. **In the app**:
   - Go Router receives the deep link URL
   - Extracts the product ID from the path
   - Navigates to the product details screen

## Testing Deep Linking

### Method 1: Using ADB Command (Android)
```bash
adb shell am start -a android.intent.action.VIEW -d "https://hume-volve-ecommerce.web.app/products/1" com.example.ecommerce_app_huma_volve
```

### Method 2: Using Chrome on Android
1. Open Chrome browser on your Android device/emulator
2. Navigate to: `https://hume-volve-ecommerce.web.app/products/1`
3. The app should open automatically

### Method 3: Testing from Web Page
1. Use the share button in the app to share a product
2. Click the shared link from another app (Gmail, WhatsApp, etc.)
3. The app should open with the product details

## Important Notes

### Android App Links Verification
For production, you need to verify your domain ownership with Google:
1. Upload the `assetlinks.json` file to your web server at:
   `https://hume-volve-ecommerce.web.app/.well-known/assetlinks.json`

2. The file should contain your app's package name and SHA-256 fingerprint:
```json
[
  {
    "relation": ["delegate_permission/common.handle_all_urls"],
    "target": {
      "namespace": "android_app",
      "package_name": "com.example.ecommerce_app_huma_volve",
      "sha256_cert_fingerprints": ["YOUR_SHA256_FINGERPRINT"]
    }
  }
]
```

3. Get your SHA-256 fingerprint:
```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

### Current Limitation
The current implementation shows a placeholder product when opened via deep link. To fully implement deep linking, you need to:

1. **Add a use case to fetch product by ID**:
   - Create `GetProductById` use case
   - Add API endpoint to fetch single product by ID
   - Update the route builder to fetch the product

2. **Update the route builder** to fetch product data:
```dart
builder: (context, state) async {
  final productId = int.parse(state.pathParameters['id']!);
  final product = state.extra as Product?;
  
  if (product != null) {
    return ProductDetailsScreen(product: product);
  }
  
  // Fetch product by ID for deep linking
  final cubit = context.read<AllProductsCubit>();
  await cubit.getProductById(productId);
  
  // Show loading state while fetching
  return const ProductDetailsLoadingScreen();
}
```

## iOS Configuration (if needed)
If you add iOS support later, you'll need to:

1. Enable Associated Domains in Xcode
2. Add your domain to the Associated Domains capability:
   `applinks:hume-volve-ecommerce.web.app`

3. Upload the `apple-app-site-association` file to your server at:
   `https://hume-volve-ecommerce.web.app/.well-known/apple-app-site-association`

## Web Page Redirect
Your web page at `https://hume-volve-ecommerce.web.app/products/{id}` should:

1. Check if the app is installed
2. If installed, redirect to the app using the deep link
3. If not installed, show a fallback web page or redirect to app store

Example web page JavaScript:
```javascript
function openAppOrWeb() {
  const productId = getProductIdFromUrl();
  const appLink = `humavolve://products/${productId}`;
  const webLink = `https://hume-volve-ecommerce.web.app/products/${productId}`;
  
  // Try to open app
  window.location.href = appLink;
  
  // Fallback to web after 2 seconds
  setTimeout(() => {
    window.location.href = webLink;
  }, 2000);
}
```

## Next Steps
1. Implement product fetching by ID for full deep link support
2. Test deep linking on a real Android device
3. Set up domain verification for production
4. Add iOS configuration if supporting iOS
