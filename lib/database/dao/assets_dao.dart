class AssetsDao {
  static const String tableSql = 'CREATE TABLE $_tableName('
      '$_id INTEGER PRIMARY KEY AUTOINCREMENT, '
      '$_name TEXT, '
      '$_code TEXT, '
      '$_userId INTEGER DEFAULT NULL, '
      '$_dtInventory TEXT DEFAULT NULL, '
      '$_status INTEGER DEFAULT 1)';

  static const String _tableName = 'assets';
  static const String _id = 'id';
  static const String _name = 'name';
  static const String _code = 'code';
  static const String _userId = 'userId';
  static const String _dtInventory = 'dtInventory';
  static const String _status = 'status';
}
