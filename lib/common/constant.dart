const lorem =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed molestie velit et augue laoreet, blandit semper dui ornare. Etiam eu egestas sapien.';

final List<Map> myProducts = List.generate(
    100,
    (index) => {
          "id": index,
          "name": "Product $index",
        }).toList();

final List<Map<String, dynamic>> dummyChat2 = [
  {
    'sender': 'Me',
    'message': 'Halo, apakah barang ini masih ada ya?'
  },
  {
    'sender': 'John',
    'message': 'Masih ada, silahkan langsung ambil kesini ya!'
  },
  {
    'sender': 'Me',
    'message': 'Oke, aku otw sekarang'
  },
  {
    'sender': 'John',
    'message': 'Oke, ditunggu di depan.'
  },

];
