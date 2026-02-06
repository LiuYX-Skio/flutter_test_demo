import 'package:json_annotation/json_annotation.dart';
import '../../../../navigation/utils/app_data_utils.dart';

part 'shop_detail_models.g.dart';

/// 购物车数量实体
/// 对应 Android 的 ShopCarSumEntity
@JsonSerializable()
class ShopCarSumEntity {
  /// 购物车数量
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? count;

  ShopCarSumEntity({
    this.count,
  });

  factory ShopCarSumEntity.fromJson(Map<String, dynamic> json) =>
      _$ShopCarSumEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ShopCarSumEntityToJson(this);
}

/// 商品属性列表实体
/// 对应 Android 的 ShopAttrListEntity
@JsonSerializable()
class ShopAttrListEntity {
  /// 属性名
  final String? attrValue;

  /// 图片
  final String? image;

  /// 是否选中（非服务端字段）
  @JsonKey(defaultValue: false)
  final bool isSelect;

  ShopAttrListEntity({
    this.attrValue,
    this.image,
    this.isSelect = false,
  });

  factory ShopAttrListEntity.fromJson(Map<String, dynamic> json) =>
      _$ShopAttrListEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ShopAttrListEntityToJson(this);
}

/// 商品属性实体
/// 对应 Android 的 ShopAttrEntity
@JsonSerializable()
class ShopAttrEntity {
  /// 属性名
  final String? attrName;

  /// 属性值
  final String? attrValues;

  /// attrId
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? id;

  /// 是否删除，0-否，1-是
  @JsonKey(defaultValue: false)
  final bool isDel;

  /// 商品ID
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? productId;

  /// 活动类型 0=商品，1=秒杀，2=砍价，3=拼团
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? type;

  /// 属性列表
  final List<ShopAttrListEntity>? attrDetailList;

  ShopAttrEntity({
    this.attrName,
    this.attrValues,
    this.id,
    this.isDel = false,
    this.productId,
    this.type,
    this.attrDetailList,
  });

  factory ShopAttrEntity.fromJson(Map<String, dynamic> json) =>
      _$ShopAttrEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ShopAttrEntityToJson(this);
}

/// 商品属性值实体
/// 对应 Android 的 ProduceValueEntity
@JsonSerializable()
class ProduceValueEntity {
  /// attrValue字段，取表中suk字段
  final String? attrValue;

  /// 商品条码
  final String? barCode;

  /// attrId
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? id;

  /// sku
  final String? sku;

  /// 是否选中（非服务端字段）
  @JsonKey(defaultValue: false)
  final bool isSelect;

  /// 价格
  @JsonKey(fromJson: AppDataUtils.toDouble)
  final double? price;

  /// 图片
  final String? image;

  ProduceValueEntity({
    this.attrValue,
    this.barCode,
    this.id,
    this.sku,
    this.isSelect = false,
    this.price,
    this.image,
  });

  factory ProduceValueEntity.fromJson(Map<String, dynamic> json) =>
      _$ProduceValueEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ProduceValueEntityToJson(this);
}

/// 商品信息实体
/// 对应 Android 的 ShopInfoEntity
@JsonSerializable()
class ShopInfoEntity {
  /// 活动显示排序0=默认，1=秒杀，2=砍价，3=拼团
  final String? activity;

  /// 添加时间
  final String? addTime;

  /// 商品条码（一维码）
  final String? barCode;

  /// 品牌id
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? brandId;

  /// 浏览量
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? browse;

  /// 分类id
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? cateId;

  /// 商品详情
  final String? content;

  /// 成本价
  @JsonKey(fromJson: AppDataUtils.toDouble)
  final double? cost;

  /// 虚拟销量
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? ficti;

  /// 展示图
  final String? flatPattern;

  /// 获得积分
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? giveIntegral;

  /// 商品id
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? id;

  /// 商品图片
  final String? image;

  /// 砍价状态 0未开启 1开启
  @JsonKey(defaultValue: false)
  final bool isBargain;

  /// 是否优惠
  @JsonKey(defaultValue: false)
  final bool isBenefit;

  /// 是否精品
  @JsonKey(defaultValue: false)
  final bool isBest;

  /// 是否删除
  @JsonKey(defaultValue: false)
  final bool isDel;

  /// 是否优品
  @JsonKey(defaultValue: false)
  final bool isGood;

  /// 是否热卖
  @JsonKey(defaultValue: false)
  final bool isHot;

  /// 是否新品
  @JsonKey(defaultValue: false)
  final bool isNew;

  /// 是否包邮
  @JsonKey(defaultValue: false)
  final bool isPostage;

  /// 是否回收站
  @JsonKey(defaultValue: false)
  final bool isRecycle;

  /// 秒杀状态 0 未开启 1已开启
  @JsonKey(defaultValue: false)
  final bool isSeckill;

  /// 状态（0：未上架，1：上架）
  @JsonKey(defaultValue: false)
  final bool isShow;

  /// 是否单独分佣
  @JsonKey(defaultValue: false)
  final bool isSub;

  /// 关键字
  final String? keyword;

  /// 商户Id(0为总后台管理员创建,不为0的时候是商户后台创建)
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? merId;

  /// 商户是否代理 0不可代理1可代理
  @JsonKey(defaultValue: false)
  final bool merUse;

  /// 市场价
  @JsonKey(fromJson: AppDataUtils.toDouble)
  final double? otPrice;

  /// 邮费
  @JsonKey(fromJson: AppDataUtils.toDouble)
  final double? postage;

  /// 商品价格
  @JsonKey(fromJson: AppDataUtils.toDouble)
  final double? price;

  /// 销量
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? sales;

  /// 轮播图（字符串）
  final String? sliderImage;

  /// 轮播图列表
  final List<String>? sliderImageList;

  /// 排序
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? sort;

  /// 规格 0单 1多
  @JsonKey(defaultValue: false)
  final bool specType;

  /// SPPMid 类比SPU
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? sppmId;

  /// 库存
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? stock;

  /// 商品简介
  final String? storeInfo;

  /// 商品名称
  final String? storeName;

  /// 运费模板ID
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? tempId;

  /// 单位名
  final String? unitName;

  /// 主图视频链接
  final String? videoLink;

  /// 会员价格
  @JsonKey(fromJson: AppDataUtils.toDouble)
  final double? vipPrice;

  /// 是否支持退货
  @JsonKey(defaultValue: true)
  final bool? hasCallback;

  ShopInfoEntity({
    this.activity,
    this.addTime,
    this.barCode,
    this.brandId,
    this.browse,
    this.cateId,
    this.content,
    this.cost,
    this.ficti,
    this.flatPattern,
    this.giveIntegral,
    this.id,
    this.image,
    this.isBargain = false,
    this.isBenefit = false,
    this.isBest = false,
    this.isDel = false,
    this.isGood = false,
    this.isHot = false,
    this.isNew = false,
    this.isPostage = false,
    this.isRecycle = false,
    this.isSeckill = false,
    this.isShow = false,
    this.isSub = false,
    this.keyword,
    this.merId,
    this.merUse = false,
    this.otPrice,
    this.postage,
    this.price,
    this.sales,
    this.sliderImage,
    this.sliderImageList,
    this.sort,
    this.specType = false,
    this.sppmId,
    this.stock,
    this.storeInfo,
    this.storeName,
    this.tempId,
    this.unitName,
    this.videoLink,
    this.vipPrice,
    this.hasCallback = true,
  });

  factory ShopInfoEntity.fromJson(Map<String, dynamic> json) =>
      _$ShopInfoEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ShopInfoEntityToJson(this);
}

/// 评论实体
/// 对应 Android 的 ShopCommentEntity
@JsonSerializable()
class ShopCommentEntity {
  /// 用户头像
  final String? avatar;

  /// 评论内容
  final String? comment;

  /// 评论时间
  final String? createTime;

  /// 评论ID
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? id;

  /// 管理员回复内容
  final String? merchantReplyContent;

  /// 用户名称
  final String? nickname;

  /// 评论图片
  final List<String>? pics;

  /// 商品分数
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? score;

  /// 商品规格属性值
  final String? sku;

  /// 用户ID
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? uid;

  ShopCommentEntity({
    this.avatar,
    this.comment,
    this.createTime,
    this.id,
    this.merchantReplyContent,
    this.nickname,
    this.pics,
    this.score,
    this.sku,
    this.uid,
  });

  factory ShopCommentEntity.fromJson(Map<String, dynamic> json) =>
      _$ShopCommentEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ShopCommentEntityToJson(this);
}

/// 评论详情实体
/// 对应 Android 的 ShopCommentDetailEntity
@JsonSerializable()
class ShopCommentDetailEntity {
  /// 好评率
  final String? replyChance;

  /// 评论总数
  final String? sumCount;

  /// 回复内容
  final ShopCommentEntity? productReply;

  ShopCommentDetailEntity({
    this.replyChance,
    this.sumCount,
    this.productReply,
  });

  factory ShopCommentDetailEntity.fromJson(Map<String, dynamic> json) =>
      _$ShopCommentDetailEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ShopCommentDetailEntityToJson(this);
}

/// 评论列表外层实体
/// 对应 Android 的 ShopCommentOutEntity
@JsonSerializable()
class ShopCommentOutEntity {
  /// 评论列表
  final List<ShopCommentEntity>? list;

  /// 每页数量
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? limit;

  /// 当前页码
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? page;

  /// 总数
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? total;

  /// 总页数
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? totalPage;

  ShopCommentOutEntity({
    this.list,
    this.limit,
    this.page,
    this.total,
    this.totalPage,
  });

  factory ShopCommentOutEntity.fromJson(Map<String, dynamic> json) =>
      _$ShopCommentOutEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ShopCommentOutEntityToJson(this);
}

/// 商品详情主实体
/// 对应 Android 的 ShopDetailEntity
@JsonSerializable()
class ShopDetailEntity {
  /// 商品属性详情
  final List<ProduceValueEntity>? productValueList;

  /// 收藏标识
  @JsonKey(defaultValue: false)
  final bool userCollect;

  /// 产品属性
  final List<ShopAttrEntity>? productAttr;

  /// 商品信息
  final ShopInfoEntity? productInfo;

  ShopDetailEntity({
    this.productValueList,
    this.userCollect = false,
    this.productAttr,
    this.productInfo,
  });

  factory ShopDetailEntity.fromJson(Map<String, dynamic> json) =>
      _$ShopDetailEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ShopDetailEntityToJson(this);
}


