import 'package:cmt_projekt/view_models/stream_vm.dart';
import 'package:cmt_projekt/view_models/main_vm.dart';
import 'package:flutter/material.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart';
import 'package:provider/provider.dart';
import 'package:cmt_projekt/view_models/navigation_vm.dart';
import 'package:cmt_projekt/constants.dart' as constants;

class GoLiveSettings extends StatelessWidget {
  const GoLiveSettings({Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    MainVM mainVM = Provider.of<MainVM>(context);
    StreamVM streamVM = Provider.of<StreamVM>(context);

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
                        mainVM.getEmail() ?? 'Gäst',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8 - 130,
                        width: MediaQuery.of(context).size.width,
                        child: ListView(
                        shrinkWrap: true,
                        clipBehavior: Clip.hardEdge,
                        children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: mainVM.channelName,
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
                          value: mainVM.category,
                          isExpanded: true,
                          validator: (value) => null,
                          autovalidateMode: AutovalidateMode.always,
                          items:
                          mainVM.categoryToDropdownMenuItemList(),
                          onChanged: (value) {
                            mainVM.setCategory(value);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: mainVM.app.channelDescription,
                          decoration: const InputDecoration(
                            labelText: 'Kanalens Beskrvning',
                            suffixIcon: Icon(Icons.description_outlined)
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column( children: [
                                const Text(
                                  "Uppdatera Tidstabellen",
                                  style: TextStyle(fontSize: 16)
                                ),
                                TextFormField(
                                  readOnly: true,
                                  controller: mainVM.app.timetableStartDateStr,

                                  onTap: () async {
                                    final d = await showDatePicker(
                                        context: context,
                                        initialDate: mainVM.timetableStartTimestamp,
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.now().add(const Duration(days: 365))
                                      );
                                    if(d != null) {
                                      mainVM.timetableStartTimestamp  = d;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    labelText: "Start Datum",
                                    suffixIcon: Icon(Icons.event)
                                  ),
                                ),
                                TextFormField(
                                  readOnly: true,
                                  controller: mainVM.app.timetableStartTimeStr,

                                  onTap: () async {
                                    final t = await showTimePicker(
                                      context: context,
                                      initialTime: mainVM.timetableStartTime
                                    );
                                    if(t != null){
                                      mainVM.timetableStartTime = t;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                      labelText: "Start Tid",
                                      suffixIcon: Icon(Icons.access_time_outlined)
                                  ),
                                ),
                                TextFormField(
                                  readOnly: true,
                                  controller: mainVM.app.timetableEndDateStr,
                                  onTap: () async {
                                    final v = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now().add(const Duration(days: 365))
                                    );
                                    if(v != null){
                                      mainVM.timetableEndTimestamp = v;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                      labelText: "Slut Datum",
                                      suffixIcon: Icon(Icons.event)
                                  ),
                                ),
                                TextFormField(
                                  readOnly: true,
                                  controller: mainVM.app.timetableEndTimeStr,
                                  onTap: () async {
                                    final v = await showTimePicker(
                                      context: context,
                                      initialTime: mainVM.timetableEndTime
                                    );
                                    if(v != null){
                                      mainVM.timetableEndTime = v;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                      labelText: "Slut Tid",
                                      suffixIcon: Icon(Icons.access_time_outlined)
                                  ),
                                ),
                                TextFormField(
                                  controller: mainVM.app.timetableDescription,
                                  decoration: const InputDecoration(
                                    labelText: "Tabellrads beskrivning",
                                    suffixIcon: Icon(Icons.description)
                                  )
                                ),
                                ElevatedButton(
                                    onPressed: () => mainVM.addToTimetable(),
                                    child: const Text("Lägg till"),
                                    style: ButtonStyle(
                                      minimumSize: MaterialStateProperty.all(const Size.fromHeight(40)),
                                    ),
                                ),
                                const Divider(),
                                const Text(
                                    "Befintlig Tidstabell",
                                    style: TextStyle(fontSize: 16),
                                ),
                                ListView.builder(
                                    itemCount: context.watch<MainVM>().app.timetable.length,
                                    shrinkWrap: true,
                                    itemBuilder: (ctx, i) => Card(
                                      elevation: 4,
                                      margin: const EdgeInsets.all(5),
                                      child: Column(
                                        children: [
                                          Text(mainVM.app.timetable[i].startTime.toString()),
                                          Text(mainVM.app.timetable[i].endTime.toString()),
                                          Text(mainVM.app.timetable[i].description.toString()),
                                          ElevatedButton(
                                              onPressed: (){
                                                mainVM.app.timetable.removeAt(i);
                                              },
                                              child: const Icon(Icons.delete),
                                              style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                                              )
                                          )
                                        ],
                                      )
                                    )
                                )
                              ],)
                          )
                        )
                      )
                    ])
                  )
                ],
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: GradientElevatedButton.icon(
                    onPressed: () {
                      mainVM.setChannelSettings();
                      Navigator.pop(context);
                      if(streamVM.streamModel.isInitiated){
                        streamVM.sendUpdate(context, mainVM.channelData);
                      } else {
                        streamVM.startup(context, mainVM.channelData);
                        Provider.of<NavVM>(context, listen: false).pushView(constants.hostChannel);
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
