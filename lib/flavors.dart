enum Flavor {
  SANDBOX,
  PRODUCTION,
}

class F {
  static Flavor appFlavor;

  static String get url {
    switch (appFlavor) {
      case Flavor.SANDBOX:
        return 'http://api.staging.example.com/api/v1';
      case Flavor.PRODUCTION:
        return 'https://api.xxxx.com' ;
      default:
        return '';
    }
  }

  static String get title {
    switch (appFlavor) {
      case Flavor.SANDBOX:
        return 'Sandbox App';
      case Flavor.PRODUCTION:
        return 'Production App';
      default:
        return 'title';
    }
  }

}
