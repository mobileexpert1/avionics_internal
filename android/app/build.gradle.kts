plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
}

android {
    namespace = "com.avioflai.aviation"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    defaultConfig {
        applicationId = "com.avioflai.aviation"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        vectorDrawables.useSupportLibrary = true
        manifestPlaceholders += mapOf(
            "fbLoginProtocolScheme" to "fb1430451834195464"
        )
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "11"
    }
}

flutter {
    source = "../.."
}


dependencies {
    implementation("com.google.firebase:firebase-crashlytics:18.6.2")
    implementation("com.google.firebase:firebase-analytics:21.6.2")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}


// ✅ Add this at the very bottom:
//apply(plugin = "com.google.gms.google-services")
