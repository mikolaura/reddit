import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/Features/auth/controllers/auth_controller.dart';
import 'package:reddit/Features/home/drawer/comunity_list_drawer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  void displatDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: false,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: ()=> displatDrawer(context),
            );
          }
        ),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.search)),
          IconButton(

            icon: CircleAvatar(
              backgroundImage: NetworkImage(user.profilePic.toString()),
              
            ),
            onPressed: (){},
          )
        ],
      ),
      drawer: ComunityListDrawer(),
    );
  }
}