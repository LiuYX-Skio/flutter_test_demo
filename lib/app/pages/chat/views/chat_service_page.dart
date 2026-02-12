import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../navigation/core/navigator_service.dart';
import '../../../../navigation/core/route_paths.dart';
import '../models/chat_models.dart';
import '../viewmodels/chat_viewmodel.dart';

class ChatServicePage extends StatefulWidget {
  const ChatServicePage({super.key});

  @override
  State<ChatServicePage> createState() => _ChatServicePageState();
}

class _ChatServicePageState extends State<ChatServicePage> {
  final TextEditingController _contentController = TextEditingController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  int _lastMessageSize = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final ChatViewModel viewModel =
          Provider.of<ChatViewModel>(context, listen: false);
      await viewModel.initialize();
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    _refreshController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<ChatViewModel>().hideAlbumPanel(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<ChatViewModel>(
          builder: (BuildContext context, ChatViewModel viewModel, _) {
            _checkAndScroll(viewModel.messages.length);
            return SafeArea(
              bottom: false,
              child: Column(
                children: [
                  _buildTopBar(),
                  Expanded(
                    child: Container(
                      color: const Color(0xFFEDEDED),
                      child: Listener(
                        behavior: HitTestBehavior.opaque,
                        onPointerDown: (_) => viewModel.hideAlbumPanel(),
                        child: SmartRefresher(
                          controller: _refreshController,
                          enablePullDown: true,
                          enablePullUp: false,
                          onRefresh: () => _onRefresh(viewModel),
                          header: const ClassicHeader(),
                          child: ListView.separated(
                            controller: _scrollController,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            itemCount: viewModel.messages.length,
                            separatorBuilder: (_, __) => SizedBox(height: 12.h),
                            itemBuilder: (BuildContext context, int index) {
                              final ChatMessageEntity message =
                                  viewModel.messages[index];
                              return _buildMessageItem(message);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  _buildBottom(viewModel),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 60.h,
      margin: EdgeInsets.only(top: 10.h),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(left: 5.w),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => NavigatorService.instance.pop(),
                child: Padding(
                  padding: EdgeInsets.all(10.w),
                  child: Image.asset(
                    'assets/images/icon_back.webp',
                    width: 12.w,
                    height: 18.h,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              '在线客服【唯一客服工作日9:00-18:00】',
              style: TextStyle(
                fontSize: 16.sp,
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottom(ChatViewModel viewModel) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(height: 1.h, color: const Color(0xFFDEDEDE)),
          SizedBox(
            height: 60.h,
            child: Row(
              children: [
                GestureDetector(
                  onTap: viewModel.toggleAlbumPanel,
                  child: Container(
                    width: 30.w,
                    height: 30.w,
                    margin: EdgeInsets.only(left: 12.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF707070), width: 1.w),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 18.sp,
                      color: const Color(0xFF707070),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: TextField(
                      controller: _contentController,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: '请输入聊天信息',
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF999999),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                GestureDetector(
                  onTap: viewModel.isSending ? null : () => _onSend(viewModel),
                  child: Container(
                    width: 70.w,
                    height: 40.h,
                    margin: EdgeInsets.only(right: 20.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF59A7B9),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '发送',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (viewModel.showAlbumPanel)
            GestureDetector(
              onTap: _pickImageAndSend,
              child: Container(
                margin: EdgeInsets.only(left: 12.w, top: 10.h, bottom: 15.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 50.w,
                      height: 50.w,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.photo_library_outlined,
                        size: 26.sp,
                        color: const Color(0xFF707070),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      '相册',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(ChatMessageEntity message) {
    final bool isLeft = message.viewType == ChatViewTypes.leftText ||
        message.viewType == ChatViewTypes.leftImage;
    final bool isImage = message.viewType == ChatViewTypes.leftImage ||
        message.viewType == ChatViewTypes.rightImage;

    final Widget bubble = isImage
        ? _buildImageBubble(message, isLeft: isLeft)
        : Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 13.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7EA),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              message.content ?? '',
              style: TextStyle(fontSize: 14.sp, color: const Color(0xFF333128)),
            ),
          );

    final Widget avatar = Image.asset(
      'assets/images/icon_default.png',
      width: 42.w,
      height: 42.w,
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        mainAxisAlignment:
            isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: isLeft
            ? [
                avatar,
                SizedBox(width: 10.w),
                Flexible(child: bubble),
                SizedBox(width: 30.w),
              ]
            : [
                SizedBox(width: 30.w),
                Flexible(child: bubble),
                SizedBox(width: 10.w),
                avatar,
              ],
      ),
    );
  }

  Widget _buildImageBubble(ChatMessageEntity message, {required bool isLeft}) {
    final String? imageUrl = message.resolvedImageUrl();
    return GestureDetector(
      onTap: () {
        if ((imageUrl ?? '').isEmpty) {
          return;
        }
        context.nav.push(
          RoutePaths.product.bigPhoto,
          arguments: <String, dynamic>{'photo': imageUrl},
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 13.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF7EA),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: isLeft ? 0 : 100.w,
              minHeight: isLeft ? 0 : 100.w,
              maxWidth: 180.w,
              maxHeight: 180.w,
            ),
            child: (imageUrl ?? '').isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => _buildImagePlaceholder(),
                    errorWidget: (_, __, ___) => _buildImagePlaceholder(),
                  )
                : _buildImagePlaceholder(),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: 100.w,
      height: 100.w,
      color: const Color(0xFFEAEAEA),
      alignment: Alignment.center,
      child: Icon(
        Icons.broken_image_outlined,
        size: 30.sp,
        color: const Color(0xFF999999),
      ),
    );
  }

  Future<void> _pickImageAndSend() async {
    final XFile? imageFile = await _picker.pickImage(source: ImageSource.gallery);
    if (imageFile == null) {
      return;
    }
    if (!mounted) {
      return;
    }
    final ChatViewModel viewModel = context.read<ChatViewModel>();
    await viewModel.sendImageMessage(File(imageFile.path));
    viewModel.hideAlbumPanel();
    _scrollToBottom();
  }

  Future<void> _onRefresh(ChatViewModel viewModel) async {
    await viewModel.refreshOlderMessages();
    _refreshController.refreshCompleted();
  }

  Future<void> _onSend(ChatViewModel viewModel) async {
    await viewModel.sendTextMessage(_contentController.text);
    _contentController.clear();
    _scrollToBottom();
  }

  void _checkAndScroll(int currentSize) {
    if (currentSize <= _lastMessageSize) {
      return;
    }
    _lastMessageSize = currentSize;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) {
      return;
    }
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 80.h,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }
}
