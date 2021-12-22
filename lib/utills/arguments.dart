import 'package:berikan/api/model/item.dart';

class Arguments {
  final String name;
  final String imageUrl;

  Arguments(this.name, this.imageUrl);
}

class SignupArguments {
  final String? id;
  SignupArguments(this.id);
}


class DetailArguments {
  final Item itemDetail;
  final dynamic location;

  DetailArguments(this.itemDetail, this.location);
}