import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import './blocs/userBloc.dart';
import './resources/utility.dart';
import './screens/welcome.dart';
import './screens/login.dart';
import './screens/register.dart';
import './screens/home.dart';
import './screens/splash.dart';
import './screens/editHangout.dart';

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);

    return ChangeNotifierProvider<UserBloc>.value(
      value: UserBloc(),
      child: MaterialApp(
        title: "Let's Hang!",
        onGenerateRoute: _routes,
        // theme: _theme(),
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
      ),
    );
  }


  ThemeData _theme() {
    return ThemeData(
      primaryColor: Colors.teal[400],
      primaryColorLight: Colors.teal[200],
      primaryColorDark: Colors.teal[700],
      accentColor: Colors.orange[300],
      focusColor: Colors.teal[700],
      errorColor: Colors.red[700],
      brightness: Brightness.dark,
      splashColor: Colors.teal[400],
      canvasColor: Colors.teal[400],
      backgroundColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      bottomAppBarColor: Colors.teal[200],
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.teal[200],
        textTheme: ButtonTextTheme.normal,
      ),
      appBarTheme: AppBarTheme(
        color: Colors.teal[200],
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      textTheme: TextTheme(
        bodyText2: TextStyle(
          color: Colors.grey[700],
        ),
      ),
    );
  }


  Route _routes(RouteSettings settings) {

    switch (settings.name) {

      case '/':
        return MaterialPageRoute(
          builder: (BuildContext context) {

            UserBloc userBloc = Provider.of(context);
            if (userBloc.currentUser == null) {
              userBloc.fetchCurrentUser();
            }

            if (userBloc.currentUser == null) {
              return Splash();
            } else if (userBloc.currentUser.id == null) {
              return Welcome();
            } else {
              return Home();
            }
          },
        );

      case '/login':
        return MaterialPageRoute(
          builder: (BuildContext context) {
            return Login();
          },
        );

      case '/register':
        return MaterialPageRoute(
          builder: (BuildContext context) {
            return Register();
          },
        );

      case '/home':
        return MaterialPageRoute(
          builder: (BuildContext context) {
            UserBloc userBloc = Provider.of(context);
            if (userBloc.currentUser == null) {
              userBloc.fetchCurrentUser();
            }

            if (userBloc.currentUser == null) {
              return Welcome();
            } else {
              return Home();
            }
          },
        );

        default:
          if (settings.name.contains('/hangout/')) {
            return MaterialPageRoute(
              builder: (BuildContext context) {
                UserBloc userBloc = Provider.of(context);
                final hangouts = userBloc.currentUser.hangouts;
                final id = settings.name.split('/')[2];
                return EditHangout(Utility.findById(hangouts, id));
              },
            );
          } else if (settings.name.contains('/group/')) {
            return null;
          }

    }

    return null;
  }
}
