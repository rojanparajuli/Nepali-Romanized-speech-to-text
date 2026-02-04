import 'package:injectable/injectable.dart';

@lazySingleton


class NepaliRomanizer {
  static final Map<String, String> _charMap = {
    'क': 'k',
    'ख': 'kh',
    'ग': 'g',
    'घ': 'gh',
    'च': 'ch',
    'छ': 'chh',
    'ज': 'j',
    'झ': 'jh',
    'ट': 't',
    'ठ': 'th',
    'ड': 'd',
    'ढ': 'dh',
    'त': 't',
    'थ': 'th',
    'द': 'd',
    'ध': 'dh',
    'न': 'n',
    'प': 'p',
    'फ': 'ph',
    'ब': 'b',
    'भ': 'bh',
    'म': 'm',
    'य': 'y',
    'र': 'r',
    'ल': 'l',
    'व': 'v',
    'श': 'sh',
    'ष': 'sh',
    'स': 's',
    'ह': 'h',
    'अ': 'a',
    'आ': 'aa',
    'इ': 'i',
    'ई': 'ee',
    'उ': 'u',
    'ऊ': 'oo',
    'ए': 'e',
    'ऐ': 'ai',
    'ओ': 'o',
    'औ': 'au',
    'ा': 'aa',
    'ि': 'i',
    'ी': 'ee',
    'ु': 'u',
    'ू': 'oo',
    'े': 'e',
    'ै': 'ai',
    'ो': 'o',
    'ौ': 'au',
    'ं': 'n',
    'ः': 'h',
    '्': '',
    ' ': ' ',
    '.': '.',
    ',': ',',
    '?': '?',
  };

  static String romanize(String nepaliText) {
    if (nepaliText.isEmpty) return '';

    StringBuffer romanized = StringBuffer();
    for (int i = 0; i < nepaliText.length; i++) {
      final char = nepaliText[i];
      romanized.write(_charMap[char] ?? char);
    }

    return romanized.toString().trim();
  }
}
