import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';
import 'package:cinemapedia/infrastructure/datasources/drift_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/drift_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localStorageRepositoryProvider = Provider<LocalStorageRepository>(
  (ref) => DriftRepositoryImpl(DriftDatasource()),
);
