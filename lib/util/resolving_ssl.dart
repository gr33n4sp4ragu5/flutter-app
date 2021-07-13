import 'dart:io';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        final isValidHost = host == "ci.syst.etsisi.upm.es";
        return isValidHost;
      };
  }
}
