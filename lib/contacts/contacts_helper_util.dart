import 'dart:typed_data';

import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_utils_juni1289/apputil/enums_util_helper.dart';
import 'package:flutter_utils_juni1289/exceptions/contacts_helper_util_exception.dart';
import 'package:flutter_utils_juni1289/permission/helper/permission_helper_util.dart';
import 'package:flutter_utils_juni1289/permission/model/permission_handler_helper_model.dart';

class ContactsHelperUtil {
  /// private constructor
  ContactsHelperUtil._();

  /// the one and only instance of this singleton
  static final instance = ContactsHelperUtil._();

  ///get the contacts with all the properties
  ///[sorted] get the contacts pre sorted from the below async method
  ///[onPhoneContactsFetchedCallback] is the callback required for getting the contacts
  ///[allowedMSISDNPrefixesList] is the list of strings with contact country codes | Prefix that should be allowed to pick
  void getContactsFromPhone(
      {required BuildContext context,
      required Function(List<Contact?>? sortedContacts, PermissionsResultsEnums permissionsResultsEnum) onPhoneContactsFetchedCallback,
      bool sorted = true,
      List<String?>? allowedMSISDNPrefixesList}) {
    PermissionHelperUtil.instance.checkIfContactsPermissionGranted().then((PermissionHandlerHelperModel? permissionHandlerHelperModel) {
      if (permissionHandlerHelperModel != null) {
        if (permissionHandlerHelperModel.permissionsResult == PermissionsResultsEnums.granted) {
          FastContacts.getAllContacts().then((List<Contact> contacts) {
            List<Contact> sortedContacts = [];
            List<CustomContactsHelperModel> contactsWithImage = [];
            for (var contact in contacts) {
              if (contact.displayName != null && contact.displayName.isNotEmpty && contact.phones != null && contact.phones.isNotEmpty) {
                if (contact.id != null && contact.id.isNotEmpty) {
                  FastContacts.getContactImage(contact.id).then((Uint8List? photo) {
                    if (photo != null) {
                      contactsWithImage.add(CustomContactsHelperModel(
                          contactMSISDN: contact.phones[0] != null && contact.phones[0].number != null && contact.phones[0].number.isNotEmpty ? contact.phones[0].number : "",
                          photo: photo));
                    }
                  });
                }

                //allow only those MSISDNs which are starting with the specific prefixes
                var givenMSISDN = (contact.phones[0].number);
                if (allowedMSISDNPrefixesList != null && allowedMSISDNPrefixesList.isNotEmpty) {
                  for (var prefix in allowedMSISDNPrefixesList) {
                    if (givenMSISDN.startsWith(prefix ?? "")) {
                      sortedContacts.add(contact);
                    }
                  }
                }
              }
            }

            //sorted is true, then sort
            if (sorted) {
              sortedContacts.sort((Contact? a, Contact? b) {
                var displayNameA = a?.displayName ?? "";
                var displayNameB = b?.displayName ?? "";
                return displayNameA.compareTo(displayNameB);
              });
            }

            onPhoneContactsFetchedCallback(sortedContacts, PermissionsResultsEnums.granted);
          }).onError((error, stackTrace) {
            throw ContactsHelperUtilException(cause: "Contacts Error Code:::9711:::$stackTrace");
          });
        } else if (permissionHandlerHelperModel.permissionsResult == PermissionsResultsEnums.denied) {
          onPhoneContactsFetchedCallback(null, PermissionsResultsEnums.denied);
        } else if (permissionHandlerHelperModel.permissionsResult == PermissionsResultsEnums.permanentlyDenied) {
          onPhoneContactsFetchedCallback(null, PermissionsResultsEnums.permanentlyDenied);
        }
      } else {
        throw ContactsHelperUtilException(cause: "Permission helper model is null!");
      }
    }).onError((error, stackTrace) {
      throw ContactsHelperUtilException(cause: "Contacts Error Code:::9710:::$stackTrace");
    });
  }

  Uint8List? getPhotoFromContact({required String contactNumber, List<CustomContactsHelperModel?>? customContactsHelperModel}) {
    if (contactNumber.isNotEmpty && customContactsHelperModel != null && customContactsHelperModel.isNotEmpty) {
      Uint8List? photo;
      for (var contactNumberWithPhoto in customContactsHelperModel) {
        if ((contactNumber.replaceAll(" ", "").trim()) == ((contactNumberWithPhoto?.contactMSISDN ?? "").replaceAll(" ", "").trim())) {
          photo = contactNumberWithPhoto?.photo;
          break;
        }
      }

      return photo;
    }

    return null;
  }
}

class CustomContactsHelperModel {
  Uint8List photo;
  String contactMSISDN;

  CustomContactsHelperModel({required this.photo, required this.contactMSISDN});
}
