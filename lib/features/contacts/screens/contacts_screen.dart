import 'package:after_layout/after_layout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_cl/features/contacts/controller/contacts_controller.dart';

import '../../../colors.dart';

class ContactsScreen extends ConsumerStatefulWidget {
  const ContactsScreen({super.key});

  @override
  ConsumerState<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends ConsumerState<ContactsScreen>
    with AfterLayoutMixin<ContactsScreen> {
  List<Contact>? _contacts;
  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _fetchContacts();
  }

  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission()) {
      setState(() {
        _contacts = null;
        _permissionDenied = true;
      });
      return;
    }

    await _refetchContacts();

    // Listen to DB changes
    FlutterContacts.addListener(() async {
      if (kDebugMode) {
        print('Contacts DB changed, refecthing contacts');
      }
      await _refetchContacts();
    });
  }

  Future _refetchContacts() async {
    // First load all contacts without photo
    // await _loadContacts(false);

    // Next with photo
    await _loadContacts(true);
  }

  Future _loadContacts(bool withPhotos) async {
    final contacts = withPhotos
        ? (await FlutterContacts.getContacts(withProperties: true)).toList()
        : (await FlutterContacts.getContacts()).toList();
    setState(() {
      _contacts = contacts;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appBarColor,
          centerTitle: false,
          title: Text(
            'Select Contact',
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
        body: _body(),
      );

  Widget _body() {
    if (_permissionDenied) {
      return const Center(child: Text('Permission denied'));
    }
    if (_contacts == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
        itemCount: _contacts?.length ?? 0,
        itemBuilder: (context, i) {
          final contact = _contacts![i];
          return ListTile(
            leading: contact.photoOrThumbnail != null
                ? CircleAvatar(
                    radius: 25.r,
                    backgroundImage: MemoryImage(
                      contact.photoOrThumbnail!,
                    ),
                  )
                : CircleAvatar(
                    radius: 25.r,
                    backgroundImage: const AssetImage(
                      'assets/empty.png',
                    ),
                  ),
            title: Text(
              contact.displayName,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              contact.phones.first.number.replaceAllMapped(
                RegExp(r'[ -]'),
                (match) => '',
              ),
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () => ref.watch(selectContactProvider).selectContact(
                  context,
                  contact,
                ),
          );
        });
  }
}
