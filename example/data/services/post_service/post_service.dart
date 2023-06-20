import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../../dto/post/post.dart';

part 'post_service.g.dart';

@RestApi(baseUrl: Urls.baseURl)
abstract class PostService {
  factory PostService(Dio dio, {String baseUrl}) = _PostService;

  @GET("posts/{postId}")
  Future<HttpResponse<PostDto>> getPostById({
    @Path() required int postId,
  });
}
