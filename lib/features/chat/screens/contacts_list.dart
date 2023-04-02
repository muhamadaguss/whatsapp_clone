import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_cl/colors.dart';
import 'package:whatsapp_cl/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_cl/models/chat_contact_model.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0.h),
      child: StreamBuilder<List<ChatContactModel>>(
          stream: ref.read(chatControllerProvider).getChatContacts(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/chat', arguments: {
                          'name': snapshot.data![index].name,
                          'uid': snapshot.data![index].contactId,
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.0.h),
                        child: ListTile(
                          title: Text(
                            snapshot.data![index].name.toString(),
                            style: TextStyle(
                              fontSize: 16.sp,
                            ),
                          ),
                          subtitle: Padding(
                            padding: EdgeInsets.only(top: 6.0.h),
                            child: Text(
                              snapshot.data![index].lastMessage.toString(),
                              style: TextStyle(fontSize: 14.sp),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              snapshot.data![index].profilePic.toString(),
                            ),
                            radius: 30.r,
                          ),
                          trailing: Text(
                            DateFormat.Hm().format(
                              snapshot.data![index].lastMessageTime,
                            ),
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(color: dividerColor, indent: 85),
                  ],
                );
              },
            );
          }),
    );
  }
}
