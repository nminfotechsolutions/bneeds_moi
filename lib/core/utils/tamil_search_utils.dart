// lib/core/utils/tamil_search_utils.dart

/// Utility class for bilingual Tamil-English search functionality
class TamilSearchUtils {
  // Tamil vowels and consonants transliteration map
  static const Map<String, String> _tamilToEnglish = {
    // Vowels
    'அ': 'a',
    'ஆ': 'aa',
    'இ': 'i',
    'ஈ': 'ee',
    'உ': 'u',
    'ஊ': 'oo',
    'எ': 'e',
    'ஏ': 'e',
    'ஐ': 'ai',
    'ஒ': 'o',
    'ஓ': 'o',
    'ஔ': 'au',
    
    // Consonants
    'க': 'ka',
    'ங': 'nga',
    'ச': 'cha',
    'ஞ': 'nya',
    'ட': 'ta',
    'ண': 'na',
    'த': 'tha',
    'ந': 'na',
    'ப': 'pa',
    'ம': 'ma',
    'ய': 'ya',
    'ர': 'ra',
    'ல': 'la',
    'வ': 'va',
    'ழ': 'zha',
    'ள': 'la',
    'ற': 'ra',
    'ன': 'na',
    
    // Common combinations
    'கா': 'ka',
    'கி': 'ki',
    'கீ': 'kee',
    'கு': 'ku',
    'கூ': 'koo',
    'கெ': 'ke',
    'கே': 'ke',
    'கை': 'kai',
    'கொ': 'ko',
    'கோ': 'ko',
    
    'சா': 'sa',
    'சி': 'si',
    'சீ': 'see',
    'சு': 'su',
    'சூ': 'soo',
    'செ': 'se',
    'சே': 'se',
    'சை': 'sai',
    'சொ': 'so',
    'சோ': 'so',
    
    'தா': 'tha',
    'தி': 'thi',
    'தீ': 'thee',
    'து': 'thu',
    'தூ': 'thoo',
    'தெ': 'the',
    'தே': 'the',
    'தை': 'thai',
    'தொ': 'tho',
    'தோ': 'tho',
    
    'ரா': 'ra',
    'ரி': 'ri',
    'ரீ': 'ree',
    'ரு': 'ru',
    'ரூ': 'roo',
    'ரெ': 're',
    'ரே': 're',
    'ரை': 'rai',
    'ரொ': 'ro',
    'ரோ': 'ro',
    
    'ஜ': 'ja',
    'ஜா': 'ja',
    'ஜி': 'ji',
    'ஜீ': 'jee',
    
    'மா': 'ma',
    'மி': 'mi',
    'மீ': 'mee',
    'மு': 'mu',
    'மூ': 'moo',
    'மெ': 'me',
    'மே': 'me',
    'மை': 'mai',
    'மொ': 'mo',
    'மோ': 'mo',
    
    'னி': 'ni',
    'னீ': 'nee',
    'னா': 'na',
    'ணா': 'na',
    'நா': 'na',
    
    'பா': 'pa',
    'பி': 'pi',
    'பீ': 'pee',
    'பு': 'pu',
    'பூ': 'poo',
    'பெ': 'pe',
    'பே': 'pe',
    'பை': 'pai',
    'பொ': 'po',
    'போ': 'po',
    
    'வா': 'va',
    'வி': 'vi',
    'வீ': 'vee',
    'வு': 'vu',
    'வூ': 'voo',
    'வெ': 've',
    'வே': 've',
    'வை': 'vai',
    'வொ': 'vo',
    'வோ': 'vo',
    
    'ஷ': 'sha',
    'ஷா': 'sha',
    'ஷி': 'shi',
    'ஷீ': 'shee',
  };

  /// Converts Tamil text to phonetic English representation
  /// This helps match Tamil text with English search queries
  static String tamilToPhonetic(String tamil) {
    if (tamil.isEmpty) return '';
    
    String result = tamil.toLowerCase();
    
    // Sort by length (longer first) to match compound characters before single ones
    List<MapEntry<String, String>> sortedEntries = _tamilToEnglish.entries.toList()
      ..sort((a, b) => b.key.length.compareTo(a.key.length));
    
    for (var entry in sortedEntries) {
      result = result.replaceAll(entry.key, entry.value);
    }
    
    return result;
  }

  /// Checks if a search query matches Tamil text using bilingual matching
  /// Supports both Tamil and English search queries
  static bool matchesBilingual(String searchQuery, String tamilText) {
    if (searchQuery.isEmpty || tamilText.isEmpty) return false;
    
    String query = searchQuery.toLowerCase().trim();
    String text = tamilText.toLowerCase().trim();
    
    // Strategy 1: Direct substring match (works for both Tamil and English)
    if (text.contains(query)) {
      return true;
    }
    
    // Strategy 2: Convert Tamil text to phonetic English and match
    String phoneticText = tamilToPhonetic(text);
    if (phoneticText.contains(query)) {
      return true;
    }
    
    // Strategy 3: Check if query phonetically matches any part of the Tamil text
    // Break the text into words and check each word
    List<String> words = text.split(' ');
    for (String word in words) {
      String phoneticWord = tamilToPhonetic(word);
      if (phoneticWord.contains(query) || phoneticWord.startsWith(query)) {
        return true;
      }
    }
    
    return false;
  }

  /// Searches through multiple fields of a member/collection object
  /// Returns true if any field matches the search query
  static bool searchInFields(String query, List<String> fields) {
    if (query.isEmpty) return true;
    
    for (String field in fields) {
      if (matchesBilingual(query, field)) {
        return true;
      }
    }
    
    return false;
  }
}
