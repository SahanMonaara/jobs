part of 'jobs_bloc.dart';

abstract class JobsState {}

final class JobsInitial extends JobsState {}

final class JobLoading extends JobsState {}

final class JobLoaded extends JobsState{
  final List<Job> jobs;
  JobLoaded(this.jobs);
}

final class JobError extends JobsState{}
