class AppText {
  static const String appbar = 'Select Flutter Project';
  static const String pickDirectory = 'Pick Flutter Project Directory';
  static const String hintText = 'Paste API key here';
  static const String skip = 'Skip';
  static const String submit = 'Submit';
  static const String enterKey = 'Enter Google Maps API Key';
  static const String googleMap = 'Google Map';
}

class SuccessText {
  static const String apiKeySetSuccess = 'API keys set successfully';
  static const String addPackagaeSuccess =
      'Package added and pub get succeeded.';
  static const String projectSelected = "Project Selected";
}

class ErrorText {
  static const String emptyApiKey = 'Enter API key.';
  static const String pathNotFound = 'Error in finding path';
  static const String notValid = 'This is not a valid Flutter project.';
  static const String pubGetFailed = 'flutter pub get failed.';
  static const apiKeyInjectionFailed = 'Failed to inject API key';
  static const androidInjectionFailed =
      'Failed to inject Android API key (check AndroidManifest.xml)';
  static const iosInjectionFailed =
      'Failed to inject iOS API key (check Info.plist)';
}
