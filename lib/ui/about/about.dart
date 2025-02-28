import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final versionNotifier = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    versionNotifier.value = packageInfo.version;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Center(
                child: SelectableText(
                  'Mongol Converter',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              Center(
                child: ValueListenableBuilder<String>(
                  valueListenable: versionNotifier,
                  builder: (context, version, child) {
                    return Text(version);
                  },
                ),
              ),
              const SizedBox(height: 32),
              SelectableText(
                'Тодорхойлолт',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SelectableText(
                'Энэхүү программ нь кирилл монгол бичгийг уламжлалт монгол '
                'бичиг рүү хөрвүүлдэг. Одоогоор бид энэ хэрэгслийг дэмжихэд '
                'шаардлагатай нээлттэй эхийн мэдээллийн санг бүрдүүлж байна. '
                'Өгөгдлийн санг бүрдүүлж байх үед та хөрвүүлэх боломжгүй олон '
                'тооны үгсийг олж болно.',
                // 'If you are an expert in both Cyrillic and traditional Mongolian and '
                // 'would like to help, contact us at studymongolian@gmail.com.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              SelectableText(
                'Энэ програмын код болон түүний үүсгэсэн өгөгдлийн багц нь '
                'үнэгүй бөгөөд нээлттэй эх сурвалж юм. Та тэдгээрийг '
                'хүссэнээрээ ашиглаж болно.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              SelectableText(
                'Нууцлал',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SelectableText(
                'Кирилл үсгийг монгол руу хөрвүүлэх нь таны хөтөч дээр шууд '
                'хийгддэг. Таны баримтыг серверт байршуулаагүй байна. Таны IP '
                'хаяг бичигдсэн боловч нэвтэрч ороогүй л бол хувийн мэдээллийг '
                'тань хадгалахгүй. Хэрэв та засварлагчаар нэвтэрсэн бол бид '
                'таны хэрэглэгчийн нэр, имэйлийн хамт таны нэмсэн эсвэл '
                'шинэчлэгдсэн үгсийг бүртгэдэг.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
