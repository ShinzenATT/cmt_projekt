import 'package:cmt_projekt/constants.dart';
import 'package:cmt_projekt/view_models/stream_vm.dart';
import 'package:cmt_projekt/view_models/main_vm.dart';
import 'package:flutter/material.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart';
import 'package:provider/provider.dart';

class GoLiveSettings extends StatelessWidget {
  const GoLiveSettings({Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.account_circle_outlined,
                          size: 40,
                        ),
                      ),
                      Text(
                        context.read<MainViewModel>().getEmail() ?? 'Gäst',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: context.watch<MainViewModel>().channelName,
                      decoration: const InputDecoration(
                        labelText: 'Namn på radiokanal',
                        suffixIcon: Icon(Icons.note_alt_outlined),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Kategori',
                        border: OutlineInputBorder(),
                      ),
                      value: context.watch<MainViewModel>().getCategory,
                      isExpanded: true,
                      validator: (value) => null,
                      autovalidateMode: AutovalidateMode.always,
                      items:
                          context.read<MainViewModel>().categoryToDropdownMenuItemList(),
                      onChanged: (value) {
                        context.read<MainViewModel>().setCategory(value);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: GradientElevatedButton.icon(
                    onPressed: () {
                      context.read<MainViewModel>().setChannelSettings();
                      Navigator.pop(context);
                      if(context.read<StreamViewModel>().smodel.isInitiated){
                        logger.i("uwu");
                        context.read<StreamViewModel>().sendUpdate(context);
                      } else {
                        context.read<StreamViewModel>().startup(context);
                        Navigator.of(context).popAndPushNamed(hostChannel);
                      }
                    },
                    gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.greenAccent,
                          Colors.blueAccent,
                        ]),
                    icon: Padding(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.2,
                          left: MediaQuery.of(context).size.width * 0.2),
                      child: const Text(
                        'Gå Live',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    label: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
