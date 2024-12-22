import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/models/rss_model.dart';
import 'package:rent_house/ui/webview/webview_screen.dart';
import 'package:rent_house/utils/format_util.dart';
import 'package:rent_house/widgets/images/common_network_image.dart';

class RssItem extends StatelessWidget {
  const RssItem({super.key, required this.item});

  final RssModel item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => WebViewScreen(url: item.link ?? ''));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${item.title}', style: ConstantFont.mediumText),
                  const SizedBox(height: 6),
                  Text(
                    '${item.description}',
                    style: ConstantFont.regularText.copyWith(fontSize: 12),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      FormatUtil.formatVietnameseDate(item.pubDate ?? ''),
                      style: ConstantFont.lightText.copyWith(
                        fontSize: 10,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            CommonNetworkImage(
              imageUrl: item.imageUrl,
              height: 100,
              width: 100,
              placeholderAsset: AssetSvg.imgNotAvailable,
            ),
          ],
        ),
      ),
    );
  }
}
