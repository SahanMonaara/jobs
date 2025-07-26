import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:testing/blocs/jobs_bloc.dart';
import 'package:testing/model/jobs.dart';
import 'package:testing/screens/job_list_page.dart';

// Mocks and Fakes
class MockJobsBloc extends Mock implements JobsBloc {}

class FakeJobsEvent extends Fake implements JobsEvent {}

class FakeJobsState extends Fake implements JobsState {}

void main() {
  late MockJobsBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeJobsEvent());
    registerFallbackValue(FakeJobsState());
  });

  setUp(() {
    mockBloc = MockJobsBloc();
  });

  testWidgets('shows CircularProgressIndicator when state is JobLoading', (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(JobLoading());
    whenListen(mockBloc, Stream.fromIterable([JobLoading()]));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<JobsBloc>.value(
          value: mockBloc,
          child: const JobListPage(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error UI when state is JobError', (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(JobError());
    whenListen(mockBloc, Stream.fromIterable([JobError()]));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<JobsBloc>.value(
          value: mockBloc,
          child: const JobListPage(),
        ),
      ),
    );

    expect(find.text('Failed to load jobs'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('taps retry button and dispatches FetchJobs', (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(JobError());
    when(() => mockBloc.stream).thenAnswer((_) => Stream.value(JobError()));
    when(() => mockBloc.add(any())).thenReturn(null);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<JobsBloc>.value(
          value: mockBloc,
          child: const JobListPage(),
        ),
      ),
    );

    expect(find.byType(ElevatedButton), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    verify(() => mockBloc.add(any(that: isA<FetchJobs>()))).called(1);
  });

  testWidgets('shows job list when state is JobLoaded', (WidgetTester tester) async {
    final jobs = [
      Job(
        id: '1',
        title: 'Flutter Developer',
        description: 'Build Flutter apps',
        budget: 300,
        postedAt: DateTime.now().subtract(Duration(days: 3)),
      ),
      Job(
        id: '2',
        title: 'Backend Engineer',
        description: 'Node.js and Express',
        budget: 500,
        postedAt: DateTime.now().subtract(Duration(days: 5)),
      ),
    ];

    when(() => mockBloc.state).thenReturn(JobLoaded(jobs));
    whenListen(mockBloc, Stream.fromIterable([JobLoaded(jobs)]));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<JobsBloc>.value(
          value: mockBloc,
          child: const JobListPage(),
        ),
      ),
    );

    expect(find.byType(ListTile), findsNWidgets(2));
    expect(find.text('Flutter Developer'), findsOneWidget);
    expect(find.text('Backend Engineer'), findsOneWidget);
  });
}