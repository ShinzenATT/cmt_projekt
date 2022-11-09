# Comment

## What is Comment?
Comment is a platform where users can create their own radio channels and broadcast to other users. 
There are currently several categories that users can choose between, these are as follows:
Sport, Rock, Jazz, Pop, Tjööt and more to come!

To be able to create a channel, it is required to have a registered account which can be created through the application. Requirements to create an account consist of an email address and password. It is however possible to view other’s broadcasts as a guest user. 
Once a user either logs in or enters as a guest, the app transitions to a page which displays all live channels within each respective category. The user may then join or leave any channel.

Comment is currently in an early phase of development and does not have all planned features implemented at this point. It does however have basic functionality such as account creation, channel creation and the ability to stream sound to multiple clients.

## Why is the project useful?
Comment aims to provide a combination of both traditional podcasts but also live sessions (in the form of radio channels), allowing users to interact with their favorite streamer and the broadcaster to interact with their fans. As the cherry on the top, it is free of charge and available for anyone to use. 

## How users can get started with the project
To get started and setup your own test environment is relatively simple:
Setup your local network so that it accepts and properly forward UDP/TCP traffic on ports 5604, 5605.
Follow the flutter guide on how to configure your IDE with [flutter](https://docs.flutter.dev/get-started/editor), and clone the repository.

This project uses Flutter v2 so if you have installed flutter V3 or newer then run this command:
```bash
flutter downgrade 2.10 # downgrades flutter to version 2.10.5
```

Use this command to verify that everything is installed correctly:
```bash
flutter doctor
```

Setup and configure a postgres database with the SQL file `lib/server/server.sql` provided from the repo.
Alternatively, if you have docker you can run `docker-compose up db` to setup a development postgres db container.

In the `lib` folder copy and rename `environment.dart.example` to `environment.dart`. 
Update `lib/environment.dart` with db configs and the ip to your db/stream servers. 
For development, you need to use your device's local ip which can be found with the 
command `ipconfig`(windows) or `ifconfig` (Unix), "localhost" will not work since the android emulator will not find it. 

Afterwards you can start the servers by running the command `dart run <file>` on the following files found in `lib/server`:
- Start **database_server.dart**
- Start **stream_server.dart**

Once this is done in order to run the application first start the database server and stream server. 
You can then download and install the apk provided in this repository or run them with the flutter commands below.

### Building the project
Most IDEs like Android Studio should handle most things automatically but you can run  these commands  anyway.
You may need to configure an Android emulator trough Android Studio for running the app.

#### Downloading dependencies
```bash
flutter pub get
```

#### Lint Dart code
```bash
flutter analyze
```

#### Build
```bash
flutter build apk # build for android
flutter install # install app to virtual/physical device (use adb if needed)
flutter run # builds, installs and runs the app on a device

flutter build ipa # builds for ios (only on macOS)
flutter run

flutter build web # build website
```

#### Runs tests
```bash
flutter test
```

## How to generate and install an APK on your android. 
If you want to use the application on your physical android phone rather than the emulator, you can generate an APK (a file which represents the app), install it on your phone and then run it. This allows you to test the application on a physical device rather than solely testing it on an emulator. 
To generate and install the APK, follow the guide from flutter’s [official website](https://docs.flutter.dev/deployment/android). 


## Where users can get help with your project
For inquiries and problems with the app contact the support division of CMT Sweden. 

## Who maintains and contributes to the project
This project is currently maintained by CMT Sweden. Prior to this however, the project was developed and maintained by students enrolled at Chalmers University of Technology as part of a course assignment.
