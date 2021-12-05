const lorem =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed molestie velit et augue laoreet, blandit semper dui ornare. Etiam eu egestas sapien.';

final List<Map> myProducts =
List.generate(100, (index) => {"id": index, "name": "Product $index", })
    .toList();