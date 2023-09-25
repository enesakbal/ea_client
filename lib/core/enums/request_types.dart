enum RequestTypes {
  GET('GET'),
  PATCH('PATCH'),
  POST('POST'),
  PUT('PUT'),
  DELETE('DELETE');

  final String stringValue;
  const RequestTypes(this.stringValue);
}
