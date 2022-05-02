import 'dart:convert';

/// status : 0
/// accounts : [{"account_id":"X","full_name":"Assets","name":"Assets","parent_account_id":"X","account_type":"ASSET","notes":null,"commodity_type":"CURRENCY","commodity_value":"INR","owner_id":"X","taxable":"F","place_holder":"T"}]

AccountsFullResponse accountsFullResponseFromJson(String str) =>
    AccountsFullResponse.fromJson(json.decode(str));

class AccountsFullResponse {
  final int status;
  final List<Account> accounts;

  AccountsFullResponse({
    required this.status,
    required this.accounts,
  });

  factory AccountsFullResponse.fromJson(Map<String, dynamic> json) {
    List<Account> accountsInResponse = [];
    if (json['accounts'] != null) {
      json['accounts'].forEach((accountInResponse) {
        accountsInResponse.add(Account.fromJson(accountInResponse));
      });
    }
    return AccountsFullResponse(
        status: json['status'], accounts: accountsInResponse);
  }
}

/// account_id : "X"
/// full_name : "Assets"
/// name : "Assets"
/// parent_account_id : "X"
/// account_type : "ASSET"
/// notes : null
/// commodity_type : "CURRENCY"
/// commodity_value : "INR"
/// owner_id : "X"
/// taxable : "F"
/// place_holder : "T"

Account accountsFromJson(String str) => Account.fromJson(json.decode(str));

class Account {
  final String accountId;
  final String fullName;
  final String name;
  final String parentAccountId;
  final String accountType;
  final String notes;
  final String commodityType;
  final String commodityValue;
  final String ownerId;
  final String taxable;
  final String placeHolder;

  Account({
    required this.accountId,
    required this.fullName,
    required this.name,
    required this.parentAccountId,
    required this.accountType,
    required this.notes,
    required this.commodityType,
    required this.commodityValue,
    required this.ownerId,
    required this.taxable,
    required this.placeHolder,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
        accountId: json['account_id'],
        fullName: json['full_name'],
        name: json['name'],
        parentAccountId: json['parent_account_id'] ??= '0',
        accountType: json['account_type'],
        notes: json['notes'] ??= '',
        commodityType: json['commodity_type'],
        commodityValue: json['commodity_value'],
        ownerId: json['owner_id'],
        taxable: json['taxable'],
        placeHolder: json['place_holder']);
  }
}
