import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/models/error_input_model.dart';
import 'package:rent_house/constants/app_colors.dart';

class TextInputWidget extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final double? borderRadius;
  final List<TextInputFormatter>? formatter;
  final int? maxLength;
  final int? maxLines;
  final bool enable;
  final Color? backgroundColor;
  final Color? fillColor;
  final TextInputType keyboardType;
  final Rx<ErrorInputModel>? errorInput;
  final bool isNotBorder;
  final Color colorBorder;
  final bool isPassword;
  final bool postfixIconPath;
  final String? prefixIconPath;
  final bool password;
  final String? label;
  final Function()? onTap;
  final Function()? togglePassword;
  final bool? autoFocus;
  final bool isSearch;
  final bool isDisableBackGround;
  final FontWeight fontWeight;
  final double? height;
  final bool sendOTP;
  final bool isSendOTP;
  final String? timeCountdown;
  final bool isCalendar;
  final bool turnOffClearText;
  final Function(String?)? onFieldSubmitted;
  final void Function()? onSendOTP;
  final void Function()? onTimePicker;

  const TextInputWidget({
    super.key,
    this.controller,
    this.onChanged,
    this.enable = true,
    this.hintText,
    this.backgroundColor,
    this.maxLength,
    this.maxLines,
    this.errorInput,
    this.isNotBorder = false,
    this.colorBorder = const Color(0xFF9C9C9C),
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.password = false,
    this.formatter,
    this.fillColor,
    this.borderRadius = 10,
    this.onTap,
    this.postfixIconPath = false,
    this.label,
    this.prefixIconPath,
    this.togglePassword,
    this.autoFocus,
    this.isSearch = false,
    this.isDisableBackGround = false,
    this.fontWeight = FontWeight.w400,
    this.onFieldSubmitted,
    this.sendOTP = false,
    this.isSendOTP = false,
    this.onSendOTP,
    this.height = 56, this.timeCountdown, this.isCalendar = false, this.onTimePicker, this.turnOffClearText = false
  });

  @override
  State<TextInputWidget> createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  late FocusNode _focusNode;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _textEditingController = widget.controller ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder<ErrorInputModel?>(
          stream: widget.errorInput?.stream,
          builder: (context, snapshot) {
            return Theme(
              data: Theme.of(context).copyWith(splashColor: Colors.transparent),
              child: Container(
                height: widget.height,
                padding: widget.isSearch == true
                    ? const EdgeInsets.only(left: 10, right: 5)
                    : EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: widget.backgroundColor ?? AppColors.white,
                  borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius ?? 0)),
                  border: widget.isNotBorder ? null : Border.all(width: 1, color: widget.colorBorder),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: GestureDetector(
                    onTap: () {
                      widget.onTap?.call();
                      FocusScope.of(context).requestFocus(_focusNode);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Row(
                        children: [
                          widget.isSearch
                              ? SvgPicture.asset(AssetSvg.iconSearch)
                              : const SizedBox(),
                          widget.prefixIconPath?.isNotEmpty == true
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: SvgPicture.asset(widget.prefixIconPath!, width: 24),
                                )
                              : const SizedBox(),
                          Expanded(
                            child: TextFormField(
                              onFieldSubmitted: (value) {
                                widget.onFieldSubmitted?.call(value);
                              },
                              onEditingComplete: () {
                                setState(() {
                                  FocusScope.of(context).unfocus();
                                });
                              },

                              autofocus: widget.autoFocus ?? false,
                              controller: widget.controller,
                              onChanged: _onChanged,
                              enabled: widget.enable,
                              maxLength: widget.maxLength,
                              keyboardType: widget.keyboardType,
                              obscureText: widget.password,
                              decoration: InputDecoration(
                                isDense: true,
                                counterText: "",
                                fillColor: Colors.transparent,
                                hintText: widget.hintText,
                                filled: true,
                                hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: ConstantFont.fontLexendDeca,
                                    fontWeight: FontWeight.w400),
                                contentPadding:  EdgeInsets.fromLTRB(10, widget.maxLines != null ? 6 : 0, 10, widget.maxLines != null ? 6 : 0),
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                              ),
                              maxLines: widget.maxLines ?? 1,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: ConstantFont.fontLexendDeca,
                                  color: widget.enable ? AppColors.black : const Color(0xFF1B1A19),
                                  fontWeight: widget.fontWeight),
                            ),
                          ),
                          if (widget.controller != null && widget.controller!.text.isNotEmpty && widget.turnOffClearText == false) ...[
                            InkWell(
                              onTap: () {
                                if (widget.controller == null) {
                                  _textEditingController.clear();
                                } else {
                                  widget.controller?.clear();
                                }
                                if (widget.onChanged != null) {
                                  widget.onChanged?.call("");
                                }
                                setState(() {});
                              },
                              child: SizedBox(child: SvgPicture.asset('assets/icons/ic_close.svg')),
                            ),
                          ],
                          if (widget.isPassword) ...[
                            InkWell(
                              onTap: () {
                                widget.togglePassword!.call();
                              },
                              child: SvgPicture.asset(
                                widget.password == true
                                    ? 'assets/icons/ic_eye_off.svg'
                                    : 'assets/icons/ic_eye.svg',
                              ),
                            ),
                          ],
                          if (widget.postfixIconPath) ...[
                            SvgPicture.asset(
                              'assets/icons/select_down_icon.svg',
                            ),
                          ],
                          if (widget.isCalendar) ...[
                            InkWell(
                              onTap: () {
                                widget.onTimePicker?.call();
                              },
                              child: SvgPicture.asset(
                                AssetSvg.iconCalendar,
                                width: 24,
                              ),
                            ),
                          ],
                          if (widget.sendOTP) ...[
                            GestureDetector(
                              onTap: widget.onSendOTP,
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Text(
                                  widget.isSendOTP ? '${widget.timeCountdown}' : 'Nhận mã',
                                  style: ConstantFont.mediumText
                                      .copyWith(color: AppColors.black, fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          ]
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        widget.errorInput != null && widget.errorInput?.value.isError == true
            ? Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text(
                  widget.errorInput?.value.message ?? "",
                  style: TextStyle(
                    fontFamily: ConstantFont.fontLexendDeca,
                    fontWeight: FontWeight.w400,
                    color: AppColors.red,
                    fontSize: 11,
                  ),
                ),
              )
            : const SizedBox()
      ],
    );
  }

  void _onChanged(String value) {
    widget.onChanged?.call(value);
    setState(() {});
  }
}
