import 'package:flutter/material.dart';
import 'package:parkspace/Components/ink_well_custom.dart';
import 'package:parkspace/Components/shared_widgets.dart';
import 'package:parkspace/Screen/base_widget.dart';
import 'package:parkspace/app_router.dart';
import 'package:parkspace/services/user_service.dart';
import 'package:parkspace/theme/style.dart';
import 'package:parkspace/Components/validations.dart';
import 'package:parkspace/viewmodels/authentication_models/authentication_model.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool autoValidate = false;
  Validations validations = new Validations();

  // TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  AuthModel _model;

  submit() async {
    final FormState form = formKey.currentState;
    if (!form.validate()) {
      autoValidate = true; // Start validating on every change.
    } else {
      form.save();
      var success = await _model.register(
          _emailController.text, _passwordController.text);
      if (success) {
        Navigator.of(context).pushReplacementNamed(AppRoute.mainScreen);
      } else {
        defaultDialog(dialog: _model.error, context: context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    UserService userService = Provider.of<UserService>(context);
    return BaseWidget<AuthModel>(
        model: AuthModel(userService: userService),
        onModelReady: (model) {
          _model = model;
        },
        builder: (context, model, child) {
          return Scaffold(
            body: SingleChildScrollView(
                child: InkWellCustom(
              onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Stack(children: <Widget>[
                      Container(
                        height: 250.0,
                        width: double.infinity,
                        color: Color(0xFFFDD148),
                      ),
                      Positioned(
                        bottom: 450.0,
                        right: 100.0,
                        child: Container(
                          height: 400.0,
                          width: 400.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(200.0),
                            color: Color(0xFFFEE16D),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 500.0,
                        left: 150.0,
                        child: Container(
                            height: 300.0,
                            width: 300.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(150.0),
                                color: Color(0xFFFEE16D).withOpacity(0.5))),
                      ),
                      new Padding(
                          padding: EdgeInsets.fromLTRB(32.0, 200.0, 32.0, 0.0),
                          child: Container(
                              height: MediaQuery.of(context).size.height,
                              width: double.infinity,
                              child: new Column(
                                children: <Widget>[
                                  new Container(
                                      //padding: EdgeInsets.only(top: 100.0),
                                      child: new Material(
                                    borderRadius: BorderRadius.circular(7.0),
                                    elevation: 5.0,
                                    child: new Container(
                                      width: MediaQuery.of(context).size.width -
                                          20.0,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.45,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                      child: new Form(
                                          key: formKey,
                                          child: new Container(
                                            padding: EdgeInsets.all(32.0),
                                            child: new Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Sign up',
                                                  style: heading35Black,
                                                ),
                                                new Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    // TextFormField(
                                                    //     controller:
                                                    //         _usernameController,
                                                    //     keyboardType:
                                                    //         TextInputType.text,
                                                    //     validator: validations
                                                    //         .validateName,
                                                    //     decoration:
                                                    //         InputDecoration(
                                                    //       border:
                                                    //           OutlineInputBorder(
                                                    //         borderRadius:
                                                    //             BorderRadius
                                                    //                 .circular(
                                                    //                     10.0),
                                                    //       ),
                                                    //       prefixIcon: Icon(
                                                    //           Icons.person,
                                                    //           color: Color(
                                                    //               getColorHexFromStr(
                                                    //                   '#FEDF62')),
                                                    //           size: 20.0),
                                                    //       contentPadding:
                                                    //           EdgeInsets.only(
                                                    //               left: 15.0,
                                                    //               top: 15.0),
                                                    //       hintText: 'Username',
                                                    //       hintStyle: TextStyle(
                                                    //           color:
                                                    //               Colors.grey,
                                                    //           fontFamily:
                                                    //               'Quicksand'),
                                                    //     )),
                                                    // Padding(
                                                    //   padding: EdgeInsets.only(
                                                    //       top: 20.0),
                                                    // ),
                                                    TextFormField(
                                                        controller:
                                                            _emailController,
                                                        keyboardType:
                                                            TextInputType
                                                                .emailAddress,
                                                        validator: validations
                                                            .validateEmail,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ),
                                                          prefixIcon: Icon(
                                                              Icons.email,
                                                              color: Color(
                                                                  getColorHexFromStr(
                                                                      '#FEDF62')),
                                                              size: 20.0),
                                                          contentPadding:
                                                              EdgeInsets.only(
                                                                  left: 15.0,
                                                                  top: 15.0),
                                                          hintText: 'Email',
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontFamily:
                                                                  'Quicksand'),
                                                        )),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 20.0),
                                                    ),
                                                    TextFormField(
                                                        controller:
                                                            _passwordController,
                                                        obscureText: true,
                                                        keyboardType:
                                                            TextInputType
                                                                .visiblePassword,
                                                        validator: validations
                                                            .validatePassword,
                                                        decoration:
                                                            InputDecoration(
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10.0),
                                                                ),
                                                                prefixIcon: Icon(
                                                                    Icons.phone,
                                                                    color: Color(
                                                                        getColorHexFromStr(
                                                                            '#FEDF62')),
                                                                    size: 20.0),
                                                                contentPadding:
                                                                    EdgeInsets.only(
                                                                        left:
                                                                            15.0,
                                                                        top:
                                                                            15.0),
                                                                hintText:
                                                                    'Password',
                                                                hintStyle: TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontFamily:
                                                                        'Quicksand'))),
                                                  ],
                                                ),
                                                new Container(
                                                    child: new Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    InkWell(
                                                      child: new Text(
                                                        "Forgot Password ?",
                                                        style: textStyleActive,
                                                      ),
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pushReplacementNamed(
                                                                AppRoute
                                                                    .forgotPasswordScreen);
                                                      },
                                                    ),
                                                  ],
                                                )),
                                                model.isProcessing
                                                    ? Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          backgroundColor:
                                                              primaryColor,
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                      Color>(
                                                                  Colors.white),
                                                        ),
                                                      )
                                                    : ButtonTheme(
                                                        height: 50.0,
                                                        minWidth: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child:
                                                            RaisedButton.icon(
                                                          shape: new RoundedRectangleBorder(
                                                              borderRadius:
                                                                  new BorderRadius
                                                                          .circular(
                                                                      15.0)),
                                                          elevation: 0.0,
                                                          color: primaryColor,
                                                          icon: new Text(''),
                                                          label: new Text(
                                                            'SIGN UP',
                                                            style: headingWhite,
                                                          ),
                                                          onPressed: () {
                                                            // Navigator.of(context)
                                                            //     .pushReplacementNamed(
                                                            //         AppRoute.introScreen);
                                                            submit();
                                                          },
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          )),
                                    ),
                                  )),
                                  new Container(
                                      padding: EdgeInsets.fromLTRB(
                                          0.0, 20.0, 0.0, 20.0),
                                      child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          new Text(
                                            "Already have an account? ",
                                            style: textGrey,
                                          ),
                                          new InkWell(
                                            onTap: () => Navigator.of(context)
                                                .pushNamed(
                                                    AppRoute.loginScreen),
                                            child: new Text(
                                              "Sign In",
                                              style: textStyleActive,
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ))),
                    ])
                  ]),
            )),
          );
        });
  }
}
