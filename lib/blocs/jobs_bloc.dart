import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../model/jobs.dart';

part 'jobs_event.dart';
part 'jobs_state.dart';

class JobsBloc extends Bloc<JobsEvent, JobsState> {
  final http.Client httpClient;

  JobsBloc({http.Client? httpClient})
    : httpClient = httpClient ?? http.Client(),
      super(JobLoading()) {
    on<FetchJobs>((event, emit) async {
      emit(JobLoading());
      try {
        final response = await httpClient?.get(
          Uri.parse(
            'https://60f294686d44f300177886cc.mockapi.io/test/api/jobs',
          ),
        );
        if (response!.statusCode == 200) {
          List jobsResponse = jsonDecode(response.body);
          List<Job> jobs = jobsResponse
              .map((job) => Job.fromJson(job))
              .toList();
          emit(JobLoaded(jobs));
        } else {
          emit(JobError());
        }
      } catch (e) {
        debugPrint(e.toString());
        emit(JobError());
      }
    });
  }
}
