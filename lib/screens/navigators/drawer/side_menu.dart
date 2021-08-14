import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spa_admin_panel/screens/navigators/about_screen.dart';
import 'package:spa_admin_panel/screens/navigators/booking_screen.dart';
import 'package:spa_admin_panel/screens/navigators/coupon_screen.dart';
import 'package:spa_admin_panel/screens/navigators/home_screen.dart';
import 'package:spa_admin_panel/screens/navigators/notification_screen.dart';
import 'package:spa_admin_panel/screens/navigators/offer_screen.dart';
import 'package:spa_admin_panel/screens/navigators/portrait_screen.dart';
import 'package:spa_admin_panel/screens/navigators/review_screen.dart';
import 'package:spa_admin_panel/screens/navigators/role_screen.dart';
import 'package:spa_admin_panel/screens/navigators/service_screen.dart';
import 'package:spa_admin_panel/screens/navigators/settings_screen.dart';
import 'package:spa_admin_panel/screens/navigators/specialist_screen.dart';
import 'package:spa_admin_panel/screens/navigators/timeslot_screen.dart';

import '../../../constants.dart';
import '../main_screen.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(

      child: Container(
        color: bgColor,
        child:ListView(
          children: [
            DrawerHeader(
              child: Image.asset("assets/images/logo.png"),
            ),
            DrawerListTile(
              title: "Home",
              svgSrc: "assets/icons/home.png",
              press: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));

              },
            ),
            DrawerListTile(
              title: "Bookings",
              svgSrc: "assets/icons/booking.png",
              press: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BookingScreen()));

              },
            ),
            DrawerListTile(
              title: "Users",
              svgSrc: "assets/icons/person.png",
              press: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => RoleScreen()));

              },
            ),
            DrawerListTile(
              title: "Branches",
              svgSrc: "assets/icons/branch.png",
              press: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MainScreen()));

              },
            ),


            DrawerListTile(
              title: "Services",
              svgSrc: "assets/icons/service.png",
              press: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ServiceScreen()));

              },
            ),
            DrawerListTile(
              title: "Specialists",
              svgSrc: "assets/icons/specialist.png",
              press: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SpecialistScreen()));

              },
            ),

            DrawerListTile(
              title: "Offers",
              svgSrc: "assets/icons/offer.png",
              press: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => OfferScreen()));

              },
            ),
            DrawerListTile(
              title: "Coupons",
              svgSrc: "assets/icons/coupon.png",
              press: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => CouponScreen()));

              },
            ),
            DrawerListTile(
              title: "Reviews",
              svgSrc: "assets/icons/review.png",
              press: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ReviewScreen()));

              },
            ),
            DrawerListTile(
              title: "Notifications",
              svgSrc: "assets/icons/notification.png",
              press: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => NotificationScreen()));

              },
            ),
            DrawerListTile(
              title: "Questionnaire",
              svgSrc: "assets/icons/question.png",
              press: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => NotificationScreen()));

              },
            ),
            DrawerListTile(
              title: "About Us",
              svgSrc: "assets/icons/about.png",
              press: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => AboutScreen()));

              },
            ),
            DrawerListTile(
              title: "Portrait Banner",
              svgSrc: "assets/icons/banner.png",
              press: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => PortraitScreen()));

              },
            ),
            DrawerListTile(
              title: "Popup Ads",
              svgSrc: "assets/icons/ads.png",
              press: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => NotificationScreen()));

              },
            ),
            DrawerListTile(
              title: "Settings",
              svgSrc: "assets/icons/setting.png",
              press: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SettingScreen()));

              },
            ),



          ],
        ),
      )
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Image.asset(
        svgSrc,
        color: Colors.white54,
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
