import 'package:flutter/material.dart'; // Импорт библи с виджетами
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'database_helper.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());   // Запускаем прогу
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue, // Основная тема
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
      home: TranslatorScr(), // Установка главного экрана приложения
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate, // Делегат глобальной локализации материалов
        GlobalWidgetsLocalizations.delegate, // Делегат глобальной локализации виджетов
      ],
      supportedLocales: [
        Locale('ru', 'RU'), // Поддержка русского языка.
        Locale('en', 'US'), // Поддержка английского языка.
      ],
    );
  }
}

class TranslatorScr extends StatefulWidget {
  @override
  _TranslatorScrState createState() => _TranslatorScrState(); // Создание состояния экранааы
}

class _TranslatorScrState extends State<TranslatorScr> {
  final TextEditingController _controller = TextEditingController(); // Контроллер для поля ввода текста
  String _translatText = ''; // Переменная для хранения переведенного текста
  bool _isRussToMansi = true; // Флаг для определения направления перевода

  void _translate() async {
    final dbHelper = DbHelper(); // иниуиализация помощника для работы с бд
    final sourceText = _controller.text; // получение текста из поля ввода
    final translations = await dbHelper.getTranslation(sourceText, _isRussToMansi); // Запрос перевода из бд

    if (translations.isNotEmpty) {
      setState(() {
        _translatText = translations.first[_isRussToMansi ? 'mansian' : 'russian']; // установка переведенонго текста
      });
    } else {
      setState(() {
        _translatText = 'Перевод не найден'; // cоообщение если не нашло в бд
      });
    }
  }

  void _switchLang() {
    setState(() {
      _isRussToMansi = !_isRussToMansi; // переключение направление перевода
    });
  }

  void _copyTranslText() {
    Clipboard.setData(ClipboardData(text: _translatText)); // Копирование переведенного текста в буфер обмена
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Скопирован')), // Показ уведомления о копировании текста.
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,  // Отключение изменения размера фона при появлении клавиатуры(была ошибка)
      appBar: AppBar(
        title: Text(
          'ПЕРЕВОДЧИК ТОЛМАСЬ', // Заголовок
          style: GoogleFonts.kellySlab( // Стиль заголовка( библиотека гугла)
            textStyle: TextStyle(color: Colors.white, letterSpacing: 1),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[800], // Цвет шапки
        elevation: 5.0, // тень
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),            // Закругленные углы шапки
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'), // Фон
            opacity: 0.0,
            fit: BoxFit.cover, // На веесь экран
          ),
        ),
        padding: const EdgeInsets.all(27.0), // Отступы по краям экрана
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Выравнивание дочерних виджетов по ширине
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Распределение элементов по всей ширине
              children: [
                DropdownButton<String>(
                  value: _isRussToMansi ? 'Русский' : 'Мансийский', // Выпадающий список
                  dropdownColor: Colors.white, // цвет фона выпадающ списка
                  style: TextStyle(color: Colors.black45), // Стиль текста в выпадающем списке
                  items: [
                    DropdownMenuItem(value: 'Русский', child: Text('Русский', style: GoogleFonts.lato(
                      textStyle: TextStyle(color: Colors.black, letterSpacing: 1, fontSize: 18),
                    ))),
                    DropdownMenuItem(value: 'Мансийский', child: Text('Мансийский', style: GoogleFonts.lato(
                      textStyle: TextStyle(color: Colors.black, letterSpacing: 1, fontSize: 18),
                    ))),
                  ],
                  onChanged: (value) {
                    if (value == 'Русский' && !_isRussToMansi) {
                      _switchLang(); // Переключение направления перевода
                    } else if (value == 'Мансийский' && _isRussToMansi) {
                      _switchLang();
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.swap_horiz, color: Colors.black38, size: 30), // Иконка для переключения направления перевода
                  onPressed: _switchLang,
                ),
                DropdownButton<String>(
                  value: _isRussToMansi ? 'Мансийский' : 'Русский', // Значение выпадающего списка.
                  dropdownColor: Colors.white, // Цвет фона выпадающего списка
                  style: TextStyle(color: Colors.black45), // Стиль текста в выпадающем списке.
                  items: [
                    DropdownMenuItem(value: 'Мансийский', child: Text('Мансийский', style: GoogleFonts.lato(
                      textStyle: TextStyle(color: Colors.black, letterSpacing: 1, fontSize: 18),
                    ))),
                    DropdownMenuItem(value: 'Русский', child: Text('Русский', style: GoogleFonts.lato(
                      textStyle: TextStyle(color: Colors.black, letterSpacing: 1, fontSize: 18),
                    ))),
                  ],
                  onChanged: (value) {
                    if (value == 'Мансийский' && !_isRussToMansi) {
                      _switchLang(); // Переключение направления перевода.
                    } else if (value == 'Русский' && _isRussToMansi) {
                      _switchLang(); // Переключение направления перевода.
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 105), // Отступ между элементами.
            Container(
              height: 110,  // Высота блока ввода текста.
              child: TextField(
                controller: _controller, // Контроллер для управления вводом текста.
                maxLines: null, // Неограниченное количество строк.
                onTap: () {
                  setState(() {
                    _controller.text = _controller.text; // Обновление состояния при тапе.
                  });
                },
                decoration: InputDecoration(
                  labelText: _controller.text.isEmpty ? 'Введите текст' : null, // Метка для поля ввода.
                  labelStyle: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w300), // Стиль метки.
                  filled: true, // Заполнение поля цветом.
                  fillColor: Colors.black54, // Цвет фона поля ввода.
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // Закругленные углы рамки.
                    borderSide: BorderSide.none, // Отсутствие рамки.
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // Закругленные углы рамки при фокусе.
                    borderSide: BorderSide(color: Colors.white), // Цвет рамки при фокусе.
                  ),
                ),
                style: TextStyle(color: Colors.white), // Стиль текста ввода.
              ),
            ),
            SizedBox(height: 10), // Отступ между элементами.
            ElevatedButton(
              onPressed: _translate, // Функция перевода при нажатии кнопки.
              child: Text('Перевод', style: GoogleFonts.kellySlab(
                textStyle: TextStyle(color: Colors.white, letterSpacing: .22,fontSize: 18),),),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue[800],
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                textStyle: TextStyle(fontSize: 17,fontWeight: FontWeight.w300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 25),
            Container(
              height: 150,  // Увеличиваем высоту блока вывода перевода
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[800]?.withOpacity(0.6),
                borderRadius: BorderRadius.circular(4.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _translatText,
                      style: GoogleFonts.kellySlab(
                        textStyle: TextStyle(color: Colors.white, letterSpacing: .22,fontSize: 22),)
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.copy, color: Colors.black),
                    alignment: Alignment.topRight,
                    onPressed: _copyTranslText,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
