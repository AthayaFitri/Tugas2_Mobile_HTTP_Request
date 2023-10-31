// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_2/api_data_source.dart';
import 'package:flutter_application_2/page_users_detail.dart';
import 'package:flutter_application_2/users_model.dart';

class PageListUsers extends StatelessWidget {
  const PageListUsers({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Users'),
      ),
      body: _buildListUsersBody(),
    );
  }

  Widget _buildListUsersBody() {
    return FutureBuilder(
      future: ApiDataSource.instance.loadUsers(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingSection();
        } else if (snapshot.hasError) {
          return _buildErrorSection();
        } else if (snapshot.hasData) {
          UsersModel usersModel = UsersModel.fromJson(snapshot.data);
          return _buildSuccessSection(usersModel);
        } else {
          return _buildErrorSection();
        }
      },
    );
  }

  Widget _buildErrorSection() {
    return const Center(child: Text('Error'));
  }

  Widget _buildLoadingSection() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildSuccessSection(UsersModel data) {
    return ListView.builder(
      itemCount: data.data!.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildItemUsers(context, data.data![index]);
      },
    );
  }

  Widget _buildItemUsers(BuildContext context, Data userData) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PageUsersDetail(id: userData.id!),
          ),
        );
      },
      child: Card(
        elevation: 4, // Menambah bayangan card
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(userData.avatar!),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${userData.firstName!} ${userData.lastName!}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    userData.email!,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
