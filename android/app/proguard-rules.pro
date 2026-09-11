# Keep Firebase classes
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Keep Flutter engine
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }

# Keep Google Sign-In
-keep class com.google.android.gms.auth.** { *; }

# Don't warn about missing classes from optional dependencies
-dontwarn com.google.android.play.core.**
-dontwarn com.google.firebase.**
