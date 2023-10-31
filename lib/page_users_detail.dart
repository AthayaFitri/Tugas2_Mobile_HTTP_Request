// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import '../api_data_source.dart';
import '../users_detail.dart';

class PageUsersDetail extends StatelessWidget {
  final int id;
  const PageUsersDetail({required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail User ${id}'),
        backgroundColor: Color.fromARGB(255, 223, 184, 255),
      ),
      body: FutureBuilder(
        future: ApiDataSource.instance.loadDetailUser(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: const CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final detailUser = DetailUserModel.fromJson(snapshot.data!);

            if (detailUser.data != null) {
              final userData = detailUser.data!;

              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(userData.avatar!),
                      ),
                      SizedBox(height: 16),
                      Text(
                        '${userData.firstName} ${userData.lastName}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        userData.email!,
                        style: TextStyle(fontSize: 18),
                      ),
                      // Add more user details as needed
                    ],
                  ),
                ),
              );
            } else {
              return Center(child: Text("Data pengguna tidak tersedia."));
            }
          }
          return Center(child: Text("Tidak ada data tersedia."));
        },
      ),
    );
  }
}
