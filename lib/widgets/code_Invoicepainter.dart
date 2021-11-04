// @dart=2.9
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

class CodeInvoicePainter extends CustomPainter {
  // ********************************* VARS ******************************** //

  final double margin;
  final ui.Image qrImage;
  Paint _paint;

  // ***************************** CONSTRUCTORS **************************** //

  CodeInvoicePainter({@required this.qrImage, this.margin = 10}) {
    _paint = Paint()
      ..color = Colors.white
      ..style = ui.PaintingStyle.fill;
  }

  //***************************** PUBLIC METHODS *************************** //

  @override
  void paint(Canvas canvas, Size size) {
    // Draw everything in white.
    final rect = Rect.fromPoints(Offset.zero, Offset(size.width, size.height));
    canvas.drawRect(rect, _paint);

    // Draw the image in the center.
    canvas.drawImage(qrImage, Offset(margin, margin), Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  ui.Picture toPicture(Size size) {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    paint(canvas, size);
    return recorder.endRecording();
  }

  Future<ui.Image> toImage(Size size,
      {ui.ImageByteFormat format = ui.ImageByteFormat.png}) async {
    return await toPicture(size).toImage(size.width.toInt() + margin.toInt() *2,size.height.toInt() + margin.toInt()*2);
  }

  Future<ByteData> toImageData(Size size,
      {ui.ImageByteFormat format = ui.ImageByteFormat.png}) async {

    final image = await toImage(size , format: format);
    return image.toByteData(format: format);
  }
}
