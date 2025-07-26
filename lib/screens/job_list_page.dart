import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing/blocs/jobs_bloc.dart';

class JobListPage extends StatelessWidget {
  const JobListPage({super.key});

  @override
  Widget build(BuildContext context) {
    String formatDate(DateTime date) {
      final now = DateTime.now();
      final diff = now.difference(date).inDays;
      return '$diff days ago';
    }

    return Scaffold(
      appBar: AppBar(title: Text('Jobs')),
      body: BlocBuilder<JobsBloc, JobsState>(
        builder: (context, state) {
          if (state is JobLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is JobError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Failed to load jobs'),
                  ElevatedButton(
                    onPressed: () => context.read<JobsBloc>().add(FetchJobs()),
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is JobLoaded) {
            return ListView.builder(
              itemCount: state.jobs.length,
              itemBuilder: (context, index) {
                final job = state.jobs[index];
                return ListTile(
                  title: Text(job.title),
                  subtitle: Text(
                    '${job.description}...\nBudget: \$${job.budget} — Posted ${formatDate(job.postedAt)}',
                  ),
                );
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
