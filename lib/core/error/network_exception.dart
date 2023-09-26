import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

import '../enums/server_client_exceptions.dart';

class NetworkException extends Equatable {
  final ServerExceptionType exceptionType;
  final String message;
  final int? statusCode;

  const NetworkException({
    required this.exceptionType,
    required this.message,
    required this.statusCode,
  });

  const NetworkException._({
    required this.message,
    required this.statusCode,
    this.exceptionType = ServerExceptionType.unexpectedError,
  });

  @override
  List<Object?> get props => [exceptionType, message, statusCode];

  ///* DIO
  factory NetworkException.fromDioError(DioExceptionType error, {int? statusCode}) {
    // const ServerExceptionType exceptionType = ServerExceptionType.unknownError;
    // const String message = 'An unexpected error occurred';
    // int? statusCode;

    late NetworkException serverException;

    try {
      switch (error) {
        case DioExceptionType.cancel:
          serverException = NetworkException._(
            exceptionType: ServerExceptionType.requestCancelled,
            statusCode: statusCode,
            message: 'Request to the server has been canceled.',
          );

        case DioExceptionType.connectionTimeout:
          serverException = NetworkException._(
            exceptionType: ServerExceptionType.requestTimeout,
            statusCode: statusCode,
            message: 'Connection timeout.',
          );

        case DioExceptionType.receiveTimeout:
          serverException = NetworkException._(
            exceptionType: ServerExceptionType.recieveTimeout,
            statusCode: statusCode,
            message: 'Receive timeout.',
          );

        case DioExceptionType.sendTimeout:
          serverException = NetworkException._(
            exceptionType: ServerExceptionType.sendTimeout,
            statusCode: statusCode,
            message: 'Send timeout.',
          );

        case DioExceptionType.connectionError:
          serverException = NetworkException._(
            exceptionType: ServerExceptionType.connectionError,
            message: 'Connection error.',
            statusCode: statusCode,
          );

        case DioExceptionType.badCertificate:
          serverException = NetworkException._(
            exceptionType: ServerExceptionType.badCertificate,
            message: 'Bad certificate.',
            statusCode: statusCode,
          );

        case DioExceptionType.unknown:
          if (error.toString().contains(ServerExceptionType.socketException.name)) {
            serverException = NetworkException._(
              statusCode: statusCode,
              message: 'Verify your internet connection.',
            );
          } else {
            serverException = NetworkException._(
              statusCode: statusCode,
              message: 'Unexpected error.',
            );
          }

        case DioExceptionType.badResponse:
          switch (statusCode) {
            case 400:
              serverException = const NetworkException._(
                exceptionType: ServerExceptionType.badRequest,
                message: 'Bad request.',
                statusCode: 400,
              );
            case 401:
              serverException = const NetworkException._(
                exceptionType: ServerExceptionType.unauthorisedRequest,
                message: 'Authentication failure.',
                statusCode: 401,
              );
            case 403:
              serverException = const NetworkException._(
                exceptionType: ServerExceptionType.unauthorisedRequest,
                message: 'User is not authorized to access API.',
                statusCode: 403,
              );
            case 404:
              serverException = const NetworkException._(
                exceptionType: ServerExceptionType.notFound,
                message: 'Not Found.',
                statusCode: 404,
              );
            case 405:
              serverException = const NetworkException._(
                exceptionType: ServerExceptionType.unauthorisedRequest,
                message: 'Operation not allowed.',
                statusCode: 405,
              );
            case 415:
              serverException = const NetworkException._(
                exceptionType: ServerExceptionType.notImplemented,
                message: 'Media type unsupported.',
                statusCode: 415,
              );
            case 422:
              serverException = const NetworkException._(
                exceptionType: ServerExceptionType.unableToProcess,
                message: 'validation data failure.',
                statusCode: 422,
              );
            case 429:
              serverException = const NetworkException._(
                exceptionType: ServerExceptionType.conflict,
                message: 'too much requests.',
                statusCode: 429,
              );
            case 500:
              serverException = const NetworkException._(
                exceptionType: ServerExceptionType.internalServerError,
                message: 'Internal server error.',
                statusCode: 500,
              );
            case 503:
              serverException = const NetworkException._(
                exceptionType: ServerExceptionType.serviceUnavailable,
                message: 'Service unavailable.',
                statusCode: 503,
              );
            default:
              serverException = const NetworkException._(
                message: 'Unexpected error.',
                statusCode: -1,
              );
          }
      }
    } on FormatException catch (e) {
      serverException = NetworkException._(
        exceptionType: ServerExceptionType.formatException,
        message: e.message,
        statusCode: statusCode,
      );
    } on SocketException catch (e) {
      serverException = NetworkException._(
        exceptionType: ServerExceptionType.socketException,
        message: e.message,
        statusCode: -1,
      );
    } on Exception {
      serverException = const NetworkException._(
        message: 'Unexpected error.',
        statusCode: -1,
      );
    }
    return serverException;
  }

  ///* HTTP
  factory NetworkException.fromHttpError(http.BaseResponse response) {
    final int statusCode = response.statusCode;

    late NetworkException serverException;

    try {
      switch (statusCode) {
        case 400:
          serverException = NetworkException(
            exceptionType: ServerExceptionType.badRequest,
            message: 'Bad request.',
            statusCode: statusCode,
          );
          break;
        case 401:
          serverException = NetworkException(
            exceptionType: ServerExceptionType.unauthorisedRequest,
            message: 'Unauthorized.',
            statusCode: statusCode,
          );
          break;
        case 403:
          serverException = NetworkException(
            exceptionType: ServerExceptionType.forbidden,
            message: 'Forbidden.',
            statusCode: statusCode,
          );
          break;
        case 404:
          serverException = NetworkException(
            exceptionType: ServerExceptionType.notFound,
            message: 'Not Found.',
            statusCode: statusCode,
          );
          break;
        case 422:
          serverException = NetworkException(
            exceptionType: ServerExceptionType.unprocessableEntity,
            message: 'Unprocessable Entity.',
            statusCode: statusCode,
          );
          break;
        case 429:
          serverException = NetworkException(
            exceptionType: ServerExceptionType.tooManyRequests,
            message: 'Too Many Requests.',
            statusCode: statusCode,
          );
          break;
        case 500:
          serverException = NetworkException(
            exceptionType: ServerExceptionType.internalServerError,
            message: 'Internal Server Error.',
            statusCode: statusCode,
          );
          break;
        case 503:
          serverException = NetworkException(
            exceptionType: ServerExceptionType.serviceUnavailable,
            message: 'Service Unavailable.',
            statusCode: statusCode,
          );
          break;
        default:
          if (statusCode >= 400 && statusCode < 500) {
            serverException = NetworkException(
              exceptionType: ServerExceptionType.clientError,
              message: 'Client Error.',
              statusCode: statusCode,
            );
          } else if (statusCode >= 500) {
            serverException = NetworkException(
              exceptionType: ServerExceptionType.internalServerError,
              message: 'Server Error.',
              statusCode: statusCode,
            );
          } else {
            serverException = NetworkException(
              exceptionType: ServerExceptionType.unexpectedError,
              message: 'An unexpected error occurred.',
              statusCode: statusCode,
            );
          }
          break;
      }
    } on FormatException catch (e) {
      serverException = NetworkException._(
        exceptionType: ServerExceptionType.formatException,
        message: e.message,
        statusCode: statusCode,
      );
    } on SocketException catch (e) {
      serverException = NetworkException._(
        exceptionType: ServerExceptionType.socketException,
        message: e.message,
        statusCode: -1,
      );
    } on Exception {
      serverException = const NetworkException._(
        message: 'Unexpected error.',
        statusCode: -1,
      );
    }

    return serverException;
  }
}
