import 'package:flutter_test/flutter_test.dart';

///      TRUE
///       4
///       2
///   1      7
///         5
///        9

///       FALSE
///         12
///         2
///   1     3     5

String ArrayChallenge(List<String> strArr) {
  Map<int, List<int>> tree = {};
  Set<int> children = {};
  Set<int> allNodes = {};
  Map<int, int> parentCount = {};

  for (String pair in strArr) {
    var match = RegExp(r"\((\d+),(\d+)\)").firstMatch(pair);
    if (match == null) continue;

    int child = int.parse(match.group(1)!);
    int parent = int.parse(match.group(2)!);

    tree.putIfAbsent(parent, () => []);
    tree[parent]!.add(child);

    if (tree[parent]!.length > 2) return "false";
    parentCount[child] = (parentCount[child] ?? 0) + 1;
    if (parentCount[child]! > 1) return "false";

    children.add(child);
    allNodes.add(child);
    allNodes.add(parent);
  }

  List<int> potentialRoots = allNodes.where((n) => !children.contains(n)).toList();
  if (potentialRoots.length != 1) return "false";

  return "true";
}

String splitWordIfValid(List<String> inputData, String token) {
  String word = inputData[0];
  Set<String> dictionary = inputData[1].split(',').toSet();
  Set<String> tokenChars = token.split('').toSet();

  for (int i = 1; i < word.length; i++) {
    String leftPart = word.substring(0, i);
    String rightPart = word.substring(i);
    if (dictionary.contains(leftPart) && dictionary.contains(rightPart)) {
      String combined = '$leftPart,$rightPart';
      return highlightTokenChars(combined, tokenChars);
    }
  }

  return 'not possible';
}

String highlightTokenChars(String text, Set<String> tokenChars) {
  return text.split('').map((char) {
    return tokenChars.contains(char) ? '--$char--' : char;
  }).join('');
}

void main() {
  group('splitWordIfValid', () {
    test('baseball split, match token', () {
      final result = splitWordIfValid(["baseball", "base,ball,apple"], "y4vpfxsb12");
      expect(result, equals("--b--a--s--e,--b--all"));
    });

    // --- Test cases for splitWordIfValid ---
    test('applepie split, full match token', () {
      final result = splitWordIfValid(["applepie", "apple,pie"], "ap1p2l3e4");
      // التعديل: النتيجة ستكون بـ `--` حول الحروف التي تطابق التوكن
      expect(result, equals("--a----p----p----l----e--,--p--i--e--"));
    });

    test('wordword with duplicate in dictionary', () {
      final result = splitWordIfValid(["wordword", "word"], "word");
      // التعديل: يجب أن يكون الشكل بـ `--` حول الحروف في التوكن
      expect(result, equals("--w----o----r----d--,--w----o----r----d--"));
    });

    test('basketball split not possible', () {
      final result = splitWordIfValid(["basketball", "base,ball,ket"], "xyz");
      expect(result, equals("not possible"));
    });
  });

  group('ArrayChallenge', () {
    test('Valid binary tree structure', () {
      final result = ArrayChallenge(["(1,2)", "(2,4)", "(5,7)", "(7,2)", "(9,5)"]);
      expect(result, equals("true"));
    });

    test('Invalid - more than 2 children', () {
      final result = ArrayChallenge(["(1,2)", "(2,12)", "(3,2)", "(5,2)"]);
      expect(result, equals("false"));
    });

    test('Simple valid binary tree', () {
      final result = ArrayChallenge(["(1,2)", "(3,2)", "(4,3)", "(5,3)"]);
      expect(result, equals("true"));
    });

    test('Valid - child appears twice but valid structurally', () {
      final result = ArrayChallenge(["(1,2)", "(1,3)"]);
      expect(result, equals("false"));
    });

    test('Invalid - parent with 3 children', () {
      final result = ArrayChallenge(["(1,2)", "(2,3)", "(4,3)", "(5,3)"]);
      expect(result, equals("false"));
    });
  });
}
