# 누락된 Google Tink 관련 클래스 유지
-keep class com.google.errorprone.annotations.** { *; }
-keep class javax.annotation.** { *; }
-keep class javax.annotation.concurrent.** { *; }

# 누락된 경고 무시
-dontwarn com.google.errorprone.annotations.**
-dontwarn javax.annotation.**
-dontwarn javax.annotation.concurrent.**

# ProGuard 최적화 비활성화 (필요 시)
-dontoptimize
