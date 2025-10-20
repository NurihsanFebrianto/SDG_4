import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/friends_provider.dart';
import '../models/friend.dart';
import 'friend_profile_screen.dart';

class FriendsListScreen extends StatefulWidget {
  const FriendsListScreen({super.key});

  @override
  State<FriendsListScreen> createState() => _FriendsListScreenState();
}

class _FriendsListScreenState extends State<FriendsListScreen> {
  @override
  void initState() {
    super.initState();
    // Load suggested friends when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FriendsProvider>().loadSuggestedFriends();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teman'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: Consumer<FriendsProvider>(
        builder: (context, friendsProvider, child) {
          if (friendsProvider.isLoading &&
              friendsProvider.addedFriends.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (friendsProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${friendsProvider.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: friendsProvider.loadSuggestedFriends,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => friendsProvider.loadSuggestedFriends(),
            child: CustomScrollView(
              slivers: [
                // Added Friends Section
                if (friendsProvider.addedFriends.isNotEmpty)
                  _buildFriendsSection(
                    'Teman Anda',
                    friendsProvider.addedFriends,
                    friendsProvider,
                    isAdded: true,
                  ),

                // Suggested Friends Section
                _buildFriendsSection(
                  friendsProvider.addedFriends.isEmpty
                      ? 'Pengguna yang Mungkin Anda Kenal'
                      : 'Saran Teman',
                  friendsProvider.suggestedFriends,
                  friendsProvider,
                  isAdded: false,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFriendsSection(
    String title,
    List<Friend> friends,
    FriendsProvider provider, {
    required bool isAdded,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              );
            }

            final friendIndex = index - 1;
            if (friendIndex >= friends.length) return null;

            final friend = friends[friendIndex];
            return _FriendCard(
              friend: friend,
              isAdded: isAdded,
              onTap: () => _navigateToProfile(context, friend, isAdded),
              onAddRemove: () =>
                  _handleAddRemoveFriend(provider, friend, isAdded),
            );
          },
          childCount: friends.length + 1,
        ),
      ),
    );
  }

  void _navigateToProfile(BuildContext context, Friend friend, bool isAdded) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FriendProfileScreen(
          friend: friend,
          isAddedFriend: isAdded,
        ),
      ),
    );
  }

  void _handleAddRemoveFriend(
      FriendsProvider provider, Friend friend, bool isAdded) {
    if (isAdded) {
      provider.removeFriend(friend.id);
    } else {
      provider.addFriend(friend);
    }
  }
}

class _FriendCard extends StatelessWidget {
  final Friend friend;
  final bool isAdded;
  final VoidCallback onTap;
  final VoidCallback onAddRemove;

  const _FriendCard({
    required this.friend,
    required this.isAdded,
    required this.onTap,
    required this.onAddRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundImage: CachedNetworkImageProvider(friend.picture),
          backgroundColor: Colors.grey[300],
        ),
        title: Text(
          friend.name,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(friend.email),
            const SizedBox(height: 2),
            Text(
              friend.location,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            isAdded ? Icons.person_remove : Icons.person_add,
            color: isAdded ? Colors.red : Theme.of(context).primaryColor,
          ),
          onPressed: onAddRemove,
        ),
        onTap: onTap,
      ),
    );
  }
}
