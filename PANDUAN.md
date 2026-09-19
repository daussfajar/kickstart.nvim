# Panduan Neovim ala VS Code

Konfigurasi ini adalah [kickstart.nvim](README.md) yang ditambahi tampilan dan
shortcut ala VS Code. Ada sidebar explorer, tab, terminal di bawah, breadcrumbs,
multi-cursor, dan shortcut seperti Ctrl+S, Ctrl+P, Ctrl+/. Semua perintah Vim
biasa tetap bisa dipakai.

---

## 1. Persiapan (cukup sekali)

### a. Install program yang dibutuhkan

```sh
sudo pacman -S tree-sitter-cli wl-clipboard lazygit
```

| Paket | Untuk apa | Wajib? |
| :-- | :-- | :-- |
| `tree-sitter-cli` | Warna syntax (syntax highlighting) yang bagus | **Ya** |
| `wl-clipboard` | Copy/paste ke clipboard sistem (Wayland/GNOME) | **Ya** |
| `lazygit` | Tampilan Git lengkap (seperti tab Source Control) | Opsional |

Program lain yang dibutuhkan (`git`, `gcc`, `make`, `ripgrep`, `fd`, `node`,
`npm`, `go`, `php`) sudah terpasang di laptop kamu.

### b. Atur terminal Alacritty

Pakai **Alacritty**, jangan terminal bawaan VS Code, karena VS Code akan "memakan"
shortcut seperti Ctrl+P dan Ctrl+B sebelum sampai ke Neovim.

Buat file `~/.config/alacritty/alacritty.toml`:

```toml
[font]
normal = { family = "MesloLGM Nerd Font Mono" }
size = 12

[keyboard]
bindings = [
  # Biar Ctrl+Shift+F (cari di semua file) diteruskan ke Neovim,
  # bukan membuka fitur search milik Alacritty
  { key = "F", mods = "Control|Shift", action = "ReceiveChar" },
]
```

Font Nerd Font dibutuhkan supaya ikon file dan folder tampil (bukan kotak-kotak).
Font Meslo sudah terpasang di sistem kamu.

### c. Lokasi konfigurasi

Neovim membaca konfigurasi dari `~/.config/nvim`. Folder itu sudah dibuat sebagai
*symlink* ke repo ini:

```sh
ln -s ~/Documents/Fajar/config/kickstart.nvim ~/.config/nvim   # sudah dilakukan
```

Jadi semua perubahan di repo ini langsung dipakai oleh Neovim.

### d. Membuka pertama kali

1. Jalankan `nvim`.
2. Akan muncul pertanyaan `These plugins will be installed ... Proceed?`.
   Tekan **`A`** (Always) supaya semua plugin langsung diinstall.
3. Tunggu sampai selesai. Setelah itu Mason akan menginstall *language server*
   (untuk autocomplete, go to definition, dll.) di belakang layar. Progresnya bisa
   dilihat dengan `:Mason`.
4. Tutup (`Ctrl+Q`) lalu buka lagi Neovim.

Untuk membuka sebuah project: `cd ~/project-saya` lalu `nvim .` (atau `nvim` saja).

---

## 2. Konsep paling penting: Mode

Ini perbedaan terbesar dengan VS Code. Neovim punya beberapa **mode**:

| Mode | Cara masuk | Kegunaan |
| :-- | :-- | :-- |
| **Normal** | `Esc` | Mode awal. Untuk pindah-pindah dan menjalankan perintah. **Menekan huruf di sini tidak mengetik teks!** |
| **Insert** | `i` (sebelum kursor), `a` (sesudah kursor), `o` (baris baru) | Mengetik seperti biasa, seperti di VS Code |
| **Visual** | `v` (per huruf), `V` (per baris), atau drag dengan mouse | Memilih/menyeleksi teks |
| **Command** | `:` | Menjalankan perintah, misal `:w` (simpan) |

Mode yang sedang aktif ditampilkan di status bar bagian bawah kiri.

> **Kalau bingung atau "nyasar": tekan `Esc` beberapa kali**, maka kamu kembali ke Normal mode.

Mouse tetap berfungsi: klik untuk memindah kursor, scroll, drag untuk menyeleksi,
dan klik kanan untuk menu.

### Tombol Leader (Spasi)

Banyak shortcut diawali tombol **Spasi** (disebut *leader*, ditulis `<leader>` atau
`Spasi` di panduan ini). **Tekan Spasi di Normal mode lalu tunggu sebentar**: akan
muncul menu berisi semua shortcut yang tersedia. Ini cara termudah untuk
menemukan fitur.

---

## 3. Tampilan

```
┌──────────────┬─────────────────────────────────────────────┐
│ EXPLORER     │  main.ts  ×  │  app.css  │  index.html       │  ← tab file
│ ▾ src        │  src > main.ts > greet()                    │  ← breadcrumbs
│   main.ts    │                                             │
│   app.css    │   1  function greet(name: string) {         │
│ ▸ public     │   2    return "hi " + name;                 │  ← editor
│   index.html │   3  }                                      │
│              ├─────────────────────────────────────────────┤
│              │ ~/project $ npm run dev                     │  ← terminal
├──────────────┴─────────────────────────────────────────────┤
│ NORMAL │ main  +3 ~1 │ main.ts                  │ 12:5      │  ← status bar
└────────────────────────────────────────────────────────────┘
```

- **Welcome screen**: muncul saat `nvim` dibuka tanpa file. Isinya menu **Start**
  (file baru, buka file, cari, explorer, settings, panduan, update plugin) dan
  daftar **Recent** (file yang terakhir dibuka di folder ini). Cara memilih:
  - tekan tombol di kotak sebelah kiri item, misal `o` untuk *Open File...*
    atau `1` untuk file recent pertama,
  - atau pilih dengan `↑`/`↓` (atau `j`/`k`) lalu `Enter`,
  - atau klik item dengan mouse.

  Tekan `g` di welcome screen untuk membuka panduan ini. Kalau terminal kecil,
  logo disembunyikan otomatis supaya semua menu tetap muat.
- **Tema**: warna "Dark Modern" VS Code.
- **Tanda Git** di kiri nomor baris: `+` baris baru, `~` baris diubah, `_` baris dihapus.

---

## 4. Daftar Shortcut

Shortcut dengan **Ctrl+Shift** (misal Ctrl+Shift+P) berfungsi di Alacritty. Kalau
suatu saat tidak berfungsi (misalnya di terminal lain), pakai kolom *Alternatif*.

### File

| Shortcut | Fungsi | Alternatif |
| :-- | :-- | :-- |
| `Ctrl+S` | Simpan file (bisa juga saat sedang mengetik) | `:w` |
| `Ctrl+N` | File baru. Saat disimpan pertama kali akan ditanya nama filenya | `:enew` |
| `Ctrl+Q` | Keluar Neovim (ditanya dulu kalau ada file yang belum disimpan) | `:qa` |
| `Spasi` `t` `f` | Nyalakan/matikan *Format On Save* | |

### Edit

| Shortcut | Fungsi |
| :-- | :-- |
| `Ctrl+Z` / `Ctrl+Y` | Undo / Redo (di Normal mode juga bisa `u` / `Ctrl+R`) |
| `Ctrl+A` | Pilih semua |
| `Ctrl+C` / `Ctrl+X` | Copy / Cut teks yang diseleksi (ke clipboard sistem) |
| `Ctrl+V` | Paste (di Insert mode). Di Normal mode pakai `p` |
| `Ctrl+Shift+V` | Paste dari terminal (selalu berfungsi, di mode apa pun) |
| `Ctrl+/` | Comment / uncomment baris atau seleksi |
| `Alt+↑` / `Alt+↓` | Pindahkan baris (atau seleksi) ke atas / bawah |
| `Shift+Alt+↑` / `Shift+Alt+↓` | Duplikat baris (atau seleksi) ke atas / bawah |
| `Tab` / `Shift+Tab` | Indent / outdent seleksi |
| `Shift+Alt+F` | Rapikan (format) file |
| `Ctrl+Backspace` | Hapus satu kata ke belakang (Insert mode) |
| `za` | Lipat/buka lipatan kode (*fold*) di posisi kursor |

### Pencarian

| Shortcut | Fungsi | Alternatif |
| :-- | :-- | :-- |
| `Ctrl+P` | Buka file berdasarkan nama (Quick Open) | `Spasi` `s` `f` |
| `Ctrl+Shift+P` atau `F1` | Command palette | `Spasi` `s` `c` |
| `Ctrl+F` | Cari di file ini. Ketik lalu Enter, lalu `n` / `N` ke hasil berikut / sebelumnya | `/` |
| `Ctrl+Shift+F` | Cari teks di semua file | `Spasi` `s` `g` |
| `Ctrl+Shift+H` | Cari & ganti (replace) di semua file | `Spasi` `s` `R` |
| `Spasi` `Spasi` | Pindah ke file yang sedang terbuka | |
| `Spasi` `s` `.` | File yang baru dibuka | |
| `Esc` | Hilangkan highlight hasil pencarian | |

Di jendela pencarian (Telescope): ketik untuk memfilter, `↑`/`↓` untuk memilih,
`Enter` untuk membuka, `Esc` untuk menutup.

### Explorer (sidebar)

| Shortcut | Fungsi |
| :-- | :-- |
| `Ctrl+B` atau `Spasi` `e` | Buka/tutup explorer |
| `Ctrl+Shift+E` atau `\` | Tampilkan file yang sedang dibuka di explorer |

Tombol di **dalam** explorer:

| Tombol | Fungsi |
| :-- | :-- |
| `Enter` / double-click | Buka file / buka-tutup folder |
| `a` | File baru (akhiri dengan `/` untuk membuat folder, misal `components/`) |
| `r` | Rename |
| `d` | Hapus |
| `y` / `x` / `p` | Copy / cut / paste file |
| `s` / `S` | Buka file di split kanan / bawah |
| `H` | Tampilkan/sembunyikan file tersembunyi |
| `/` | Cari file di explorer |
| `?` | Lihat semua tombol |

### Tab

| Shortcut | Fungsi |
| :-- | :-- |
| `Ctrl+PageDown` / `Ctrl+PageUp` | Tab berikutnya / sebelumnya |
| `Shift+L` / `Shift+H` | Tab berikutnya / sebelumnya (lebih cepat diketik) |
| `Alt+1` … `Alt+9` | Lompat ke tab nomor 1–9 |
| `Spasi` `x` | Tutup tab (atau klik `×` / klik tengah pada tab) |
| `Spasi` `X` | Tutup semua tab lain |
| `Ctrl+Shift+PageDown` / `PageUp` | Geser posisi tab |

### Terminal

| Shortcut | Fungsi |
| :-- | :-- |
| ``Ctrl+` `` atau `Ctrl+\` | Buka/tutup terminal di bawah |
| `2` lalu `Ctrl+\` | Buka terminal kedua (angka = nomor terminal) |
| `Esc` `Esc` | Keluar dari mode ketik terminal (untuk scroll/copy). Tekan `i` untuk mengetik lagi |

### Kode (LSP)

Fitur ini aktif di bahasa yang language server-nya terpasang:
JavaScript/TypeScript, HTML, CSS, JSON, Python, Go, PHP, dan Lua.

| Shortcut | Fungsi | Alternatif |
| :-- | :-- | :-- |
| `F12` atau `Ctrl+Klik` | Go to definition | `grd` |
| `Shift+F12` | Cari semua pemakaian (references) | `grr` |
| `Ctrl+F12` | Go to implementation | `gri` |
| `F2` | Rename variabel/fungsi di semua file | `grn` |
| `Ctrl+.` | Quick fix / code action | `Spasi` `c` `a` |
| `K` | Tampilkan dokumentasi (hover) | |
| `Ctrl+Shift+O` | Daftar fungsi/simbol di file ini | `gO` |
| `F8` / `Shift+F8` | Error/warning berikutnya / sebelumnya | `]d` / `[d` |
| `Ctrl+Shift+M` | Daftar semua error/warning (Problems) | `Spasi` `s` `d` |
| `Ctrl+O` | Kembali ke posisi sebelumnya (setelah go to definition) | |

> Alacritty memakai `Ctrl+Shift+O` untuk membuka link, jadi pakai alternatif `gO`.

### Autocomplete

| Tombol | Fungsi |
| :-- | :-- |
| `Tab` atau `Enter` | Terima saran |
| `↑` / `↓` | Pilih saran |
| `Ctrl+Space` | Munculkan saran secara manual |
| `Ctrl+E` | Tutup saran |
| `Tab` / `Shift+Tab` | Setelah snippet dipakai: lompat ke bagian snippet berikut / sebelumnya |

Snippet ala VS Code (misal ketik `log` lalu Tab di JavaScript untuk `console.log()`)
dan Emmet (misal `div.container>ul>li*3` di HTML) sudah tersedia. Tag HTML/JSX
otomatis ditutup dan ikut ter-rename.

### Multi-cursor

| Shortcut | Fungsi |
| :-- | :-- |
| `Ctrl+D` | Pilih kata di bawah kursor. Tekan lagi untuk menambah kata yang sama berikutnya |
| `Ctrl+Shift+L` | Pilih semua kata yang sama sekaligus |
| `Ctrl+↑` / `Ctrl+↓` | Tambah kursor di baris atas / bawah |
| `Alt+Klik` | Tambah kursor di posisi klik |

Setelah kata-katanya terpilih, tekan `c` untuk mengganti semuanya (atau `i` / `a`
untuk mengetik di depan / belakangnya), ketik teks baru, lalu tekan `Esc` dua kali
untuk selesai.

Contoh mengganti nama variabel `name` menjadi `user` di 3 tempat:
`Ctrl+D` `Ctrl+D` `Ctrl+D` → `c` → ketik `user` → `Esc` `Esc`.

### Git

| Shortcut | Fungsi |
| :-- | :-- |
| `Spasi` `g` `g` | Buka Lazygit (stage, commit, push, branch, …) |
| `Spasi` `g` `s` | Daftar file yang berubah |
| `]c` / `[c` | Lompat ke perubahan berikutnya / sebelumnya |
| `Spasi` `h` `p` | Lihat perubahan di baris ini |
| `Spasi` `h` `s` / `Spasi` `h` `r` | Stage / batalkan perubahan di bagian ini |
| `Spasi` `h` `b` | Lihat siapa yang terakhir mengubah baris ini (blame) |

### Jendela (split)

| Shortcut | Fungsi |
| :-- | :-- |
| `Ctrl+H` / `Ctrl+J` / `Ctrl+K` / `Ctrl+L` | Pindah ke jendela kiri / bawah / atas / kanan |
| `:vsplit` / `:split` | Bagi layar kanan-kiri / atas-bawah |
| `Ctrl+W` `q` | Tutup jendela yang aktif |

---

## 5. Perintah Vim yang berguna (Normal mode)

Tidak wajib dihafal, tapi akan membuat kamu jauh lebih cepat. Latihan interaktif
lengkapnya ada di `:Tutor`.

| Perintah | Fungsi |
| :-- | :-- |
| `h` `j` `k` `l` | Kiri, bawah, atas, kanan (panah juga bisa) |
| `w` / `b` | Maju / mundur satu kata |
| `gg` / `G` | Ke awal / akhir file |
| `:42` | Ke baris 42 |
| `dd` / `yy` / `p` | Hapus (cut) baris / copy baris / paste |
| `ciw` | Ganti kata di bawah kursor |
| `ci"` | Ganti isi di dalam tanda kutip |
| `.` | Ulangi perubahan terakhir |
| `:%s/lama/baru/g` | Ganti semua `lama` menjadi `baru` di file ini |

---

## 6. Menyesuaikan konfigurasi

| File | Isi |
| :-- | :-- |
| [`init.lua`](init.lua) | Konfigurasi utama: opsi, tema, pencarian, LSP, format, autocomplete |
| [`lua/custom/keymaps.lua`](lua/custom/keymaps.lua) | Semua shortcut ala VS Code |
| [`lua/custom/plugins/ui.lua`](lua/custom/plugins/ui.lua) | Tab dan breadcrumbs |
| [`lua/custom/plugins/welcome.lua`](lua/custom/plugins/welcome.lua) | Welcome screen (menu, logo, tips) |
| [`lua/custom/plugins/explorer.lua`](lua/custom/plugins/explorer.lua) | Sidebar explorer |
| [`lua/custom/plugins/terminal.lua`](lua/custom/plugins/terminal.lua) | Terminal dan Lazygit |
| [`lua/custom/plugins/editor.lua`](lua/custom/plugins/editor.lua) | Multi-cursor, pindah baris, auto-tag HTML, search & replace |

`Spasi` `s` `n` membuka pencarian file konfigurasi dari dalam Neovim. Setelah
mengubah konfigurasi, tutup lalu buka lagi Neovim.

### Menambah bahasa pemrograman

1. Cari nama server-nya dengan `:Mason` (tekan `/` untuk mencari, misal `rust`).
2. Tambahkan namanya ke tabel `servers` di `init.lua` (bagian *SECTION 6: LSP*),
   misal `rust_analyzer = {},`.
3. Buka ulang Neovim, maka server akan terinstall otomatis.

Warna syntax (treesitter) untuk bahasa baru terinstall otomatis saat kamu membuka
filenya.

### Mengganti tema

- Tema terang VS Code: ubah `style = 'dark'` menjadi `style = 'light'` di `init.lua`.
- Coba tema lain: jalankan `:Telescope colorscheme`. Untuk memakainya secara
  permanen, ganti `vim.cmd.colorscheme 'vscode'` di `init.lua` dengan nama tema
  tersebut (tema bawaan kickstart: `tokyonight-night`).

### Format otomatis saat menyimpan

Mati secara default, seperti di VS Code. Nyalakan sementara dengan `Spasi` `t` `f`.
Supaya selalu menyala, ubah `vim.g.format_on_save = false` menjadi `true` di
`init.lua`. JavaScript/TypeScript/CSS/HTML/JSON/YAML/Markdown dirapikan dengan
Prettier, bahasa lain oleh language server-nya.

---

## 7. Update plugin

Pilih **Update Plugins** di welcome screen (tombol `u`) (atau jalankan `:lua vim.pack.update()`).
Akan muncul daftar perubahan: ketik `:w` untuk menyetujui, atau `:q` untuk batal.

Language server di-update lewat `:Mason`, lalu tekan `U`.

---

## 8. Kalau ada masalah

| Masalah | Solusi |
| :-- | :-- |
| Ikon tampil sebagai kotak/tanda tanya | Pasang Nerd Font di terminal (lihat bagian 1b) |
| Copy/paste tidak nyambung ke aplikasi lain | `sudo pacman -S wl-clipboard` |
| Kode tidak berwarna / error `tree-sitter` | `sudo pacman -S tree-sitter-cli`, lalu buka ulang Neovim |
| Autocomplete / go to definition tidak jalan | Cek `:Mason` (server sudah terinstall?) dan `:checkhealth vim.lsp` |
| Shortcut Ctrl+Shift tidak berfungsi | Pakai alternatifnya (lihat tabel), atau pastikan memakai Alacritty |
| Ingin tahu apa fungsi sebuah tombol | `Spasi` `s` `k` (cari shortcut), atau tekan Spasi dan tunggu |
| Cek semua hal sekaligus | `:checkhealth` |
| Mau mencari bantuan | `Spasi` `s` `h` (cari di dokumentasi Neovim) |
