import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:testing/blocs/jobs_bloc.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  setUpAll(() {
    registerFallbackValue(Uri.parse('https://60f294686d44f300177886cc.mockapi.io/test/api/jobs'));
  });

  group('JobBloc Test', () {
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
    });

    blocTest<JobsBloc, JobsState>(
      'emits [JobLoading, JobLoaded] when jobs are fetched successfully',
      build: () {
        when(() => mockClient.get(any())).thenAnswer(
              (_) async => http.Response(jsonEncode([
            {
              "id": "1",
              "title": "Test Job",
              "description": "A test job description",
              "budget": "1000.00",
              "posted_at": DateTime.now().toIso8601String(),
            }
          ]), 200),
        );
        return JobsBloc(httpClient: mockClient);
      },
      act: (bloc) => bloc.add(FetchJobs()),
      expect: () => [isA<JobLoading>(), isA<JobLoaded>()],
    );
  });
}