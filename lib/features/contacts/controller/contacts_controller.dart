import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/contacts_repository.dart';

final contactsControllerProvider = FutureProvider(
  (ref) {
    final contactsRepository = ref.watch(contactsRepositoryProvider);
    return contactsRepository.getContacts();
  },
);

final selectContactProvider = Provider(
  (ref) {
    final contactsRepository = ref.watch(contactsRepositoryProvider);
    return ContactsController(
      contactsRepository: contactsRepository,
      ref: ref,
    );
  },
);

class ContactsController {
  final ContactsRepository contactsRepository;
  final ProviderRef ref;
  ContactsController({
    required this.contactsRepository,
    required this.ref,
  });

  void selectContact(BuildContext context, Contact selectContact) {
    return contactsRepository.selectContact(context, selectContact);
  }
}
