import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spa_admin_panel/responsive.dart';

import 'constants.dart';
class Header extends StatelessWidget {
  String title;GlobalKey<ScaffoldState> _scaffoldKey;


  Header(this.title,this._scaffoldKey);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: Icon(Icons.menu,color: Colors.white,),
            onPressed: (){
              if (!_scaffoldKey.currentState!.isDrawerOpen) {
                _scaffoldKey.currentState!.openDrawer();
              }
            },
          ),
        if (!Responsive.isMobile(context))
          Text(
            title,
            style: Theme.of(context).textTheme.headline4!.apply(color: Colors.white),
          ),
      ],
    );
  }
}

