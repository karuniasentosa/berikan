import 'dart:math';

String randomString(Random random, {required int length})
{
  if (length <= 0) return '';
  const chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

  String result = "";
  while (length-- > 0) {
    int index = random.nextInt(chars.length);
    result += chars[index];
  }

  return result;
}