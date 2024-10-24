import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

class AccountDeactivate extends StatelessWidget {
  const AccountDeactivate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AvatarGlow(
            glowColor: Colors.green[300]!,
            endRadius: 90.0,
            duration: Duration(milliseconds: 2000),
            repeat: true,
            showTwoGlows: true,
            repeatPauseDuration: Duration(milliseconds: 100),
            child: Image.asset(
              'images/logos/Kisanserv.png',
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Your Account Is Blocked/Deactivated, Please Contact KisanServ Team.',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontSize: 25.0, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
