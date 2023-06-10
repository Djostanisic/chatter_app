import 'package:chatter_app/helper/helper_function.dart';
import 'package:chatter_app/pages/auth/login_page.dart';
import 'package:chatter_app/pages/profile_page.dart';
import 'package:chatter_app/pages/search_page.dart';
import 'package:chatter_app/service/auth_service.dart';
import 'package:chatter_app/service/database_service.dart';
import 'package:chatter_app/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "";
  String email = "";
  String groupName = "";
  AuthService authService = AuthService();
  Stream? groups;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSP().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUsernameFromSP().then((value) {
      setState(() {
        userName = value!;
      });
    });
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  nextScreen(context, const SearchPage());
                },
                icon: const Icon(Icons.search))
          ],
          elevation: 0,
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text(
            "Groups",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 27),
          )),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey[700],
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              userName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(
              height: 2,
            ),
            ListTile(
                onTap: () {},
                selectedColor: Theme.of(context).primaryColor,
                selected: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: const Icon(Icons.group),
                title: const Text(
                  "Groups",
                  style: TextStyle(color: Colors.black),
                )),
            ListTile(
                onTap: () {
                  Navigator.pop(context);
                  nextScreenReplace(
                      context,
                      ProfilePage(
                        email: email,
                        userName: userName,
                      ));
                },
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: const Icon(Icons.person),
                title: const Text(
                  "Profile",
                  style: TextStyle(color: Colors.black),
                )),
            ListTile(
                onTap: () async {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Logout"),
                          content:
                              const Text("Are you sure you want to logout?"),
                          actions: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                )),
                            IconButton(
                                onPressed: () {
                                  authService.signOut().whenComplete(() {
                                    nextScreenReplace(
                                        context, const LoginPage());
                                  });
                                },
                                icon: const Icon(
                                  Icons.done,
                                  color: Colors.green,
                                ))
                          ],
                        );
                      });
                },
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: const Icon(Icons.exit_to_app),
                title: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.black),
                )),
          ],
        ),
      ),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popupDialog(context);
        },
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  popupDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Create a group",
              textAlign: TextAlign.left,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                isLoading == true
                    ? Center(
                        child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor))
                    : TextField(
                        onChanged: (value) {
                          setState(() {
                            groupName = value;
                          });
                        },
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(30)),
                            errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(30)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(30)))),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor),
                child: const Text("CANCEL"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (groupName != "") {
                    setState(() {
                      isLoading = true;
                    });
                    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                        .crateGroup(userName,
                            FirebaseAuth.instance.currentUser!.uid, groupName).whenComplete(() {
                              isLoading = false;
                            });
                            Navigator.pop(context);
                            showSnackBar(context, Colors.green, "Group created successfully.");
                  } else {}
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor),
                child: const Text("CREATE"),
              ),
            ],
          );
        });
  }

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['groups'].length != null &&
              snapshot.data['groups'].length != 0) {
            return Text("Hellooo");
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        }
      },
    );
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              popupDialog(context);
            },
            child: Icon(
              Icons.add_circle,
              color: Colors.grey[700],
              size: 75,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "You have not joined any groups, tap on the add icon to create a group or use the top search button to find and join a group.",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
