// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mine_models.dart';

// ***************************************************************************
// JsonSerializableGenerator
// ***************************************************************************

MineCreditEntity _$MineCreditEntityFromJson(Map<String, dynamic> json) =>
    MineCreditEntity(
      creditAmount: AppDataUtils.toDouble(json['creditAmount']),
      hasPetty: json['hasPetty'] as bool?,
      repaymentDate: json['repaymentDate'] as String?,
      exceedDay: AppDataUtils.toInt(json['exceedDay']),
      overdueRepaymentRate: json['overdueRepaymentRate'] as String?,
      usableCreditAmount: AppDataUtils.toDouble(json['usableCreditAmount']),
      minimumRepayment: AppDataUtils.toDouble(json['minimumRepayment']),
      pettyMinMoney: AppDataUtils.toDouble(json['pettyMinMoney']),
      moneyRate: AppDataUtils.toDouble(json['moneyRate']),
      minimumRepaymentRate: AppDataUtils.toDouble(json['minimumRepaymentRate']),
      name: json['name'] as String?,
      cardNo: json['cardNo'] as String?,
      lastBill: json['lastBill'] == null
          ? null
          : CreditBillEntity.fromJson(
              json['lastBill'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MineCreditEntityToJson(MineCreditEntity instance) =>
    <String, dynamic>{
      'creditAmount': instance.creditAmount,
      'hasPetty': instance.hasPetty,
      'repaymentDate': instance.repaymentDate,
      'exceedDay': instance.exceedDay,
      'overdueRepaymentRate': instance.overdueRepaymentRate,
      'usableCreditAmount': instance.usableCreditAmount,
      'minimumRepayment': instance.minimumRepayment,
      'pettyMinMoney': instance.pettyMinMoney,
      'moneyRate': instance.moneyRate,
      'minimumRepaymentRate': instance.minimumRepaymentRate,
      'name': instance.name,
      'cardNo': instance.cardNo,
      'lastBill': instance.lastBill,
    };

CreditBillEntity _$CreditBillEntityFromJson(Map<String, dynamic> json) =>
    CreditBillEntity(
      billMonth: json['billMonth'] as String?,
      billMonthItem: json['billMonthItem'] as String?,
      totalMoney: AppDataUtils.toDouble(json['totalMoney']),
    );

Map<String, dynamic> _$CreditBillEntityToJson(CreditBillEntity instance) =>
    <String, dynamic>{
      'billMonth': instance.billMonth,
      'billMonthItem': instance.billMonthItem,
      'totalMoney': instance.totalMoney,
    };

UserMonthPayEntity _$UserMonthPayEntityFromJson(Map<String, dynamic> json) =>
    UserMonthPayEntity(
      creditAmount: json['creditAmount'] as String?,
      creditAmountResult: json['creditAmountResult'] as String?,
      creditUseAmount: json['creditUseAmount'] as String?,
      status: AppDataUtils.toInt(json['status']),
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => MonthPayListEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserMonthPayEntityToJson(UserMonthPayEntity instance) =>
    <String, dynamic>{
      'creditAmount': instance.creditAmount,
      'creditAmountResult': instance.creditAmountResult,
      'creditUseAmount': instance.creditUseAmount,
      'status': instance.status,
      'list': instance.list,
    };

MonthPayListEntity _$MonthPayListEntityFromJson(Map<String, dynamic> json) =>
    MonthPayListEntity(
      billName: json['billName'] as String?,
      billPrice: json['billPrice'] as String?,
      createdAt: json['createdAt'] as String?,
      id: json['id'] as String?,
      orderId: json['orderId'] as String?,
      paymentDate: json['paymentDate'] as String?,
      refId: json['refId'] as String?,
      refundAmount: json['refundAmount'] as String?,
      refundDate: json['refundDate'] as String?,
      repaymentAmount: AppDataUtils.toDouble(json['repaymentAmount']),
      status: AppDataUtils.toInt(json['status']),
      updatedAt: json['updatedAt'] as String?,
      userId: json['userId'] as String?,
    );

Map<String, dynamic> _$MonthPayListEntityToJson(MonthPayListEntity instance) =>
    <String, dynamic>{
      'billName': instance.billName,
      'billPrice': instance.billPrice,
      'createdAt': instance.createdAt,
      'id': instance.id,
      'orderId': instance.orderId,
      'paymentDate': instance.paymentDate,
      'refId': instance.refId,
      'refundAmount': instance.refundAmount,
      'refundDate': instance.refundDate,
      'repaymentAmount': instance.repaymentAmount,
      'status': instance.status,
      'updatedAt': instance.updatedAt,
      'userId': instance.userId,
    };

UploadEntity _$UploadEntityFromJson(Map<String, dynamic> json) => UploadEntity(
      url: json['url'] as String?,
    );

Map<String, dynamic> _$UploadEntityToJson(UploadEntity instance) =>
    <String, dynamic>{
      'url': instance.url,
    };

WithDrawUserInfo _$WithDrawUserInfoFromJson(Map<String, dynamic> json) =>
    WithDrawUserInfo(
      freezeMoney: json['freezeMoney'] as String?,
      minPrice: json['minPrice'] as String?,
      nowMoney: json['nowMoney'] as String?,
    );

Map<String, dynamic> _$WithDrawUserInfoToJson(WithDrawUserInfo instance) =>
    <String, dynamic>{
      'freezeMoney': instance.freezeMoney,
      'minPrice': instance.minPrice,
      'nowMoney': instance.nowMoney,
    };

WithDrawRecordShell _$WithDrawRecordShellFromJson(Map<String, dynamic> json) =>
    WithDrawRecordShell(
      limit: json['limit'] as String?,
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => WithDrawRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: AppDataUtils.toInt(json['page']),
      total: AppDataUtils.toInt(json['total']),
      totalPage: AppDataUtils.toInt(json['totalPage']),
    );

Map<String, dynamic> _$WithDrawRecordShellToJson(WithDrawRecordShell instance) =>
    <String, dynamic>{
      'limit': instance.limit,
      'list': instance.list,
      'page': instance.page,
      'total': instance.total,
      'totalPage': instance.totalPage,
    };

WithDrawRecord _$WithDrawRecordFromJson(Map<String, dynamic> json) =>
    WithDrawRecord(
      alipayCode: json['alipayCode'] as String?,
      balance: json['balance'] as String?,
      extractPrice: json['extractPrice'] as String?,
      extractType: json['extractType'] as String?,
      failMsg: json['failMsg'] as String?,
      failTime: json['failTime'] as String?,
      createTime: json['createTime'] as String?,
      bankName: json['bankName'] as String?,
      id: json['id'] as String?,
      item: json['item'] as String?,
      mark: json['mark'] as String?,
      realName: json['realName'] as String?,
      wechat: json['wechat'] as String?,
      status: AppDataUtils.toInt(json['status']),
    );

Map<String, dynamic> _$WithDrawRecordToJson(WithDrawRecord instance) =>
    <String, dynamic>{
      'alipayCode': instance.alipayCode,
      'balance': instance.balance,
      'extractPrice': instance.extractPrice,
      'extractType': instance.extractType,
      'failMsg': instance.failMsg,
      'failTime': instance.failTime,
      'createTime': instance.createTime,
      'bankName': instance.bankName,
      'id': instance.id,
      'item': instance.item,
      'mark': instance.mark,
      'realName': instance.realName,
      'wechat': instance.wechat,
      'status': instance.status,
    };

BackUpDrawEntity _$BackUpDrawEntityFromJson(Map<String, dynamic> json) =>
    BackUpDrawEntity(
      status: AppDataUtils.toStringValue(json['status']),
      alipayCode: AppDataUtils.toStringValue(json['alipayCode']),
      extractPrice: AppDataUtils.toStringValue(json['extractPrice']),
      handlingFee: AppDataUtils.toStringValue(json['handlingFee']),
      purpose: AppDataUtils.toStringValue(json['purpose']),
    );

Map<String, dynamic> _$BackUpDrawEntityToJson(BackUpDrawEntity instance) =>
    <String, dynamic>{
      'status': instance.status,
      'alipayCode': instance.alipayCode,
      'extractPrice': instance.extractPrice,
      'handlingFee': instance.handlingFee,
      'purpose': instance.purpose,
    };
