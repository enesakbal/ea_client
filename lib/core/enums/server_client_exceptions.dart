/// The code snippet is defining an enumeration called `ServerExceptionType` in the Dart programming
/// language. An enumeration is a special data type that represents a set of named values. In this case,
/// the `ServerExceptionType` enumeration represents different types of server exceptions that can occur
/// in an application.
enum ServerExceptionType {
  requestCancelled,
  badCertificate,
  connectionError,
  requestTimeout,
  sendTimeout,
  recieveTimeout,
  socketException,
  formatException,
  defaultError,
  unexpectedError,
  unknown,
  badResponse,
  badRequest,
  unauthorisedRequest,
  notFound,
  notImplemented,
  unableToProcess,
  conflict,
  clientError,
  serviceUnavailable,
  forbidden,
  unprocessableEntity,
  tooManyRequests,
  internalServerError;
}
