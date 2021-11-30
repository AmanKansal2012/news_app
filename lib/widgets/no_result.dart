import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class NoResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/no_result.svg",height: 100,width: 100,),
          Padding(
            padding: const EdgeInsets.only(top:4.0),
            child: Text("No result found!",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
          )
        ],
      ),
    );
  }
}
