import 'package:cmt_projekt/viewmodel/vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

///Widget för sidan med profilinformation.
class AppProfileWidget extends StatelessWidget {
  const AppProfileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const Text(
                  'Profil information',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                  ),
                  child: Divider(
                    thickness: 2,
                    indent: 50,
                    endIndent: 50,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text(
                        'Användarnamn: ',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Text(
                      context.read<VM>().getEmail().toString(),
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text(
                        'User ID: ',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                      Text(
                      context.read<VM>().getUid().toString(),
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ), 
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
