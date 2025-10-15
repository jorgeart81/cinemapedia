import 'package:flutter/cupertino.dart';

enum RequestStatus { idle, loading, success, error }

sealed class RequestState<T, E> {
  final RequestStatus status;
  final T? data;
  final E? error;

  const RequestState._({required this.status, this.data, this.error});

  const RequestState.idle() : this._(status: RequestStatus.idle);
  const RequestState.loading() : this._(status: RequestStatus.loading);
  const RequestState.success(T data)
    : this._(status: RequestStatus.success, data: data);
  const RequestState.error(E error)
    : this._(status: RequestStatus.error, error: error);
}

extension DisplayResult<T, E> on RequestState<T, E> {
  Widget displayResult({
    Widget Function()? onIdle,
    Widget Function()? onLoading,
    Widget Function(E error)? onError,
    Widget Function(T data)? onSuccess,
  }) {
    return switch (status) {
      RequestStatus.idle => onIdle?.call() ?? const SizedBox.shrink(),
      RequestStatus.loading => onLoading?.call() ?? const SizedBox.shrink(),
      RequestStatus.error =>
        onError?.call(error as E) ?? const Text('Ocurrió un error'),
      RequestStatus.success =>
        onSuccess?.call(data as T) ?? const Text('Operación exitosa'),
    };
  }
}
