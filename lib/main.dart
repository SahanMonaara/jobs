import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing/screens/job_list_page.dart';

import 'blocs/jobs_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Browser',
      home: BlocProvider(
        create: (_) => JobsBloc()..add(FetchJobs()),
        child: JobListPage(),
      ),
    );
  }
}