// import 'package:flutter/material.dart';
// import '../models/progress_model.dart';

// class ProgressListScreen extends StatelessWidget {
//   final List<StudyProgress> progressList;

//   const ProgressListScreen({super.key, required this.progressList});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Detail Progres Belajar',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: progressList.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: progressList.length,
//               itemBuilder: (context, index) {
//                 final progress = progressList[index];
//                 return Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(16),
//                   margin: const EdgeInsets.only(bottom: 16),
//                   decoration: BoxDecoration(
//                     color: Colors.blue[50],
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(color: Colors.blue[100]!),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         progress.subject,
//                         style: const TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 18),
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         '${progress.currentModule} • ${progress.currentLesson}',
//                         style: const TextStyle(color: Colors.black87),
//                       ),
//                       const SizedBox(height: 12),
//                       LinearProgressIndicator(
//                         value: progress.lessonProgress / 100,
//                         minHeight: 8,
//                         backgroundColor: Colors.grey[300],
//                         color: Colors.blue,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         '${progress.lessonProgress}%',
//                         style: const TextStyle(color: Colors.grey),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
