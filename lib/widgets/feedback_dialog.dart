import 'package:flutter/material.dart';
import '../services/feedback_service.dart';

const Color primaryDarkBlue = Color(0xFF0A3D62);
const Color secondaryTeal = Color(0xFF14B8A6);
const Color accentAmber = Color(0xFFFBBF24);
const Color neutralGray = Color(0xFF6B7280);

class FeedbackDialog extends StatefulWidget {
  final String babId;
  final String babNama;
  final int readingDuration;

  const FeedbackDialog({
    super.key,
    required this.babId,
    required this.babNama,
    required this.readingDuration,
  });

  @override
  State<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  final FeedbackService _feedbackService = FeedbackService();
  final TextEditingController _commentController = TextEditingController();
  int _selectedRating = 0;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (_selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon berikan rating terlebih dahulu'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // 🔧 FIX: Tambah print untuk debug
    print('📝 Submitting feedback...');
    print('📝 Rating: $_selectedRating');
    print('📝 Comment: ${_commentController.text.trim()}');
    print('📝 BabId: ${widget.babId}');
    print('📝 Duration: ${widget.readingDuration}');

    try {
      final success = await _feedbackService
          .saveFeedback(
        babId: widget.babId,
        rating: _selectedRating,
        comment: _commentController.text.trim(),
        readingDuration: widget.readingDuration,
      )
          .timeout(
        const Duration(seconds: 10), // 🔧 FIX: Tambah timeout 10 detik
        onTimeout: () {
          print('⏱️ TIMEOUT: Request took too long');
          return false;
        },
      );

      if (!mounted) return;

      setState(() => _isSubmitting = false);

      if (success) {
        Navigator.of(context).pop(true); // Return true = feedback submitted
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Terima kasih atas feedback Anda!'),
            backgroundColor: secondaryTeal,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menyimpan feedback. Coba lagi.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // 🔧 FIX: Catch exception
      print('❌ EXCEPTION in submit: $e');

      if (!mounted) return;

      setState(() => _isSubmitting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: accentAmber.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.feedback_rounded,
                  color: accentAmber,
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                'Bagaimana Materi Ini?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: primaryDarkBlue,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Subtitle
              Text(
                'Anda telah membaca "${widget.babNama}"\nBantu kami meningkatkan kualitas materi',
                style: TextStyle(
                  fontSize: 14,
                  color: neutralGray,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Rating Stars
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starValue = index + 1;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedRating = starValue),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        _selectedRating >= starValue
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        size: 40,
                        color: _selectedRating >= starValue
                            ? accentAmber
                            : Colors.grey.shade300,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),

              // Rating Text
              if (_selectedRating > 0)
                Text(
                  _getRatingText(_selectedRating),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: accentAmber,
                  ),
                ),
              const SizedBox(height: 24),

              // Comment TextField
              TextField(
                controller: _commentController,
                maxLines: 3,
                maxLength: 200,
                decoration: InputDecoration(
                  hintText: 'Ceritakan pengalaman Anda... (opsional)',
                  hintStyle: TextStyle(color: neutralGray),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: secondaryTeal, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSubmitting
                          ? null
                          : () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: neutralGray),
                      ),
                      child: Text(
                        'Lewati',
                        style: TextStyle(
                          color: neutralGray,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitFeedback,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryTeal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Kirim Feedback',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return 'Kurang Memuaskan';
      case 2:
        return 'Perlu Perbaikan';
      case 3:
        return 'Cukup Baik';
      case 4:
        return 'Sangat Baik';
      case 5:
        return 'Luar Biasa!';
      default:
        return '';
    }
  }
}
