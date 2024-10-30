{
  description = "CheatShield Mobile";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.android_sdk.accept_license = true;
          config.allowUnfree = true;
        };
        buildToolsVersion = "34.0.0";
        androidComposition = pkgs.androidenv.composeAndroidPackages {
          cmdLineToolsVersion = "8.0"; # emulator related: newer versions are not only compatible with avdmanager
          platformToolsVersion = "34.0.4";
          buildToolsVersions = [ "30.0.3" "33.0.2" "34.0.0" ];
          platformVersions = [ "28" "31" "32" "33" "34" ];
          abiVersions = [ "armeabi-v7a" "arm64-v8a" ]; # emulator related: on an ARM machine, replace "x86_64" with
          includeNDK = false;
          includeSystemImages = false;
          systemImageTypes = [ "google_apis" "google_apis_playstore" ];
          includeEmulator = false;
          useGoogleAPIs = true;
          extraLicenses = [
            "android-googletv-license"
            "android-sdk-arm-dbt-license"
            "android-sdk-license"
            "android-sdk-preview-license"
            "google-gdk-license"
            "intel-android-extra-license"
            "intel-android-sysimage-license"
            "mips-android-sysimage-license"
          ];
        };
        androidEnv = pkgs.androidenv.override { licenseAccepted = true; };
        androidSdk = androidComposition.androidsdk;
      in
      {
        devShell =
          with pkgs; mkShell rec {
            ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
            ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
            JAVA_HOME = jdk17.home;
            FLUTTER_ROOT = flutter319;
            DART_ROOT = "${flutter319}/bin/cache/dart-sdk";
            GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${androidSdk}/libexec/android-sdk/build-tools/33.0.2/aapt2";
            CHROME_EXECUTABLE = "${chromium}/bin/chromium";
            buildInputs = [
              flutter319
              androidSdk # The customized SDK that we've made above
              jdk17
            ];
            shellHook = ''
              if [ -z "$PUB_CACHE" ]; then
                export PATH="$PATH:$HOME/.pub-cache/bin"
              else
                export PATH="$PATH:$PUB_CACHE/bin"
              fi
            '';
          };
      });
}
