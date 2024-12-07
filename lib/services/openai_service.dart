import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OpenAIService {
  final String apiKey = dotenv.env['OPENAI_API_KEY'] ?? ''; // 환경 변수에서 API 키 읽기

  OpenAIService();

  Future<String> sendMessage(String recipeName, String missingIngredient, List<String> excludedIngredients) async {
    if (apiKey.isEmpty) {
      throw Exception('API 키가 설정되지 않았습니다.');
    }

    final url = Uri.parse("https://api.openai.com/v1/chat/completions");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: json.encode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "system", "content": "당신은 레시피의 대체 재료에 대해 도움을 주는 한국어 비서입니다. 오직 재료 이름만 한국어 단답형으로 제공하세요."},
          {"role": "user", "content": "$recipeName을 만들고 있는데 $missingIngredient를 대체할 재료를 추천해주세요. 재료 이름만 설명없이 단답으로 제공하세요. 특수문자를 포함하지 마세요. 대체 재료는 ${excludedIngredients.join(', ')}을 절대 포함하면 안 됩니다."},
        ],
      }),
    );

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes); // UTF-8 디코딩
      final data = json.decode(decodedBody);

      // 추가 확인: 반환된 데이터를 로그로 출력
      print("GPT 응답 데이터: $data");

      // 추출된 답변 텍스트 반환
      return data['choices'][0]['message']['content'].toString().trim();
    } else {
      throw Exception('GPT 응답 실패: ${response.body}');
    }
  }
}
