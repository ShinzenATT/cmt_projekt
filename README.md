Comment

What is Comment?
Comment is a platform where users can create their own radio channels and broadcast to other users. There are currently several categories that users can choose between, these are as follows:
Sport
Rock
Jazz
Pop
Tjööt

To be able to create a channel, it is required to have a registered account which can be created through the application. Requirements to create an account consist of an email address and password. It is however possible to view other’s broadcasts as a guest user. 
Once a user either logs in or enters as a guest, the app transitions to a page which displays all live channels within each respective category. The user may then join or leave any channel.

Comment is currently in an early phase of development and does not have all planned features implemented at this point. It does however have basic functionality such as account creation, channel creation and the ability to stream sound to multiple clients.

Why is the project useful?
Comment aims to provide a combination of both traditional podcasts but also live sessions (in the form of radio channels), allowing users to interact with their favorite streamer and the broadcaster to interact with their fans. As the cherry on the top, it is free of charge and available for anyone to use. 

How users can get started with the project
To get started and setup your own test environment is relatively simple:
Setup your local network so that it accepts and properly forward UDP/TCP traffic on ports 5604, 5605.
_Follow the flutter guide on how to configure your IDE with flutter https://docs.flutter.dev/get-started/editor, and clone the repository.
_Setup and configure a postgres database with the SQL file provided from the repo. 
Update the  ip used in constants.dart to reflect your server and databases local ip.
Start database_api.dart.
Start stream_server.dart.

Once this is done in order to run the application first start the database server and stream server. 


How to generate and install an APK on your android. 
If you want to use the application on your physical android phone rather than the emulator, you can generate an APK (a file which represents the app), install it on your phone and then run it. This allows you to test the application on a physical device rather than solely testing it on an emulator. 
To generate and install the APK, follow the guide from flutter’s official website: https://docs.flutter.dev/deployment/android 


Where users can get help with your project
For inquiries and problems with the app contact the support division of CMT Sweden. 

Who maintains and contributes to the project
This project is currently maintained by CMT Sweden. Prior to this however, the project was developed and maintained by students enrolled at Chalmers University of Technology as part of a course assignment.

