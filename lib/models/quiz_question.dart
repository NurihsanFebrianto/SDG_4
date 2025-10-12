// lib/models/quiz_question.dart

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

class QuizBank {
  static List<QuizQuestion> getQuestions(String babId) {
    switch (babId) {
      // =========================
      // === BAHASA INDONESIA ===
      // =========================
      case 'bi_bab1':
        return [
          QuizQuestion(
            question:
                'Bahasa Indonesia ditetapkan sebagai bahasa persatuan pada peristiwa apa?',
            options: [
              'Kongres Bahasa I',
              'Sumpah Pemuda 1928',
              'Proklamasi 1945',
              'Konferensi Asia Afrika'
            ],
            correctIndex: 1,
            explanation:
                'Bahasa Indonesia lahir secara resmi dalam Sumpah Pemuda 28 Oktober 1928.',
          ),
          QuizQuestion(
            question:
                'Fungsi bahasa sebagai alat pemersatu bangsa disebut fungsi?',
            options: [
              'Interaksional',
              'Regulatoris',
              'Integratif',
              'Instrumental'
            ],
            correctIndex: 2,
            explanation:
                'Bahasa berfungsi integratif sebagai alat pemersatu berbagai suku bangsa.',
          ),
          QuizQuestion(
            question:
                'Fungsi bahasa sebagai alat untuk mengatur perilaku orang lain disebut?',
            options: [
              'Interaksional',
              'Regulatoris',
              'Heuristik',
              'Imajinatif'
            ],
            correctIndex: 1,
            explanation:
                'Fungsi regulatoris digunakan untuk mengatur atau mengontrol perilaku orang lain.',
          ),
          QuizQuestion(
            question: 'Bahasa Indonesia menjadi simbol apa bagi bangsa?',
            options: [
              'Kebanggaan nasional',
              'Kedaulatan ekonomi',
              'Kemandirian politik',
              'Kebebasan sosial'
            ],
            correctIndex: 0,
            explanation: 'Bahasa Indonesia adalah lambang kebanggaan nasional.',
          ),
          QuizQuestion(
            question: 'Tantangan utama bahasa Indonesia di era digital adalah?',
            options: [
              'Minimnya literasi',
              'Pengaruh kosakata asing',
              'Keterbatasan kamus',
              'Pengajaran konvensional'
            ],
            correctIndex: 1,
            explanation:
                'Masuknya istilah asing di media sosial menjadi tantangan dalam menjaga kemurnian bahasa.',
          ),
        ];

      case 'bi_bab2':
        return [
          QuizQuestion(
            question: 'Pedoman ejaan resmi bahasa Indonesia disebut?',
            options: ['EYD', 'PUEBI', 'KBBI', 'PBI'],
            correctIndex: 1,
            explanation:
                'PUEBI (Pedoman Umum Ejaan Bahasa Indonesia) digunakan sejak revisi EYD.',
          ),
          QuizQuestion(
            question: 'Kata depan “di” ditulis terpisah jika?',
            options: [
              'Berfungsi sebagai awalan',
              'Menunjukkan tempat',
              'Digabung dengan kata kerja',
              'Bersifat pasif'
            ],
            correctIndex: 1,
            explanation:
                '“di” dipisah jika menunjukkan tempat, misalnya: di rumah, di sekolah.',
          ),
          QuizQuestion(
            question: 'Kata “dimakan” termasuk contoh?',
            options: ['Kata depan', 'Imbuhan di-', 'Kata majemuk', 'Serapan'],
            correctIndex: 1,
            explanation:
                'Imbuhan di- digunakan pada kata kerja pasif seperti “dimakan”.',
          ),
          QuizQuestion(
            question: 'Tanda koma digunakan untuk?',
            options: [
              'Memisahkan klausa utama',
              'Menandai akhir kalimat',
              'Menandai pertanyaan',
              'Mengganti titik dua'
            ],
            correctIndex: 0,
            explanation:
                'Tanda koma digunakan untuk memisahkan unsur atau klausa dalam kalimat majemuk.',
          ),
          QuizQuestion(
            question: 'Kesalahan umum dalam ejaan sering terjadi pada?',
            options: [
              'Huruf kapital',
              'Huruf miring',
              'Huruf tebal',
              'Huruf fonetik'
            ],
            correctIndex: 0,
            explanation:
                'Banyak orang masih salah menggunakan huruf kapital, misalnya pada nama diri.',
          ),
        ];

      case 'bi_bab3':
        return [
          QuizQuestion(
            question: 'Kalimat efektif harus memiliki?',
            options: [
              'Kata kerja aktif saja',
              'Subjek dan predikat jelas',
              'Kata sifat dominan',
              'Kalimat panjang'
            ],
            correctIndex: 1,
            explanation:
                'Ciri utama kalimat efektif adalah memiliki subjek dan predikat yang jelas.',
          ),
          QuizQuestion(
            question:
                'Kalimat “Saya datang untuk memberikan laporan” termasuk contoh?',
            options: [
              'Kalimat tidak efektif',
              'Kalimat efektif',
              'Kalimat majemuk bertingkat',
              'Kalimat seru'
            ],
            correctIndex: 1,
            explanation:
                'Struktur kalimat jelas dan hemat, memenuhi ciri kalimat efektif.',
          ),
          QuizQuestion(
            question: 'Kehematan kata berarti?',
            options: [
              'Mengulang kata penting',
              'Menghindari kata berlebihan',
              'Menambahkan konjungsi',
              'Menghapus subjek'
            ],
            correctIndex: 1,
            explanation:
                'Kalimat hemat menghindari pengulangan kata yang tidak perlu.',
          ),
          QuizQuestion(
            question:
                'Kalimat “Dengan demikian maka dari itu…” termasuk contoh?',
            options: [
              'Kalimat efektif',
              'Kalimat berlebihan',
              'Kalimat pasif',
              'Kalimat majemuk'
            ],
            correctIndex: 1,
            explanation:
                'Kalimat tersebut tidak efektif karena mengandung pengulangan makna.',
          ),
          QuizQuestion(
            question: 'Fungsi kalimat efektif dalam komunikasi?',
            options: [
              'Menghias tulisan',
              'Menyampaikan pesan secara jelas',
              'Membingungkan pembaca',
              'Meningkatkan panjang tulisan'
            ],
            correctIndex: 1,
            explanation:
                'Kalimat efektif memastikan pesan dipahami dalam sekali baca.',
          ),
        ];

      case 'bi_bab4':
        return [
          QuizQuestion(
            question: 'Ciri utama paragraf yang baik adalah?',
            options: [
              'Pendek',
              'Mengandung banyak ide',
              'Padu dan utuh',
              'Berisi kalimat acak'
            ],
            correctIndex: 2,
            explanation: 'Paragraf harus memiliki kepaduan dan kesatuan ide.',
          ),
          QuizQuestion(
            question: 'Kalimat utama paragraf deduktif terletak di?',
            options: [
              'Awal paragraf',
              'Akhir paragraf',
              'Tengah',
              'Tidak tentu'
            ],
            correctIndex: 0,
            explanation:
                'Paragraf deduktif memiliki kalimat utama di awal paragraf.',
          ),
          QuizQuestion(
            question: 'Fungsi paragraf dalam teks adalah?',
            options: [
              'Membuat teks lebih panjang',
              'Membagi ide agar mudah dipahami',
              'Menghias tulisan',
              'Menambah kalimat'
            ],
            correctIndex: 1,
            explanation:
                'Paragraf membagi ide menjadi bagian logis agar mudah dibaca.',
          ),
          QuizQuestion(
            question: 'Kepaduan paragraf dapat dicapai dengan?',
            options: [
              'Pengulangan topik',
              'Kata transisi dan kata ganti',
              'Kalimat acak',
              'Kata tanya'
            ],
            correctIndex: 1,
            explanation:
                'Kepaduan dicapai melalui transisi dan pengulangan kata kunci.',
          ),
          QuizQuestion(
            question: 'Paragraf induktif memiliki kalimat utama di?',
            options: ['Awal', 'Akhir', 'Tengah', 'Kedua-duanya'],
            correctIndex: 1,
            explanation:
                'Paragraf induktif menyajikan kalimat utama di akhir paragraf.',
          ),
        ];

      case 'bi_bab5':
        return [
          QuizQuestion(
            question: 'Tujuan utama teks deskripsi adalah?',
            options: [
              'Menggambarkan objek secara rinci',
              'Menceritakan kejadian',
              'Meyakinkan pembaca',
              'Menganalisis fakta'
            ],
            correctIndex: 0,
            explanation:
                'Deskripsi bertujuan menggambarkan objek agar pembaca bisa membayangkannya.',
          ),
          QuizQuestion(
            question: 'Struktur teks deskripsi terdiri dari?',
            options: [
              'Orientasi, komplikasi, resolusi',
              'Identifikasi, deskripsi bagian, penutup',
              'Tesis, argumentasi, simpulan',
              'Abstrak dan evaluasi'
            ],
            correctIndex: 1,
            explanation:
                'Struktur teks deskripsi adalah identifikasi, deskripsi bagian, dan penutup.',
          ),
          QuizQuestion(
            question: 'Ciri khas teks deskripsi adalah penggunaan?',
            options: [
              'Kata sifat dan sensoris',
              'Kata kerja pasif',
              'Kata abstrak',
              'Kata penghubung'
            ],
            correctIndex: 0,
            explanation:
                'Teks deskripsi banyak menggunakan kata sifat dan sensoris.',
          ),
          QuizQuestion(
            question: 'Deskripsi spasial menggambarkan?',
            options: [
              'Proses waktu',
              'Ruang/tempat',
              'Perasaan penulis',
              'Dialog tokoh'
            ],
            correctIndex: 1,
            explanation:
                'Deskripsi spasial menggambarkan tempat atau ruang secara detail.',
          ),
          QuizQuestion(
            question: 'Deskripsi subjektif menonjolkan?',
            options: [
              'Data objektif',
              'Perasaan pribadi penulis',
              'Fakta ilmiah',
              'Angka dan statistik'
            ],
            correctIndex: 1,
            explanation:
                'Deskripsi subjektif menonjolkan kesan pribadi penulis terhadap objek.',
          ),
        ];

      // =========================
      // === BAHASA INGGRIS ===
      // =========================
      case 'en_ch1':
        return [
          QuizQuestion(
            question: 'English became a global lingua franca because?',
            options: [
              'It is easy to learn',
              'It connects people worldwide',
              'It replaced Latin',
              'It is used only in business'
            ],
            correctIndex: 1,
            explanation:
                'English connects people of different nations as a common communication language.',
          ),
          QuizQuestion(
            question: 'Old English mainly came from?',
            options: ['Latin', 'Germanic tribes', 'French', 'Greek'],
            correctIndex: 1,
            explanation:
                'Old English developed from Germanic roots brought by Anglo-Saxons.',
          ),
          QuizQuestion(
            question: 'Most scientific publications are written in?',
            options: ['French', 'English', 'German', 'Chinese'],
            correctIndex: 1,
            explanation:
                'English dominates academic and research publications worldwide.',
          ),
          QuizQuestion(
            question: 'To improve speaking skills, one should?',
            options: [
              'Read grammar books',
              'Listen passively',
              'Practice regularly',
              'Avoid mistakes'
            ],
            correctIndex: 2,
            explanation:
                'Fluency comes from consistent practice, even with mistakes.',
          ),
          QuizQuestion(
            question: 'Present day English is influenced by?',
            options: ['Only Latin', 'French and Latin', 'Sanskrit', 'Arabic'],
            correctIndex: 1,
            explanation:
                'French and Latin heavily influenced vocabulary and structure of English.',
          ),
        ];

      case 'en_ch2':
        return [
          QuizQuestion(
            question: 'Which of the following is a verb?',
            options: ['Run', 'Fast', 'Quickly', 'Happy'],
            correctIndex: 0,
            explanation: '"Run" is a verb because it describes an action.',
          ),
          QuizQuestion(
            question: 'Adjective is used to describe?',
            options: ['Verb', 'Noun', 'Adverb', 'Preposition'],
            correctIndex: 1,
            explanation: 'Adjectives describe nouns, e.g., “beautiful girl”.',
          ),
          QuizQuestion(
            question: 'The plural of "child" is?',
            options: ['Childs', 'Children', 'Childes', 'Childrens'],
            correctIndex: 1,
            explanation: 'Irregular plural form of “child” is “children”.',
          ),
          QuizQuestion(
            question: 'Which word is an adverb?',
            options: ['Quickly', 'Quick', 'Quicker', 'Quickest'],
            correctIndex: 0,
            explanation: 'Adverbs modify verbs, e.g., “run quickly”.',
          ),
          QuizQuestion(
            question: 'The opposite of "polite" is?',
            options: ['Angry', 'Cruel', 'Rude', 'Cold'],
            correctIndex: 2,
            explanation: '“Rude” means impolite or having bad manners.',
          ),
        ];

      case 'en_ch3':
        return [
          QuizQuestion(
            question:
                'The sentence "I have eaten breakfast" is in which tense?',
            options: [
              'Past Simple',
              'Present Perfect',
              'Past Continuous',
              'Future Simple'
            ],
            correctIndex: 1,
            explanation:
                '“Have eaten” shows Present Perfect tense: an action done but relevant to now.',
          ),
          QuizQuestion(
            question: 'Which sentence is correct?',
            options: [
              'He go to school',
              'He goes to school',
              'He going to school',
              'He gone to school'
            ],
            correctIndex: 1,
            explanation: 'Present simple tense for he/she/it uses “goes”.',
          ),
          QuizQuestion(
            question: 'Past tense of “teach” is?',
            options: ['Teached', 'Teacht', 'Taught', 'Teach'],
            correctIndex: 2,
            explanation: '“Teach” becomes “taught” in past tense.',
          ),
          QuizQuestion(
            question: 'Future tense uses which auxiliary?',
            options: ['Was', 'Will', 'Had', 'Have'],
            correctIndex: 1,
            explanation: 'Future tense uses “will” before the base verb.',
          ),
          QuizQuestion(
            question: 'Choose the correct form: “They ___ playing football.”',
            options: ['is', 'am', 'are', 'be'],
            correctIndex: 2,
            explanation:
                'Plural subject “they” uses “are” in continuous tense.',
          ),
        ];

      case 'en_ch4':
        return [
          QuizQuestion(
            question: 'Which is a compound sentence?',
            options: [
              'I wanted to go, but it was raining.',
              'Because it rained, I stayed home.',
              'Although tired, he worked.',
              'If it rains, we cancel.'
            ],
            correctIndex: 0,
            explanation:
                'Compound sentences link two main clauses with conjunctions like “but”.',
          ),
          QuizQuestion(
            question: 'Complex sentences have?',
            options: [
              'Only one clause',
              'Two independent clauses',
              'One main and one dependent clause',
              'No clause'
            ],
            correctIndex: 2,
            explanation:
                'Complex sentences contain one main and one or more dependent clauses.',
          ),
          QuizQuestion(
            question: 'The conjunction “although” shows?',
            options: ['Contrast', 'Addition', 'Reason', 'Result'],
            correctIndex: 0,
            explanation: '“Although” indicates contrast between two ideas.',
          ),
          QuizQuestion(
            question: 'The sentence “She runs and sings” is?',
            options: ['Compound', 'Simple', 'Complex', 'Fragment'],
            correctIndex: 1,
            explanation:
                'It has one subject and two verbs — still a simple sentence.',
          ),
          QuizQuestion(
            question: '“Because”, “when”, and “if” are examples of?',
            options: [
              'Coordinating conjunctions',
              'Subordinating conjunctions',
              'Interjections',
              'Prepositions'
            ],
            correctIndex: 1,
            explanation: 'They connect dependent clauses to main clauses.',
          ),
        ];

      case 'en_ch5':
        return [
          QuizQuestion(
            question: 'Descriptive text is mainly written in?',
            options: [
              'Present Tense',
              'Past Tense',
              'Future Tense',
              'Continuous Tense'
            ],
            correctIndex: 0,
            explanation:
                'Descriptive text uses simple present tense for general facts.',
          ),
          QuizQuestion(
            question: 'Purpose of descriptive text is?',
            options: [
              'Tell a story',
              'Describe person/place/object',
              'Persuade reader',
              'Report event'
            ],
            correctIndex: 1,
            explanation: 'It aims to describe an object or place vividly.',
          ),
          QuizQuestion(
            question: 'The sentence “The sky is blue” describes?',
            options: ['Action', 'Color', 'Emotion', 'Reason'],
            correctIndex: 1,
            explanation: 'Descriptive texts often use adjectives like “blue”.',
          ),
          QuizQuestion(
            question: 'Common adjectives used in descriptive text are?',
            options: [
              'Beautiful, tall, wide',
              'Run, jump, eat',
              'Quickly, happily',
              'Is, are, was'
            ],
            correctIndex: 0,
            explanation: 'Descriptive texts rely heavily on adjectives.',
          ),
          QuizQuestion(
            question: 'Generic structure of descriptive text?',
            options: [
              'Orientation – Events – Reorientation',
              'Identification – Description',
              'Goal – Materials – Steps',
              'Thesis – Arguments – Conclusion'
            ],
            correctIndex: 1,
            explanation:
                'Descriptive text has Identification and Description structure.',
          ),
        ];

      // =========================
      // === BIOLOGI ===
      // =========================
      case 'bio_bab1':
        return [
          QuizQuestion(
            question: 'Biologi mempelajari tentang?',
            options: [
              'Makhluk hidup',
              'Benda mati',
              'Energi listrik',
              'Reaksi kimia'
            ],
            correctIndex: 0,
            explanation:
                'Biologi adalah ilmu tentang makhluk hidup dan kehidupannya.',
          ),
          QuizQuestion(
            question: 'Ciri utama makhluk hidup adalah?',
            options: [
              'Dapat diam saja',
              'Bernapas, tumbuh, berkembang biak',
              'Tidak bereaksi',
              'Berubah warna'
            ],
            correctIndex: 1,
            explanation:
                'Ciri hidup mencakup bernapas, tumbuh, dan berkembang biak.',
          ),
          QuizQuestion(
            question: 'Cabang biologi yang mempelajari hewan disebut?',
            options: ['Botani', 'Zoologi', 'Mikrobiologi', 'Anatomi'],
            correctIndex: 1,
            explanation: 'Zoologi berasal dari kata “zoo” berarti hewan.',
          ),
          QuizQuestion(
            question: 'Objek kajian biologi adalah?',
            options: [
              'Planet dan bintang',
              'Makhluk hidup dan lingkungannya',
              'Reaksi kimia',
              'Fungsi matematika'
            ],
            correctIndex: 1,
            explanation:
                'Objek biologi mencakup makhluk hidup serta hubungannya dengan lingkungan.',
          ),
          QuizQuestion(
            question: 'Biologi modern berkembang pesat karena?',
            options: [
              'Penemuan mikroskop',
              'Revolusi industri',
              'Ekspansi wilayah',
              'Pertanian'
            ],
            correctIndex: 0,
            explanation:
                'Mikroskop membuat manusia bisa mengamati sel dan jaringan makhluk hidup.',
          ),
        ];

      case 'bio_bab2':
        return [
          QuizQuestion(
            question: 'Sel adalah?',
            options: [
              'Satuan terkecil kehidupan',
              'Makhluk hidup terbesar',
              'Atom penyusun air',
              'Zat energi'
            ],
            correctIndex: 0,
            explanation:
                'Sel merupakan unit struktural dan fungsional terkecil kehidupan.',
          ),
          QuizQuestion(
            question: 'Siapa penemu sel pertama kali?',
            options: [
              'Robert Hooke',
              'Charles Darwin',
              'Gregor Mendel',
              'Louis Pasteur'
            ],
            correctIndex: 0,
            explanation:
                'Robert Hooke menemukan sel pada tahun 1665 melalui mikroskop sederhana.',
          ),
          QuizQuestion(
            question: 'Sel prokariotik tidak memiliki?',
            options: [
              'Nukleus sejati',
              'Dinding sel',
              'Membran plasma',
              'Ribosom'
            ],
            correctIndex: 0,
            explanation:
                'Prokariotik tidak memiliki inti sejati (nukleus bermembran).',
          ),
          QuizQuestion(
            question: 'Contoh organisme prokariotik adalah?',
            options: ['Bakteri', 'Jamur', 'Alga', 'Manusia'],
            correctIndex: 0,
            explanation:
                'Bakteri termasuk sel prokariotik karena tanpa inti sejati.',
          ),
          QuizQuestion(
            question: 'Organel yang menghasilkan energi adalah?',
            options: ['Nukleus', 'Mitokondria', 'Ribosom', 'Lisosom'],
            correctIndex: 1,
            explanation:
                'Mitokondria berfungsi menghasilkan energi (ATP) melalui respirasi sel.',
          ),
        ];

      case 'bio_bab3':
        return [
          QuizQuestion(
            question: 'Jaringan pada tumbuhan yang mengangkut air adalah?',
            options: ['Floem', 'Xilem', 'Parenkim', 'Epidermis'],
            correctIndex: 1,
            explanation: 'Xilem mengangkut air dan mineral dari akar ke daun.',
          ),
          QuizQuestion(
            question: 'Fungsi floem adalah?',
            options: [
              'Mengangkut hasil fotosintesis',
              'Mengangkut air',
              'Menyimpan lemak',
              'Menopang batang'
            ],
            correctIndex: 0,
            explanation:
                'Floem membawa hasil fotosintesis ke seluruh bagian tumbuhan.',
          ),
          QuizQuestion(
            question: 'Jaringan dasar pada tumbuhan disebut?',
            options: ['Parenkim', 'Sklerenkim', 'Xilem', 'Kolenkim'],
            correctIndex: 0,
            explanation:
                'Parenkim berfungsi menyimpan cadangan makanan dan melakukan fotosintesis.',
          ),
          QuizQuestion(
            question: 'Jaringan penyokong tumbuhan adalah?',
            options: [
              'Kolenkim dan Sklerenkim',
              'Epidermis dan Xilem',
              'Floem dan Parenkim',
              'Meristem dan Kambium'
            ],
            correctIndex: 0,
            explanation:
                'Kolenkim dan sklerenkim berfungsi memperkuat tubuh tumbuhan.',
          ),
          QuizQuestion(
            question: 'Jaringan pelindung disebut?',
            options: ['Parenkim', 'Epidermis', 'Xilem', 'Kloroplas'],
            correctIndex: 1,
            explanation:
                'Epidermis melindungi jaringan di bawahnya dari kehilangan air dan infeksi.',
          ),
        ];

      case 'bio_bab4':
        return [
          QuizQuestion(
            question: 'Proses fotosintesis menghasilkan?',
            options: [
              'Oksigen dan glukosa',
              'Karbon dioksida dan air',
              'Protein dan lemak',
              'Mineral dan nitrogen'
            ],
            correctIndex: 0,
            explanation: 'Fotosintesis menghasilkan glukosa dan oksigen.',
          ),
          QuizQuestion(
            question: 'Organ tempat fotosintesis berlangsung adalah?',
            options: ['Akar', 'Daun', 'Batang', 'Bunga'],
            correctIndex: 1,
            explanation:
                'Fotosintesis terjadi di daun karena mengandung kloroplas.',
          ),
          QuizQuestion(
            question: 'Pigmen utama fotosintesis adalah?',
            options: ['Klorofil', 'Melanin', 'Karoten', 'Hemoglobin'],
            correctIndex: 0,
            explanation:
                'Klorofil menyerap energi cahaya matahari untuk fotosintesis.',
          ),
          QuizQuestion(
            question: 'Fotosintesis membutuhkan?',
            options: [
              'Air, CO₂, dan cahaya',
              'Nitrogen, udara, tanah',
              'Lemak, protein',
              'Mineral, vitamin'
            ],
            correctIndex: 0,
            explanation:
                'Tiga bahan utama fotosintesis: air, karbon dioksida, dan cahaya.',
          ),
          QuizQuestion(
            question: 'Faktor yang memengaruhi fotosintesis?',
            options: [
              'Cahaya, suhu, dan kadar CO₂',
              'Warna daun',
              'Jenis tanah',
              'Bentuk batang'
            ],
            correctIndex: 0,
            explanation:
                'Fotosintesis dipengaruhi oleh intensitas cahaya, suhu, dan kadar CO₂.',
          ),
        ];

      case 'bio_bab5':
        return [
          QuizQuestion(
            question: 'Otot yang bekerja secara sadar disebut?',
            options: [
              'Otot lurik',
              'Otot polos',
              'Otot jantung',
              'Otot refleks'
            ],
            correctIndex: 0,
            explanation:
                'Otot lurik bekerja di bawah kendali sadar dan melekat pada rangka.',
          ),
          QuizQuestion(
            question: 'Otot polos ditemukan di?',
            options: ['Usus dan pembuluh darah', 'Tulang', 'Kulit', 'Jantung'],
            correctIndex: 0,
            explanation:
                'Otot polos bekerja tanpa kesadaran di organ dalam tubuh.',
          ),
          QuizQuestion(
            question: 'Otot jantung memiliki ciri?',
            options: [
              'Bekerja sadar',
              'Bentuk lurik dan bercabang',
              'Menempel di tulang',
              'Dikendalikan otak besar'
            ],
            correctIndex: 1,
            explanation:
                'Otot jantung bercabang, bekerja terus menerus tanpa lelah.',
          ),
          QuizQuestion(
            question: 'Sistem otot berfungsi untuk?',
            options: [
              'Gerak tubuh',
              'Mengatur hormon',
              'Mengangkut oksigen',
              'Melindungi DNA'
            ],
            correctIndex: 0,
            explanation: 'Otot memungkinkan gerakan tubuh dan postur.',
          ),
          QuizQuestion(
            question: 'Gangguan pada otot disebut?',
            options: ['Kram', 'Infeksi', 'Demam', 'Asma'],
            correctIndex: 0,
            explanation:
                'Kram adalah gangguan kontraksi otot yang tidak terkontrol.',
          ),
        ];

      default:
        return [];
    }
  }
}
