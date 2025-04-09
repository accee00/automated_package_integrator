import 'dart:io';

class ApiKeyInjector {
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
