import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:sevenapplication/core/models/BankAccount.dart';

class BankAccountService {
  /* static Future<void> createBankAccount(String iban, String? bic) async {
    final currentUser = await ParseUser.currentUser()!;

    final query = ParseObject('BankAccount')
      ..set('iban', iban)
      ..set('bic', bic)
      ..set('user',
          (ParseObject('_User')..objectId = currentUser.objectId).toPointer());

    try {
      final response = await query.save();
      if (response.success) {
        print('BankAccount created successfully!');

        currentUser.set(
            'rib',
            (ParseObject('BankAccount')
                  ..objectId = response.results!.first.objectId)
                .toPointer());
        final userResponse = await currentUser.save();
        if (userResponse.success) {
          print('User rib updated successfully!');
        } else {
          print('Error updating user rib: ${userResponse.error!.message}');
        }
      } else {
        print('Error creating BankAccount: ${response.error!.message}');
      }
    } catch (e) {
      print('Error creating BankAccount: $e');
    }
  } */

  static Future<void> createBankAccount(String iban, String? bic) async {
    final currentUser = await ParseUser.currentUser()!;

    final query = ParseObject('BankAccount')
      ..set('iban', iban)
      ..set('bic', bic)
      ..set('user',
          (ParseObject('_User')..objectId = currentUser.objectId).toPointer());
    try {
      final response = await query.save();
      if (response.success) {
        print('BankAccount created successfully!');
      } else {
        print('Error creating BankAccount: ${response.error!.message}');
      }
    } catch (e) {
      print('Error creating BankAccount: $e');
    }
  }

  static Future<void> deleteBankAccount(String userID) async {
    final userPointer = (ParseObject('_User')..objectId = userID).toPointer();

    final query = QueryBuilder<ParseObject>(ParseObject('BankAccount'))
      ..whereEqualTo('user', userPointer);
    final ParseResponse apiResponse = await query.query();

    if (apiResponse.success && apiResponse.results != null) {
      final bankAccount = apiResponse.results!.first;
      await bankAccount.delete();
      print('BankAccount deleted successfully!');
    } else {
      print(apiResponse.error!.message);
    }
  }

  static Future<void> updateBankAccount(
      String bankID, String? iban, String? bic) async {
    final query = QueryBuilder<ParseObject>(ParseObject('BankAccount'))
      ..whereEqualTo('objectId', bankID);
    final ParseResponse apiResponse = await query.query();

    if (apiResponse.success && apiResponse.results != null) {
      final bankAccount = apiResponse.results!.first;
      bankAccount.set('iban', iban);
      bankAccount.set('bic', bic);
      await bankAccount.save();
    } else {
      print(apiResponse.error!.message);
    }
  }

  static Future<BankAccount> fetchUserBankAccount() async {
    QueryBuilder<ParseObject> query;

    final currentUser = await ParseUser.currentUser();

    QueryBuilder<ParseObject> userquery =
        QueryBuilder<ParseObject>(ParseObject('_User'))
          ..whereEqualTo('objectId', currentUser!.get("objectId"));

    query = QueryBuilder<ParseObject>(ParseObject("BankAccount"))
      ..whereMatchesKeyInQuery("user", "objectId", userquery);
    final ParseResponse apiResponse = await query.query();

    if (apiResponse.success && apiResponse.results != null) {
      return BankAccount.fromJson(apiResponse.results!.first);
    } else {
      return BankAccount();
    }
  }

  static Future<bool> checkIfUserExistsInBank(String userID) async {
    final userPointer = (ParseObject('_User')..objectId = userID).toPointer();

    final query = QueryBuilder<ParseObject>(ParseObject('BankAccount'))
      ..whereEqualTo('user', userPointer);
    final ParseResponse apiResponse = await query.query();

    if (apiResponse.success && apiResponse.results != null) {
      return true;
    } else {
      return false;
    }
  }
}
