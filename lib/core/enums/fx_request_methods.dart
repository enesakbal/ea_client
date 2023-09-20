enum FXRequestMethods {
  GET('GET'),
  PATCH('PATCH'),
  POST('POST'),
  PUT('PUT'),
  DELETE('DELETE');

  final String stringValue;
  const FXRequestMethods(this.stringValue);
}
