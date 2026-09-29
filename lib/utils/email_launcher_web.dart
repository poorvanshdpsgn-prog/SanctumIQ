import 'package:web/web.dart' as web;

void openEmailDraft(String uri) {
  web.window.open(uri, '_blank');
}
