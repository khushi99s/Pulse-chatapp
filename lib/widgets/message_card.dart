import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';

import '../api/apis.dart';
import '../helper/dialogs.dart';
import '../helper/my_date_util.dart';
import '../helper/theme_helper.dart';
import '../main.dart';
import '../models/message.dart';

// for showing single message details
class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = APIs.user.uid == widget.message.fromId;
    return InkWell(
        onLongPress: () => _showBottomSheet(isMe),
        child: isMe ? _sentMessage() : _receivedMessage());
  }

  // sender or another user message (Telegram style - received messages)
  Widget _receivedMessage() {
    //update last read message if sender and receiver are different
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
    }
    
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(width: mq.width * .04),
        //message content
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? mq.width * .02
                : mq.width * .035),
            margin: EdgeInsets.symmetric(vertical: mq.height * .005),
            decoration: BoxDecoration(
                color: ThemeHelper.getReceivedMessageColor(isDark),
                border: Border.all(
                  color: isDark 
                      ? const Color(0xFF2B3842) 
                      : const Color(0xFFE0E0E0),
                  width: 1,
                ),
                //Telegram-style rounded corners
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.message.type == Type.text
                    ?
                    //show text
                    Text(
                        widget.message.msg,
                        style: TextStyle(
                          fontSize: 15, 
                          color: ThemeHelper.getMessageTextColor(isDark),
                        ),
                      )
                    :
                    //show image
                    ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        child: CachedNetworkImage(
                          imageUrl: widget.message.msg,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.image, size: 70),
                        ),
                      ),
                const SizedBox(height: 2),
                //message time
                Text(
                  MyDateUtil.getFormattedTime(
                      context: context, time: widget.message.sent),
                  style: TextStyle(
                    fontSize: 11, 
                    color: isDark ? Colors.white38 : Colors.black45,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: mq.width * .15),
      ],
    );
  }

  // our or user message (Telegram style - sent messages)
  Widget _sentMessage() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(width: mq.width * .15),
        //message content
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? mq.width * .02
                : mq.width * .035),
            margin: EdgeInsets.symmetric(vertical: mq.height * .005),
            decoration: BoxDecoration(
                color: ThemeHelper.getSentMessageColor(isDark),
                //Telegram-style rounded corners for sent messages
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(4))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                widget.message.type == Type.text
                    ?
                    //show text
                    Text(
                        widget.message.msg,
                        style: const TextStyle(
                          fontSize: 15, 
                          color: Colors.white,
                        ),
                      )
                    :
                    //show image
                    ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image, size: 70, color: Colors.white),
                    ),
                  ),
                const SizedBox(height: 2),
                //message time and read status
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      MyDateUtil.getFormattedTime(
                          context: context, time: widget.message.sent),
                      style: const TextStyle(
                        fontSize: 11, 
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(width: 4),
                    //double tick for message read
                    if (widget.message.read.isNotEmpty)
                      const Icon(Icons.done_all_rounded, 
                          color: Colors.lightBlueAccent, size: 16)
                    else
                      const Icon(Icons.done, 
                          color: Colors.white70, size: 16),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: mq.width * .04),
      ],
    );
  }

  // bottom sheet for modifying message details
  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              //black divider
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(
                    vertical: mq.height * .015, horizontal: mq.width * .4),
                decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
              ),

              widget.message.type == Type.text
                  ?
                  //copy option
                  _OptionItem(
                      icon: const Icon(Icons.copy_all_rounded,
                          color: Colors.blue, size: 26),
                      name: 'Copy Text',
                      onTap: (ctx) async {
                        await Clipboard.setData(
                                ClipboardData(text: widget.message.msg))
                            .then((value) {
                          if (ctx.mounted) {
                            //for hiding bottom sheet
                            Navigator.pop(ctx);

                            Dialogs.showSnackbar(ctx, 'Text Copied!');
                          }
                        });
                      })
                  :
                  //save option
                  _OptionItem(
                      icon: const Icon(Icons.download_rounded,
                          color: Colors.blue, size: 26),
                      name: 'Save Image',
                      onTap: (ctx) async {
                        try {
                          log('Image Url: ${widget.message.msg}');
                          await GallerySaver.saveImage(widget.message.msg,
                                  albumName: 'We Chat')
                              .then((success) {
                            if (ctx.mounted) {
                              //for hiding bottom sheet
                              Navigator.pop(ctx);
                              if (success != null && success) {
                                Dialogs.showSnackbar(
                                    ctx, 'Image Successfully Saved!');
                              }
                            }
                          });
                        } catch (e) {
                          log('ErrorWhileSavingImg: $e');
                        }
                      }),

              //separator or divider
              if (isMe)
                Divider(
                  color: Theme.of(context).dividerColor,
                  endIndent: mq.width * .04,
                  indent: mq.width * .04,
                ),

              //edit option
              if (widget.message.type == Type.text && isMe)
                _OptionItem(
                    icon: const Icon(Icons.edit, color: Colors.blue, size: 26),
                    name: 'Edit Message',
                    onTap: (ctx) {
                      if (ctx.mounted) {
                        _showMessageUpdateDialog(ctx);

                        //for hiding bottom sheet
                        // Navigator.pop(ctx);
                      }
                    }),

              //delete option
              if (isMe)
                _OptionItem(
                    icon: const Icon(Icons.delete_forever,
                        color: Colors.red, size: 26),
                    name: 'Delete Message',
                    onTap: (ctx) async {
                      await APIs.deleteMessage(widget.message).then((value) {
                        //for hiding bottom sheet
                        if (ctx.mounted) Navigator.pop(ctx);
                      });
                    }),

              //separator or divider
              Divider(
                color: Theme.of(context).dividerColor,
                endIndent: mq.width * .04,
                indent: mq.width * .04,
              ),

              //sent time
              _OptionItem(
                  icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
                  name:
                      'Sent At: ${MyDateUtil.getMessageTime(time: widget.message.sent)}',
                  onTap: (_) {}),

              //read time
              _OptionItem(
                  icon: const Icon(Icons.remove_red_eye, color: Colors.green),
                  name: widget.message.read.isEmpty
                      ? 'Read At: Not seen yet'
                      : 'Read At: ${MyDateUtil.getMessageTime(time: widget.message.read)}',
                  onTap: (_) {}),
            ],
          );
        });
  }

  //dialog for updating message content
  void _showMessageUpdateDialog(final BuildContext ctx) {
    String updatedMsg = widget.message.msg;

    showDialog(
        context: ctx,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),

              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),

              //title
              title: const Row(
                children: [
                  Icon(
                    Icons.message,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text(' Update Message')
                ],
              ),

              //content
              content: TextFormField(
                initialValue: updatedMsg,
                maxLines: null,
                onChanged: (value) => updatedMsg = value,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)))),
              ),

              //actions
              actions: [
                //cancel button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(ctx);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    )),

                //update button
                MaterialButton(
                    onPressed: () {
                      APIs.updateMessage(widget.message, updatedMsg);
                      //hide alert dialog
                      Navigator.pop(ctx);

                      //for hiding bottom sheet
                      Navigator.pop(ctx);
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ))
              ],
            ));
  }
}

//custom options card (for copy, edit, delete, etc.)
class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final Function(BuildContext) onTap;

  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onTap(context),
        child: Padding(
          padding: EdgeInsets.only(
              left: mq.width * .05,
              top: mq.height * .015,
              bottom: mq.height * .015),
          child: Row(children: [
            icon,
            Flexible(
                child: Text('    $name',
                    style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                        letterSpacing: 0.5)))
          ]),
        ));
  }
}
