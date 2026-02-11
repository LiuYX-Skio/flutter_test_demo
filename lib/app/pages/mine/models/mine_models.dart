import 'package:json_annotation/json_annotation.dart';
import '../../../../navigation/utils/app_data_utils.dart';

part 'mine_models.g.dart';

@JsonSerializable()
class MineCreditEntity {
  @JsonKey(fromJson: AppDataUtils.toDouble)
  final double? creditAmount;
  final bool? hasPetty;
  final String? repaymentDate;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? exceedDay;
  final String? overdueRepaymentRate;
  @JsonKey(fromJson: AppDataUtils.toDouble)
  final double? usableCreditAmount;
  @JsonKey(fromJson: AppDataUtils.toDouble)
  final double? minimumRepayment;
  @JsonKey(fromJson: AppDataUtils.toDouble)
  final double? pettyMinMoney;
  @JsonKey(fromJson: AppDataUtils.toDouble)
  final double? moneyRate;
  @JsonKey(fromJson: AppDataUtils.toDouble)
  final double? minimumRepaymentRate;
  final String? name;
  final String? cardNo;
  final CreditBillEntity? lastBill;

  MineCreditEntity({
    this.creditAmount,
    this.hasPetty,
    this.repaymentDate,
    this.exceedDay,
    this.overdueRepaymentRate,
    this.usableCreditAmount,
    this.minimumRepayment,
    this.pettyMinMoney,
    this.moneyRate,
    this.minimumRepaymentRate,
    this.name,
    this.cardNo,
    this.lastBill,
  });

  factory MineCreditEntity.fromJson(Map<String, dynamic> json) =>
      _$MineCreditEntityFromJson(json);

  Map<String, dynamic> toJson() => _$MineCreditEntityToJson(this);
}

@JsonSerializable()
class CreditBillEntity {
  final String? billMonth;
  final String? billMonthItem;
  @JsonKey(fromJson: AppDataUtils.toDouble)
  final double? totalMoney;

  CreditBillEntity({
    this.billMonth,
    this.billMonthItem,
    this.totalMoney,
  });

  factory CreditBillEntity.fromJson(Map<String, dynamic> json) =>
      _$CreditBillEntityFromJson(json);

  Map<String, dynamic> toJson() => _$CreditBillEntityToJson(this);
}

@JsonSerializable()
class UserMonthPayEntity {
  final String? creditAmount;
  final String? creditAmountResult;
  final String? creditUseAmount;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? status;
  final List<MonthPayListEntity>? list;

  UserMonthPayEntity({
    this.creditAmount,
    this.creditAmountResult,
    this.creditUseAmount,
    this.status,
    this.list,
  });

  factory UserMonthPayEntity.fromJson(Map<String, dynamic> json) =>
      _$UserMonthPayEntityFromJson(json);

  Map<String, dynamic> toJson() => _$UserMonthPayEntityToJson(this);
}

@JsonSerializable()
class MonthPayListEntity {
  final String? billName;
  final String? billPrice;
  final String? createdAt;
  final String? id;
  final String? orderId;
  final String? paymentDate;
  final String? refId;
  final String? refundAmount;
  final String? refundDate;
  @JsonKey(fromJson: AppDataUtils.toDouble)
  final double? repaymentAmount;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? status;
  final String? updatedAt;
  final String? userId;

  MonthPayListEntity({
    this.billName,
    this.billPrice,
    this.createdAt,
    this.id,
    this.orderId,
    this.paymentDate,
    this.refId,
    this.refundAmount,
    this.refundDate,
    this.repaymentAmount,
    this.status,
    this.updatedAt,
    this.userId,
  });

  factory MonthPayListEntity.fromJson(Map<String, dynamic> json) =>
      _$MonthPayListEntityFromJson(json);

  Map<String, dynamic> toJson() => _$MonthPayListEntityToJson(this);
}

@JsonSerializable()
class UploadEntity {
  final String? url;

  UploadEntity({this.url});

  factory UploadEntity.fromJson(Map<String, dynamic> json) =>
      _$UploadEntityFromJson(json);

  Map<String, dynamic> toJson() => _$UploadEntityToJson(this);
}

@JsonSerializable()
class WithDrawUserInfo {
  final String? freezeMoney;
  final String? minPrice;
  final String? nowMoney;

  WithDrawUserInfo({
    this.freezeMoney,
    this.minPrice,
    this.nowMoney,
  });

  factory WithDrawUserInfo.fromJson(Map<String, dynamic> json) =>
      _$WithDrawUserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$WithDrawUserInfoToJson(this);
}

@JsonSerializable()
class WithDrawRecordShell {
  final String? limit;
  final List<WithDrawRecord>? list;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? page;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? total;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? totalPage;

  WithDrawRecordShell({
    this.limit,
    this.list,
    this.page,
    this.total,
    this.totalPage,
  });

  factory WithDrawRecordShell.fromJson(Map<String, dynamic> json) =>
      _$WithDrawRecordShellFromJson(json);

  Map<String, dynamic> toJson() => _$WithDrawRecordShellToJson(this);
}

@JsonSerializable()
class WithDrawRecord {
  final String? alipayCode;
  final String? balance;
  final String? extractPrice;
  final String? extractType;
  final String? failMsg;
  final String? failTime;
  final String? createTime;
  final String? bankName;
  final String? id;
  final String? item;
  final String? mark;
  final String? realName;
  final String? wechat;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? status;

  WithDrawRecord({
    this.alipayCode,
    this.balance,
    this.extractPrice,
    this.extractType,
    this.failMsg,
    this.failTime,
    this.createTime,
    this.bankName,
    this.id,
    this.item,
    this.mark,
    this.realName,
    this.wechat,
    this.status,
  });

  factory WithDrawRecord.fromJson(Map<String, dynamic> json) =>
      _$WithDrawRecordFromJson(json);

  Map<String, dynamic> toJson() => _$WithDrawRecordToJson(this);
}

@JsonSerializable()
class BackUpDrawEntity {
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? status;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? alipayCode;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? extractPrice;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? handlingFee;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? purpose;

  BackUpDrawEntity({
    this.status,
    this.alipayCode,
    this.extractPrice,
    this.handlingFee,
    this.purpose,
  });

  factory BackUpDrawEntity.fromJson(Map<String, dynamic> json) =>
      _$BackUpDrawEntityFromJson(json);

  Map<String, dynamic> toJson() => _$BackUpDrawEntityToJson(this);
}
