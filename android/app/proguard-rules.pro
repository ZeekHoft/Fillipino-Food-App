# Keep TensorFlow Lite classes
-keep class org.tensorflow.lite.** { *; }
-keep class org.tensorflow.lite.gpu.** { *; }

# Specifically keep the class mentioned in your error
-keep class org.tensorflow.lite.gpu.GpuDelegateFactory$Options { *; }

# Also helpful for TFLite builds
-dontwarn org.tensorflow.lite.**