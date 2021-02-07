import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:notes_demo/model/user_repository.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool signUpActive = false;

  @override
  Widget build(BuildContext context) {
    UserRepository user = Provider.of<UserRepository>(context);
    return WillPopScope(
      onWillPop: () async {
        if (signUpActive) {
          setState(() {
            signUpActive = true;
          });
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        key: _key,
        backgroundColor: Colors.indigo,
        body: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  SizedBox(height: kToolbarHeight),
                  Container(
                    margin: EdgeInsets.all(16.0),
                    width: 80,
                    height: 80,
                    child: Icon(
                      Icons.note_add_outlined,
                      size: 110,
                      color: Colors.yellow.shade600,
                    ),
                  ),
                  SizedBox(height: 30),
                  AnimatedSwitcher(
                    child: signUpActive ? SignUpForm() : LoginForm(),
                    duration: Duration(milliseconds: 500),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  OutlineButton(
                    onPressed: () {
                      setState(() {
                        signUpActive = !signUpActive;
                      });
                    },
                    child: Text(
                      signUpActive ? "Giriş" : "Kayıt Ol",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                          color: Colors.white),
                    ),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  SizedBox(height: 30),
                  user.status == Status.Authenticating
                      ? CircularProgressIndicator()
                      : RaisedButton(
                          onPressed: () async {
                            if (!await user.signInWithGoogle())
                              _key.currentState.showSnackBar(SnackBar(
                                content: Text("Something is wrong"),
                              ));
                          },
                          child: Text("Google ile Giriş Yap"),
                          color: Colors.red,
                          shape: StadiumBorder(),
                        ),
                ],
              ),
            )),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final FocusNode passwordFeield = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserRepository user = Provider.of<UserRepository>(context);
    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.all(15),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: 30),
            TextFormField(
              controller: _email,
              validator: (val) {
                if (val.isEmpty) {
                  return "Email Girilmeli";
                }
                return null;
              },
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: "Email"),
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(passwordFeield);
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _password,
              focusNode: passwordFeield,
              obscureText: true,
              validator: (val) {
                if (val.isEmpty) {
                  return "Şifre Girilmeli";
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: "Şifre",
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 55.0),
              child: user.status == Status.Authenticating
                  ? CircularProgressIndicator()
                  : RaisedButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          if (!await user.signIn(_email.text, _password.text))
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(user.error),
                            ));
                        }
                      },
                      child: Text("Giriş Yap"),
                    ),
            )
          ],
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();

  final FocusNode passwordField = FocusNode();

  final FocusNode confimPasswordField = FocusNode();

  @override
  Widget build(BuildContext context) {
    UserRepository user = Provider.of<UserRepository>(context);
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: Colors.white,
        ),
        child: Column(
          children: <Widget>[
            Text(
              "Sign Up",
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: 30),
            TextFormField(
              controller: _email,
              validator: (val) {
                if (val.isEmpty) {
                  return "Email girilmeli";
                }
                return null;
              },
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: "Email"),
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(passwordField);
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _password,
              focusNode: passwordField,
              obscureText: true,
              validator: (val) {
                if (val.isEmpty) {
                  return "Şifre girilmeli";
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: "Şifre",
              ),
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(confimPasswordField);
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _confirmPassword,
              focusNode: confimPasswordField,
              obscureText: true,
              validator: (val) {
                if (val.isEmpty || val != _password.text) {
                  return "Parolayla Eşleşmeli!";
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: "Şifreyi Onayla",
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: user.status == Status.Authenticating
                  ? CircularProgressIndicator()
                  : RaisedButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          if (!await user.signUp(_email.text, _password.text))
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(user.error),
                            ));
                        }
                      },
                      child: Text("Hesap Oluştur"),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
