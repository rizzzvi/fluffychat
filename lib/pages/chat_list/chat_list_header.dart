import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/chat_list/client_chooser_button.dart';
import '../../widgets/matrix.dart';

class ChatListHeader extends StatelessWidget implements PreferredSizeWidget {
  final ChatListController controller;

  const ChatListHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final selectMode = controller.selectMode;

    return SliverAppBar(
      floating: true,
      toolbarHeight: 72,
      pinned:
          FluffyThemes.isColumnMode(context) || selectMode != SelectMode.normal,
      scrolledUnderElevation: selectMode == SelectMode.normal ? 0 : null,
      backgroundColor:
          selectMode == SelectMode.normal ? Colors.transparent : null,
      automaticallyImplyLeading: false,
      leading: selectMode == SelectMode.normal
          ? null
          : IconButton(
              tooltip: L10n.of(context)!.cancel,
              icon: const Icon(Icons.close_outlined),
              onPressed: controller.cancelAction,
              color: Theme.of(context).colorScheme.primary,
            ),
      title: selectMode == SelectMode.share
          ? Text(
              L10n.of(context)!.share,
              key: const ValueKey(SelectMode.share),
            )
          : selectMode == SelectMode.select
              ? Text(
                  controller.selectedRoomIds.length.toString(),
                  key: const ValueKey(SelectMode.select),
                )
              : TextField(
                  controller: controller.searchController,
                  focusNode: controller.searchFocusNode,
                  textInputAction: TextInputAction.search,
                  onChanged: controller.onSearchEnter,
                  decoration: InputDecoration(
                    fillColor: Theme.of(context).colorScheme.secondaryContainer,
                    border: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    hintText: L10n.of(context)!.searchChatsRooms,
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.normal,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    prefixIcon: controller.isSearchMode
                        ? IconButton(
                            tooltip: L10n.of(context)!.cancel,
                            icon: const Icon(Icons.close_outlined),
                            onPressed: controller.cancelSearch,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          )
                        : IconButton(
                            onPressed: controller.startSearch,
                            icon: Icon(
                              Icons.search_outlined,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                          ),
                    suffixIcon: controller.isSearchMode
                        ? controller.isSearching
                            ? const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 12,
                                ),
                                child: SizedBox.square(
                                  dimension: 24,
                                  child: CircularProgressIndicator.adaptive(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : TextButton.icon(
                                onPressed: controller.setServer,
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(99),
                                  ),
                                  textStyle: const TextStyle(fontSize: 12),
                                ),
                                icon: const Icon(Icons.edit_outlined, size: 16),
                                label: Text(
                                  controller.searchServer ??
                                      Matrix.of(context)
                                          .client
                                          .homeserver!
                                          .host,
                                  maxLines: 2,
                                ),
                              )
                        : SizedBox(
                            width: 0,
                            child: ClientChooserButton(controller),
                          ),
                  ),
                ),
      actions: selectMode == SelectMode.share
          ? [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: ClientChooserButton(controller),
              ),
            ]
          : selectMode == SelectMode.select
              ? [
                  if (controller.spaces.isNotEmpty)
                    IconButton(
                      tooltip: L10n.of(context)!.addToSpace,
                      icon: const Icon(Icons.workspaces_outlined),
                      onPressed: controller.addToSpace,
                    ),
                  IconButton(
                    tooltip: L10n.of(context)!.toggleUnread,
                    icon: Icon(
                      controller.anySelectedRoomNotMarkedUnread
                          ? Icons.mark_chat_unread_outlined
                          : Icons.mark_chat_read_outlined,
                    ),
                    onPressed: controller.toggleUnread,
                  ),
                  IconButton(
                    tooltip: L10n.of(context)!.toggleFavorite,
                    icon: Icon(
                      controller.anySelectedRoomNotFavorite
                          ? Icons.push_pin
                          : Icons.push_pin_outlined,
                    ),
                    onPressed: controller.toggleFavouriteRoom,
                  ),
                  IconButton(
                    icon: Icon(
                      controller.anySelectedRoomNotMuted
                          ? Icons.notifications_off_outlined
                          : Icons.notifications_outlined,
                    ),
                    tooltip: L10n.of(context)!.toggleMuted,
                    onPressed: controller.toggleMuted,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outlined),
                    tooltip: L10n.of(context)!.archive,
                    onPressed: controller.archiveAction,
                  ),
                ]
              : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
