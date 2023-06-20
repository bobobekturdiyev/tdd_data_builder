
# Data Builder for TDD Clean Code Architecture





We always generate dto and service files while using TDD architecture.
This package aids you to generate this files


## Usage/Examples
This package uses retrofit and dio for api usage.

### Create DTO file
```
flutter pub run data_builder dto <DTO-NAME>
```
Replace <DTO-NAME> to the name of your DTO.

You may create entity for your DTO by adding --entity
```
flutter pub run data_builder dto <DTO-NAME> --entity
```

### Create Service file
```
flutter pub run data_builder service <SERVICE-NAME>
```
Replace <SERVICE-NAME> to the name of your service.


### Create DataResponse class file

Many back-end services returns response inside data property of their JSON file as follow:

```
{
    "data" : {
        ...
    }
}
```
We created a special DataResponse class to extract the data from the this JSON. It means you don't need to create class which holds data property every time. Run this code:

```
flutter pub run data_builder data-response
```

It generates the file in the following path:
```lib/data/dto/default/default_response.dart```

If there is a need to add a new route from api which contains data, you just register your dto class inside data-response. That's it.

```
part 'data_response.g.dart';

@JsonSerializable()
class DataResponse<T> {
  @JsonKey(name: "data")
  @_Converter()
  final List<T> data;

  const DataResponse({
    required this.data,
  });

  factory DataResponse.fromJson(Map<String, dynamic> json) =>
      _\$DataResponseFromJson<T>(json);

  Map<String, dynamic> toJson() => _\$DataResponseToJson(this);
}

class _Converter<T> implements JsonConverter<T, Object?> {
  const _Converter();

  @override
  T fromJson(Object? json) {
    if (json is Map<String, dynamic>) {
      switch (T) {
        //case SampleDto:
          //return SampleDto.fromJson(json) as T;
      }
      return DefaultResponse<T>.fromJson(json) as T;
    }
    return json as T;
  }

  @override
  Object? toJson(T object) => object;
}

```

Here commented SampleDTO is your DTO which comes as a value of data property in JSON.

## ⚠ MUST do everytime

When you create a dto or service file, it just generate the template. You fill your class with necessary attributes and methods as your needs. After all, you must run build_runner package to generate the part files.

```
flutter pub run build_runner build
```


## 🔗 Links
[![portfolio](https://img.shields.io/badge/Instagram-E4405F?style=for-the-badge&logo=instagram&logoColor=white)](https://instagram.com/bobobek_com)
[![linkedin](https://img.shields.io/badge/linkedin-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/bobobek-t-870a9112a/)
[![twitter](https://img.shields.io/badge/twitter-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white)](https://twitter.com/BobobekTurdiyev)
