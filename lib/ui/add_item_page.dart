import 'package:berikan/widget/custom_textfield.dart';
import 'package:flutter/material.dart';

class AddItemPage extends StatelessWidget {
  static const routeName = '/addItemPage';

  const AddItemPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Barang'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nama Barang'),
            const CustomTextField('Seperti: Sepatu Adidas KW', type: TextInputType.text, isObscure: false,),
            SizedBox(
              height: 16,
            ),
            Text('Deskripsi Barang'),
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                border: const OutlineInputBorder(),
                hintText: 'Deskripsikan barangmu',
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text('Tambahkan Foto (Max 5)'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1/1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.add_a_photo),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1/1,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.add_a_photo),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1/1,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.add_a_photo),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1/1,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.add_a_photo),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1/1,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.add_a_photo),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
