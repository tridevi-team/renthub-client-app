import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/models/error_input_model.dart';

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
  final Function(String)? onFieldSubmitted;

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
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: widget.backgroundColor ?? Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius ?? 0)),
                  border: widget.isNotBorder ? null : Border.all(width: 1, color: widget.colorBorder),
                ),
                height: widget.maxLines != null ? 200 : 56,
                child: Padding(
                  padding: widget.isSearch == true ? EdgeInsets.only(left: 16, right: widget.isSearch ? 0 : 5) : EdgeInsets.zero,
                  child: Material(
                    color: Colors.transparent,
                    child: GestureDetector(
                      onTap: () {
                        widget.onTap?.call();
                        FocusScope.of(context).requestFocus(_focusNode);
                      },
                      child: Row(
                        children: [
                          widget.isSearch ? SvgPicture.asset("assets/icon/search_icon.svg") : const SizedBox(),
                          widget.prefixIconPath?.isNotEmpty == true ? SvgPicture.asset(widget.prefixIconPath!, width: 24) : const SizedBox(),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 1),
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
                                  counterText: "",
                                  fillColor: Colors.transparent,
                                  hintText: widget.hintText ?? widget.label,
                                  filled: true,
                                  hintStyle: TextStyle(color: Colors.black, fontSize: 14, fontFamily: ConstantFont.fontLexendDeca, fontWeight: FontWeight.w400),
                                  contentPadding: EdgeInsets.fromLTRB(10, widget.maxLines != null ? 10 : 0, 0, 6),
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                ),
                                maxLines: widget.maxLines ?? 1,
                                style: TextStyle(fontSize: 14, fontFamily: ConstantFont.fontLexendDeca, color: widget.enable ? Colors.black : const Color(0xff1B1A19), fontWeight: widget.fontWeight),
                              ),
                            ),
                          ),
                          if (widget.controller != null && widget.controller!.text.isNotEmpty) ...[
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
                                widget.password == true ? 'assets/icons/ic_eye_off.svg' : 'assets/icons/ic_eye.svg',
                              ),
                            ),
                          ],
                          if (widget.postfixIconPath) ...[
                            SvgPicture.asset(
                              'assets/icons/select_down_icon.svg',
                            ),
                          ],
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
                child: Expanded(
                  child: Text(
                    widget.errorInput?.value.message ?? "",
                    style: TextStyle(
                      fontFamily: ConstantFont.fontLexendDeca,
                      fontWeight: FontWeight.w400,
                      color: Colors.red,
                      fontSize: 11,
                    ),
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
