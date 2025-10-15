import 'package:flutter/cupertino.dart';

enum RequestStatus { idle, loading, success, error }

typedef VoidRequestState = RequestState<Never>;

class RequestState<T> {
  final RequestStatus _status;
  final List<String> _errors;
  final T? _data;

  RequestStatus get status => _status;
  List<String> get errors => _errors;
  T? get data => _data;

  const RequestState._({
    required RequestStatus status,
    List<String> errors = const [],
    T? data,
  }) : _data = data,
       _errors = errors,
       _status = status;

  const RequestState._idle() : this._(status: RequestStatus.idle);
  const RequestState._loading() : this._(status: RequestStatus.loading);
  const RequestState.success(T data)
    : this._(status: RequestStatus.success, data: data);
  factory RequestState.error(List<String> errors) {
    assert(errors.isNotEmpty, 'errors cannot be empty');
    return RequestState._(status: RequestStatus.error, errors: errors);
  }

  static VoidRequestState idle = RequestState._idle();
  static VoidRequestState loading = RequestState._loading();
}

extension DisplayResult<T> on RequestState<T> {
  Widget displayResult({
    Widget Function()? onIdle,
    Widget Function()? onLoading,
    Widget Function(List<String> error)? onError,
    required Widget Function(T data) onSuccess,
  }) {
    return switch (_status) {
      RequestStatus.idle => onIdle?.call() ?? const SizedBox.shrink(),
      RequestStatus.loading => onLoading?.call() ?? const SizedBox.shrink(),
      RequestStatus.error =>
        onError?.call(errors) ?? const Text('Ocurrió un error'),
      RequestStatus.success => onSuccess(data as T),
    };
  }
}
