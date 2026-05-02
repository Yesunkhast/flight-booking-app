import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_radius.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flutter/material.dart';

class WarningNotice extends StatelessWidget {
  const WarningNotice({
    super.key,
    this.notices,
  });

  final List<String>? notices;

  static const List<String> _defaultNotices = [
    'Зорчигч паспортын мэдээллээс өөрөө буруу оруулах болон онгоцноос хоцрох тохиодолд гарах эрсдэлийг зорчигч өөрөө хариуцна.',
    'Хэрвээ та дамжин нислэгтэй бол дамжих дэлгэрэнгүй мэдээллийг 96961414, 90901550 лавлаж тодруулах.',
    'Зорчигч нислэг эхлэхээс 3 цагийн өмнө нисэх буудалд ирж зорчигчийн билет ба тээшийн бүртгэл болон паспортын шалгалтанд орох',
    'Нислэгийн цагийн хуваарийн өөрчлөлтийн мэдээллийг тухай бүр таны манай системд бүртгүүлсэн гар утасны дугаараар болон и мэйл хаягаар илгээгдэж байгааг анхаарна уу!',
    'Эйрлайн буюу нислэг үйлдэж буй авиа компани нь Цаг агаар болон бусад давагдашгүй хүчин зүйлийн улмаас нислэгийг цуцлах/хойшлуулах эрхтэй байдаг. Хэрэв ийм нөхцөл үүссэн тохиолдолд цаашид гарах үр дагаварыг ECHINA.MN нь хариуцлага хүлээхгүйг анхаарна уу.',
  ];

  @override
  Widget build(BuildContext context) {
    final items = notices ?? _defaultNotices;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Title ───────────────────────────────────────────────────
        Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFF9A825),
              size: 30,
            ),
            SizedBox(width: spacingUnit(1)),
            Text(
              'АНХААРУУЛАХ САНАМЖ',
              style: ThemeText.paragraph.copyWith(
                color: const Color(0xFFF9A825),
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),

        SizedBox(height: spacingUnit(2)),
        Divider(color: colorScheme(context).outlineVariant, height: 1),
        SizedBox(height: spacingUnit(2)),

        // ── Notice items ─────────────────────────────────────────────
        ...items.map(
          (notice) => Padding(
            padding: EdgeInsets.only(bottom: spacingUnit(2)),
            child: Text(
              notice,
              style: ThemeText.paragraph.copyWith(
                color: colorScheme(context).onSurface,
                height: 1.6,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
