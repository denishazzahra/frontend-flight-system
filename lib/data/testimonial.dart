class TestimonialItem {
  String? title;
  String? description;
  bool isExpanded;
  TestimonialItem({
    required this.title,
    required this.description,
    this.isExpanded = false,
  });
}

List<TestimonialItem> testimonialList = [
  TestimonialItem(
    title: 'Apa kesan kuliah TPM 2024?',
    description:
        'Jujur, berat karena tugas-tugasnya waktunya sedikit dan kriterianya cukup banyak. Belum lagi mikirin error handling-nya. Belum lagi desainnya. Semoga lulus dan tidak ngulang (aamiin paling kenceng).',
  ),
  TestimonialItem(
    title: 'Hal yang paling membekas dari TPM 2024?',
    description:
        'Waktu baru dikasih kriteria tugas akhir dan bapaknya malah bilang "Doakan semoga saya sanggup membuat 45 soal lagi agar kuisnya genap jadi 100 soal"... Saya doain sebaliknya (maaf pak). Tapi belakangan ini saya lagi punya interest ke flutter, jadi tugas-tugas semua dikerjakan sebaik-baiknya.',
  ),
  TestimonialItem(
    title: 'Apa hal yang disukai dari kuliah TPM 2024?',
    description:
        'Saya bersyukur karena bahasa pemrogramannya dibebaskan, karena ada kelas lain yang wajib pakai kotlin padahal di praktikum diajarinnya flutter (dart). Saya jadi bisa sekalian belajar untuk kuis/responsi sambil ngerjain tugas.',
  ),
  TestimonialItem(
    title: 'Ada pesan untuk perkuliahan TPM 2024?',
    description:
        'Semoga kami semua sekelas bisa dapat nilai yang memuaskan, maaf juga kalo lihat jawaban UTS/UAS nanti agak ngaco soalnya saya gak terlalu pintar menghafal teori.',
  ),
];
