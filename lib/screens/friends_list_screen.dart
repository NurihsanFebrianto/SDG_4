import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/friends_provider.dart';
import '../models/friend.dart';
import 'friend_profile_screen.dart';

// Academic Color Constants
const Color primaryDarkBlue = Color(0xFF0A3D62);
const Color primaryBlue = Color(0xFF1E3A8A);
const Color primaryLightBlue = Color(0xFF0D47A1);
const Color secondaryCyan = Color(0xFF0EA5E9);
const Color secondaryBlue = Color(0xFF0284C7);
const Color secondaryTeal = Color(0xFF14B8A6);
const Color accentAmber = Color(0xFFFBBF24);
const Color accentOrange = Color(0xFFF59E0B);
const Color successGreen = Color(0xFF10B981);
const Color warningYellow = Color(0xFFF59E0B);
const Color errorRed = Color(0xFFEF4444);
const Color neutralGray = Color(0xFF6B7280);

class FriendsListScreen extends StatefulWidget {
  const FriendsListScreen({super.key});

  @override
  State<FriendsListScreen> createState() => _FriendsListScreenState();
}

class _FriendsListScreenState extends State<FriendsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FriendsProvider>().loadSuggestedFriends();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Komunitas Belajar',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryDarkBlue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFFF8FAFC),
      body: Consumer<FriendsProvider>(
        builder: (context, friendsProvider, child) {
          if (friendsProvider.isLoading &&
              friendsProvider.addedFriends.isEmpty) {
            return _buildAcademicLoadingState();
          }

          if (friendsProvider.error != null) {
            return _buildAcademicErrorState(friendsProvider);
          }

          return RefreshIndicator(
            color: primaryBlue,
            backgroundColor: Colors.white,
            onRefresh: () => friendsProvider.loadSuggestedFriends(),
            child: CustomScrollView(
              slivers: [
                // Added Friends Section
                if (friendsProvider.addedFriends.isNotEmpty)
                  _buildAcademicFriendsSection(
                    'Teman Belajar Anda',
                    friendsProvider.addedFriends,
                    friendsProvider,
                    isAdded: true,
                  ),

                // Suggested Friends Section
                _buildAcademicFriendsSection(
                  friendsProvider.addedFriends.isEmpty
                      ? 'Rekomendasi Teman Belajar'
                      : 'Teman Belajar Lainnya',
                  friendsProvider.suggestedFriends,
                  friendsProvider,
                  isAdded: false,
                ),

                // Empty Space
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAcademicLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.groups_rounded,
              size: 48,
              color: primaryBlue,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Memuat Komunitas...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: primaryDarkBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicErrorState(FriendsProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: errorRed.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: errorRed,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Gagal Memuat Data',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: primaryDarkBlue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              provider.error ?? 'Terjadi kesalahan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: neutralGray,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: primaryBlue.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: provider.loadSuggestedFriends,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Coba Lagi',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAcademicFriendsSection(
    String title,
    List<Friend> friends,
    FriendsProvider provider, {
    required bool isAdded,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.all(20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index == 0) {
              return _buildSectionHeader(title, friends.length);
            }

            final friendIndex = index - 1;
            if (friendIndex >= friends.length) return null;

            final friend = friends[friendIndex];
            return _AcademicFriendCard(
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

  Widget _buildSectionHeader(String title, int count) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.groups_rounded,
              color: primaryBlue,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            // FIX: Added Expanded to prevent overflow
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: primaryDarkBlue,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: primaryBlue,
              ),
            ),
          ),
        ],
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

class _AcademicFriendCard extends StatelessWidget {
  final Friend friend;
  final bool isAdded;
  final VoidCallback onTap;
  final VoidCallback onAddRemove;

  const _AcademicFriendCard({
    required this.friend,
    required this.isAdded,
    required this.onTap,
    required this.onAddRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // FIX: Changed to start
              children: [
                // Profile Avatar
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isAdded
                          ? [successGreen, secondaryTeal]
                          : [primaryBlue, secondaryCyan],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundImage: CachedNetworkImageProvider(friend.picture),
                    backgroundColor: Colors.grey[300],
                    onBackgroundImageError: (exception, stackTrace) =>
                        Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person_rounded,
                        size: 20,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // User Info - FIXED: Added Expanded and proper constraints
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Text(
                        friend.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Email
                      Text(
                        friend.email,
                        style: TextStyle(
                          fontSize: 14,
                          color: neutralGray,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Location
                      Row(
                        children: [
                          Icon(Icons.location_on_rounded,
                              size: 12, color: neutralGray),
                          const SizedBox(width: 4),
                          Expanded(
                            // FIX: Added Expanded for location text
                            child: Text(
                              friend.location,
                              style: TextStyle(
                                fontSize: 12,
                                color: neutralGray,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Action Button
                const SizedBox(width: 8), // FIX: Added spacing
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isAdded
                        ? errorRed.withOpacity(0.1)
                        : successGreen.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      isAdded
                          ? Icons.person_remove_rounded
                          : Icons.person_add_rounded,
                      size: 20,
                      color: isAdded ? errorRed : successGreen,
                    ),
                    onPressed: onAddRemove,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
