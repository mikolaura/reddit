import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/Features/comunity/controllers/community_controller.dart';
import 'package:reddit/core/common/error_text.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

class ComunityListDrawer extends ConsumerWidget {
  const ComunityListDrawer({super.key});
  void navigateToCreateComunity(BuildContext context) {
    Routemaster.of(context).push("/create-comunity");
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea (
        child: Column(
          children: [
            ListTile(
              title: Text("Create A comunity"),
              leading: Icon(Icons.add),
              onTap: ()=> navigateToCreateComunity(context),//3:08:46
            ),
            ref.watch(userCommunitiesProvider).when(data: (communities)=> 
            Expanded(
              child: ListView.builder(
                itemCount: communities.length,
                itemBuilder: (BuildContext context, int index) {
                  final community = communities[index];
                  return ListTile(
                    leading: CircleAvatar(backgroundImage: NetworkImage(community.avatar)),
                    title: Text('r/${community.name}'),
                    onTap: (){}
            
                  );
                },
              ),
            ),error: (error,StackTrace)=>ErrorText(err: error.toString()), loading: () => const Loader())
          ],
        ),
      )
    );
  }
}