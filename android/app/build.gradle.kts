plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id ("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.flilipino_food_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.flilipino_food_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
    signingConfigs {
            create("release") {
                // If you don't have a keystore yet, you can use the debug one 
                // temporarily just to get the app to build.
                val debugKey = signingConfigs.getByName("debug")
                storeFile = debugKey.storeFile
                storePassword = debugKey.storePassword
                keyAlias = debugKey.keyAlias
                keyPassword = debugKey.keyPassword
            }
        }
    buildTypes {
        release {
            // Use 'isMinifyEnabled' instead of 'minifyEnabled'
            // Use '=' for assignment in Kotlin
            isMinifyEnabled = true
            
            // Use parentheses for proguardFiles and double quotes for strings
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}
