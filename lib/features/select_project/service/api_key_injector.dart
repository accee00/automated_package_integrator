import 'dart:io';

class ApiKeyInjector {
  /// Injects the Android API key into the AndroidManifest.xml file.
  ///
  /// This function checks if the specified AndroidManifest.xml file exists at the given
  /// project path. If the file exists and does not already contain the API key metadata,
  /// it adds the API key to the file before the closing </application> tag.
  ///
  /// Parameters:
  /// - [projectPath]: The path to the Android project where the AndroidManifest.xml file is located.
  /// - [apiKey]: The API key to be injected into the AndroidManifest.xml file.
  ///
  /// Returns:
  /// A [Future] that completes when the operation is finished. If the file does not exist,
  /// the function returns immediately without making any changes.
  static Future<void> injectAndroidKey(
      String projectPath, String apiKey) async {
    final file = File('$projectPath/android/app/src/main/AndroidManifest.xml');
    if (!file.existsSync()) return;

    var content = await file.readAsString();

    final alreadyHasKey = content.contains('com.google.android.geo.API_KEY');

    if (!alreadyHasKey) {
      content = content.replaceFirst(
        '</application>',
        '''
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="$apiKey" />
</application>''',
      );
      await file.writeAsString(content);
    }
  }

  /// Injects the iOS API key into the Info.plist file.
  ///
  /// This function checks if the specified Info.plist file exists at the given
  /// project path. If the file exists and does not already contain the GMSApiKey,
  /// it adds the API key to the file before the closing </dict> tag.
  ///
  /// Parameters:
  /// - [projectPath]: The path to the iOS project where the Info.plist file is located.
  /// - [apiKey]: The API key to be injected into the Info.plist file.
  ///
  /// Returns:
  /// A [Future] that completes when the operation is finished. If the file does not exist,
  /// the function returns immediately without making any changes.
  static Future<void> injectIosKey(String projectPath, String apiKey) async {
    final file = File('$projectPath/ios/Runner/Info.plist');
    if (!file.existsSync()) return;

    var content = await file.readAsString();

    final alreadyHasKey = content.contains('GMSApiKey');

    if (!alreadyHasKey) {
      content = content.replaceFirst(
        '</dict>',
        '''
<key>GMSApiKey</key>
<string>$apiKey</string>
</dict>''',
      );
      await file.writeAsString(content);
    }
  }
}
