import 'dart:io';

void main(List<String> arguments) {
  if (arguments.length < 2) {
    print(
        'Please provide the type (dto or service) and the name as arguments.');
    return;
  }

  final type = arguments[0];
  final name = arguments[1];
  final arg3 = arguments[2];
  final folderName = name.toLowerCase();

  final folder = Directory('lib/data/$folderName');

  if (!folder.existsSync()) {
    folder.createSync();
  }

  switch (type) {
    case 'dto':
      final file = File('lib/data/dto/$folderName/$folderName.dart');
      file.writeAsStringSync(getDtoContent(name, folderName));

      if (arg3 == '--entity') {
        final entityFile =
            File('lib/domains/entities/$folderName/$folderName.dart');
        entityFile.writeAsStringSync(getEntityContent(name));
      }
      break;
    case 'service':
      final file =
          File('lib/data/services/$folderName/${folderName}_$type.dart');
      file.writeAsStringSync(getServiceContent(name));

      if (arg3 == '--data-response') {
        final responseFile = File('lib/data/dto/default/default_response.dart');

        if (!responseFile.existsSync()) {
          responseFile.writeAsStringSync(getDataResponseContent());
        } else {
          print('default_response.dart file already exists\n');
        }
      }
      break;

    case 'data-response':
      final responseFile = File('lib/data/dto/default/default_response.dart');

      if (!responseFile.existsSync()) {
        responseFile.writeAsStringSync(getDataResponseContent());
      } else {
        print('default_response.dart file already exists\n');
      }
      break;
    default:
      print('Invalid type. Supported types: dto, service');
      return;
  }

  print('$type generated successfully!');
}

String getDtoContent(String dtoName, String folderName) {
  return '''
import 'package:json_annotation/json_annotation.dart';

part '$folderName.g.dart';

@JsonSerializable()
class ${dtoName}Dto {
  // TODO: Add your DTO properties here

  ${dtoName}Dto();

  factory ${dtoName}Dto.fromJson(Map<String, dynamic> json) =>
      _\$${dtoName}DtoFromJson(json);

  Map<String, dynamic> toJson() => _\$${dtoName}DtoToJson(this);
}
''';
}

String getEntityContent(String entityName) {
  return '''
class $entityName {
  const $entityName();
}
''';
}

String getServiceContent(String serviceName) {
  return '''
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part '${serviceName}_service.g.dart';

// Change baseUrl here
@RestApi(baseUrl: Urls.baseURl)
abstract class ${serviceName}Service {
  factory ${serviceName}Service(Dio dio, {String baseUrl}) = _${serviceName}Service;

  //@GET("WRITE_THE_URL")
  //Future<HttpResponse<List<AdDto>>> getBannerAds();
}
''';
}

String getDataResponseContent() {
  return '''
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

  ''';
}
