#import "@preview/icu-datetime:0.1.2": fmt-date

#set text(
  size: 12pt,
  font: "Times New Roman",
  lang: "id",
)


#set page(
  margin: 1in
)

#set page(numbering: none)

#let title = "Cheatshield: Face Detection System for Online Learning Platforms"
#let author1 = "Al Azhar Rizqi Rifa'i Firdaus"
#let author2 = "Dicha Zelianivan Arkana"
#let author3 = "Muhammad Baihaqi Aulia Asy'ari"
#let nim1 = 2241720263
#let nim2 = 2241720002
#let nim3 = 2241720145
#let validationDate = datetime(
  year: 2024, 
  month: 12, 
  day: 20
)

#let fullDate = fmt-date(
  validationDate,
  locale: "id",
  length: "long"
)

#let dosenMK1 = "Dian Hanifudin Subhi, S.Kom., M.Kom"
#let nipDosenMK1 = "19880610 201903 1 018"

#let dosenMK2 = "Vipkas Al Hadid Firdaus, ST,. MT"
#let nipDosenMK2 = "19910505 201903 1 029"

#let dosenMK3 = "Dr. Eng. Rosa Andrie A. ST., MT.,"
#let nipDosenMK3 = "19801010 200501 1 001"

#let dosenMK4 = "Farida Ulfa, S.Pd., M,Pd."
#let nipDosenMK4 = "0014048005"

#let dosenMK5 = "Vipkas Al Hadid Firdaus, ST,. MT"
#let nipDosenMK5 = "19910505 201903 1 029"

#let ketuaJurusan = "Dr. Eng. Rosa Andrie A. ST., MT.,"
#let nipKetuaJurusan = "19801010 200501 1 001"

#let ketuaProgramStudi = "Dr Ely Setyo Astuti, S.T., M.T."
#let nipKetuaProgramStudi = "19760515 200912 2 001"

#set par(
  first-line-indent: 1em,
)

#show heading: set align(center)
#show heading: set text(14pt)
#set heading(
  numbering: "1.1."
)

#align(
  center + horizon,
  stack(
    text(12pt)[
      *LAPORAN AKHIR \ \
      _PROJECT BASED LEARNING_ (PBL) \ \
      #upper[#title]*
    ],
    v(10fr),
    image("polinema-logo.png", width: 4.3cm),
    v(5em),
    text(12pt)[
      Disusun oleh:
    ],
    v(1em),
    table(
      columns: 2,
      stroke: none,
      align: top + left,
      [*#author1*], [*NIM. #nim1*],
      [*#author2*], [*NIM. #nim2*],
      [*#author3*], [*NIM. #nim3*],
    ),
    v(10fr),
    text(12pt)[
      *JURUSAN TEKNOLOGI INFORMASI* \
      *D4 TEKNIK INFORMATIKA* \
      *POLITEKNIK NEGERI MALANG* \
      *#validationDate.display("[year]")*
    ]
  ),
)

#pagebreak()

#align(
  center + horizon,
  stack(
    [*#heading()[
      LEMBAR PENGESAHAN LAPORAN AKHIR _PBL_
    ]*],
    v(3em),
    text(14pt)[
      *#title*
    ],
    v(1fr),
    text(12pt)[
      Disusun oleh:
    ],
    v(1em),
    table(
      columns: 2,
      stroke: none,
      align: top + left,
      [#author1], [NIM. #nim1],
      [#author2], [NIM. #nim2],
      [#author3], [NIM. #nim3],
    ),
    v(1fr),
    text(12pt)[
      Telah diseminasikan pada tanggal  #fullDate
    ],
    v(1fr),
    text(12pt)[
      Disetujui oleh: \ \
      #table(
        columns: (auto, auto, auto, auto, auto),
        align: top + left,
        stroke: none,
        row-gutter: 1em,
        [1.], [Pemrogaman \ Mobile], [:], [#underline[#dosenMK1]\ NIP. #nipDosenMK1], [\ .................],
        [2.], [Pembelajaran \ Mesin], [:], [#underline[#dosenMK2]\ NIP. #nipDosenMK2], [\ .................],
        [3.], [Pengolahan \ Citra dan Visi \ Komputer], [:], [#underline[#dosenMK3]\ NIP. #nipDosenMK3], [\ .................],
        [4.], [Bahasa Inggris \ Persiapan Kerja], [:], [#underline[#dosenMK4]\ NIP. #nipDosenMK4], [\ .................],
        [5.], [Administrasi\ dan Keamanan \ Jaringan], [:], [#underline[#dosenMK5]\ NIP. #nipDosenMK5], [\ .................],
      ) 
    ],
    v(1fr),
    [Mengetahui,],
    v(1fr),
    table(
      columns: (50%, 50%),
      align: horizon + center,
      stroke: none,
      [Ketua Jurusan \ Teknologi Informasi],
      [Ketua Program Studi \ D4 Teknik Informatika],
      v(5em),
      v(5em),
      [#underline[#ketuaJurusan] \ NIP. #nipKetuaJurusan],
      [#underline[#ketuaProgramStudi] \ NIP. #nipKetuaProgramStudi ],
    )
  )
)

#pagebreak()

#heading()[DAFTAR ISI]
#outline(
  title: none,
  indent: true,
)

#pagebreak()

#heading()[DAFTAR GAMBAR] 
#outline(
  title: none,
  target: figure.where(kind: image)
)

#pagebreak()

#heading()[DAFTAR TABEL]
#outline(
  title: none,
  target: figure.where(kind: table)
)

#pagebreak()
= Ringkasan Eksekutif

#pagebreak()
= Pendahuluan
== Latar Belakang
== Rumusan Masalah
== Tujuan Proyek
== Ruang Lingkup Proyek

#pagebreak()
= Project Charter
== Deskripsi Proyek
== Tujuan dan Sasaran
== Ruang Lingkup
== Pemangku Kepentingan
== Success Criteria 

#pagebreak()
= Spesifikasi Kebutuhan Perangkat Lunak (SKPL)
== Kebutuhan Fungsional
== Kebutuhan Non-Fungsional
== Diagram Pendukung (UML, DFD, ERD, dll.)

#pagebreak()
= Perencanaan Proyek
== Jadwal Proyek (misalnya, Diagram Gantt)
== Pembagian Tugas
== Sumber Daya dan Anggaran 

#pagebreak()
= Implementasi Proyek
== Langkah-langkah Pelaksanaan
== Teknologi atau Metode yang Digunakan
== Tantangan dan Solusi

#pagebreak()
= Dokumen Hasil Pengujian
== Metode Pengujian
== Hasil Pengujian (laporan bug, tingkat keberhasilan, dll.)
== Evaluasi Terhadap Spesifikasi

#pagebreak()
= Panduan Pengguna
== Petunjuk Instalasi (jika ada)
== Cara Penggunaan
== Pemecahan Masalah  

#pagebreak()
= Kesimpulan dan Rekomendasi
== Kesimpulan tentang keberhasilan proyek
== Rekomendasi untuk pengembangan lebih lanjut  

#pagebreak()
= Referensi atau Daftar Pustaka

#pagebreak()
= Lampiran