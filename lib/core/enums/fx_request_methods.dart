enum FXRequestMethods {
  GET('GET'),
  PATCH('PATCH'),
  POST('POST'),
  PUT('PUT'),
  DELETE('PUT');

  final String stringValue;
  const FXRequestMethods(this.stringValue);
}
