enum RequestMethods {
  GET('GET'),
  PATCH('PATCH'),
  POST('POST'),
  PUT('PUT'),
  DELETE('DELETE');

  final String stringValue;
  const RequestMethods(this.stringValue);
}
