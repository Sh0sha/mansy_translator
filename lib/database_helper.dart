import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart'; // Импорт библиотеки для работы с системными службами
import 'dart:io'; // Импорт библиотеки для работы с файловой системой

class DbHelper {
  static final DbHelper _instance = DbHelper._internal(); // Создание единственного экземпляра класса DatabaseHelper (синглтон).
  factory DbHelper() {
    return _instance; // Возвращение единственного экземпляра класса
  }

  DbHelper._internal(); // Закрытый конструктор для реализации паттерна синглтон

  Database? _database; // Переменная для хранения экземпляра БД

  Future<Database> get database async {
    if (_database != null) return _database!; // Возвращаем существующую БД, если она уже существует

    _database = await _initDatabase(); // Инициализация базы данных, если она еще не была инициализирована
    return _database!; // Возвращаем экземпляр базы данных
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'database.db'); // Определение пути к БД

    // Проверка и копирование базы данных из assets
    bool dbExist = await databaseExists(path); // Проверка существования БД

    if (!dbExist) {
      ByteData data = await rootBundle.load('assets/database.db'); // Загрузка базы данных из assets
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes); // Преобразование данных в байты

      await File(path).writeAsBytes(bytes); // Запись данных в файл Бд
    }

    return await openDatabase(path); // Открываем бд
  }

  Future<List<Map<String, dynamic>>> getTranslation(String sourceText, bool isRussToMansi) async {
    final db = await database; // Получение экземпляра бд
    final String columnToFind = isRussToMansi ? 'russian' : 'mansian'; // Определение столбца для поиска
    final String resultColumn = isRussToMansi ? 'mansian' : 'russian'; // Определение столбца для результата

    return await db.query(
      'tableOne', // Указываем имя таблицы
      columns: [resultColumn], // Указываем столбец, который хотим получить
      where: '$columnToFind = ?', // Условие поискаа
      whereArgs: [sourceText], // Аргумент для условия поиска
    );
  }
}
