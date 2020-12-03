import 'package:flutter/material.dart';
import 'package:parkspace/services/user_service.dart';
import 'package:provider/provider.dart';
import '../../theme/style.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var user;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserService>(context).user;

    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: appTheme?.backgroundColor,
          // actions: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.mode_edit),
          //   onPressed: () {
          //     Navigator.of(context).push(MaterialPageRoute<Null>(
          //       builder: (BuildContext context) {
          //         return EditProfile();
          //       },
          //     ));
          //   },
          // )
          // ],
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overScroll) {
            overScroll.disallowGlow();
            return false;
          },
          child: SingleChildScrollView(
            child: Container(
              color: appTheme?.backgroundColor,
              child: Column(
                children: <Widget>[
                  Center(
                    child: Stack(
                      children: <Widget>[
                        Material(
                          elevation: 10.0,
                          color: Colors.white,
                          shape: CircleBorder(),
                          child: Padding(
                            padding: EdgeInsets.all(2.0),
                            child: SizedBox(
                              height: 150,
                              width: 150,
                              child: Hero(
                                tag: "avatar_profile",
                                child: Image.asset('assets/image/avatar.png'),
                                // CircleAvatar(
                                //     radius: 30,
                                //     backgroundColor: Colors.transparent,
                                //     backgroundImage:
                                //     CachedNetworkImageProvider(
                                //       "https://source.unsplash.com/300x300/?portrait",
                                //     )),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10.0,
                          left: 25.0,
                          height: 15.0,
                          width: 15.0,
                          child: Container(
                            width: 15.0,
                            height: 15.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: greenColor,
                                border: Border.all(
                                    color: Colors.white, width: 2.0)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          user.email,
                          style: TextStyle(color: blackColor, fontSize: 35.0),
                        ),
                        // Text(
                        //   "Client since 2016",
                        //   style: TextStyle(color: blackColor, fontSize: 13.0),
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 50,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: whiteColor,
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1.0,
                                      color: appTheme?.backgroundColor))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Balance',
                                style: textStyle,
                              ),
                              Text(
                                '€${user.balance.toStringAsFixed(2)}',
                                style: textGrey,
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 50,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: whiteColor,
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1.0,
                                      color: appTheme?.backgroundColor))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Phone Number',
                                style: textStyle,
                              ),
                              Text(
                                '435-245-631',
                                style: textGrey,
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 50,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: whiteColor,
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1.0,
                                      color: appTheme?.backgroundColor))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Email',
                                style: textStyle,
                              ),
                              Text(
                                user.email,
                                style: textGrey,
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 50,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: whiteColor,
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1.0,
                                      color: appTheme?.backgroundColor))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Birthday',
                                style: textStyle,
                              ),
                              Text(
                                "Apirl 27, 1996",
                                style: textGrey,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
