# Thai QUICKSETUP Translation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Translate `QUICKSETUP.md` into Thai as the primary language, keeping English as a secondary appendix, so Thai-speaking users can follow the setup end-to-end.

**Architecture:** Single-file doc edit. All prose (headings, descriptions, notes, table text) becomes Thai. Every code block (bash/powershell, command tokens, the Bright Data token placeholder, the `export`/`$env` lines) stays byte-for-byte identical — commands cannot be translated. A full English copy is appended as a `## English version` section so the doc is self-contained for both audiences.

**Tech Stack:** Markdown only. No code, no runtime. Verification is by read-back and a structural grep, not unit tests.

## Global Constraints

- Target file: `QUICKSETUP.md` (repo root). No other files are touched.
- Every code block MUST remain unchanged — only prose is translated. A reviewer should be able to copy any block and get a working command.
- Thai is the primary language for all human-readable text; English appears only in the `## English version` appendix.
- The link `./README.md#quickstart-30-second-setup` and the command `/setup-utarn-skills` stay exactly as-is.
- Keep the existing document structure (sections, the note blockquote, the table) — translate in place, don't reorganize.
- Commit after each task with a conventional commit message.

---

### Task 1: Translate the top half (title, intro, note, Bash, PowerShell)

**Files:**
- Modify: `QUICKSETUP.md:1-71` (everything above the "Bright Data API key" section)

**Interfaces:**
- Consumes: nothing (first task)
- Produces: a Thai-primary doc up through the PowerShell section, with all four code blocks byte-identical to the original

- [ ] **Step 1: Replace the title and intro (lines 1-7)**

Open `QUICKSETUP.md` and replace the block from the `# Quick Setup` heading through the closing `>` note line with this Thai version. Code blocks are unchanged.

```markdown
# การตั้งค่าด่วน (Quick Setup)

เริ่มใช้งาน Claude Code พร้อมเครื่องมือทั้งหมดที่คุณต้องการในขั้นตอนเดียว: ปลั๊กอิน engineer-skills, Context7 สำหรับดึงเอกสารสด, และ Bright Data สำหรับ scraping เว็บ (CLI + skill)

เลือก shell ของคุณแล้วรันบล็อก **install** ครั้งเดียว สิ่งนี้จะให้คู่คำสั่ง `ccc` / `cccc` สำหรับเปิด Claude Code พร้อมฟังก์ชัน `quicksetup` ที่เชื่อมต่อ skills ให้ จากนั้นเพียงพิมพ์ `quicksetup` เพื่อรันได้เลย

> `ccc` และ `cccc` คือ wrapper สะดวกสำหรับ `claude` — ข้ามการขออนุญาตต่อคำสั่งและต่อเซสชันล่าสุด สอดคล้องกับ flow `--dangerously-skip-permissions` ที่เหลือของ repo นี้สันนิษฐานไว้ พวกมันเรียก `claude` โดยตรง จึงทำงานได้กับทุกคน ไม่ใช่แค่ alias ส่วนตัวของผู้เขียน
```

- [ ] **Step 2: Replace the Bash section (lines 9-39)**

Replace the `## Bash (Linux / macOS)` section through its `quicksetup` run block with:

```markdown
## Bash (Linux / macOS)

เพิ่มโค้ดนี้ลงใน `~/.bashrc` (หรือ `~/.zshrc` บน macOS) แล้วเริ่ม shell ใหม่:

```bash
# ตัวเปิด Claude Code แบบสะดวก
ccc()  { claude --dangerously-skip-permissions "$@"; }
cccc() { claude --dangerously-skip-permissions --continue "$@"; }

# ตั้งค่าแบบรอบเดียว: ปลั๊กอิน engineer-skills + Context7 + Bright Data (CLI + skill)
quicksetup() {
  # 1. ปลั๊กอิน engineer-skills
  claude plugin marketplace add utarn/engineer-skills
  claude plugin install utarn-skills@utarn

  # 2. Context7 — เอกสาร library แบบสด
  npx ctx7@latest setup

  # 3. Bright Data — CLI / MCP server (ต้องใช้ API token ดูด้านล่าง)
  claude mcp add brightdata -- npx -y @brightdata/mcp

  # 4. Bright Data — skill surface ภายใน Claude Code
  claude plugin install brightdata-plugin@claude-plugins-official --scope local
}
```

รันคำสั่ง:

```bash
quicksetup
```
```

- [ ] **Step 3: Replace the PowerShell section (lines 41-71)**

Replace the `## PowerShell (Windows)` section through its `quicksetup` run block with:

```markdown
## PowerShell (Windows)

เพิ่มโค้ดนี้ลงในโปรไฟล์ PowerShell ของคุณ (`notepad $PROFILE`) แล้วเปิดเทอร์มินัลใหม่:

```powershell
# ตัวเปิด Claude Code แบบสะดวก
function ccc  { claude --dangerously-skip-permissions @args }
function cccc { claude --dangerously-skip-permissions --continue @args }

# ตั้งค่าแบบรอบเดียว: ปลั๊กอิน engineer-skills + Context7 + Bright Data (CLI + skill)
function quicksetup {
  # 1. ปลั๊กอิน engineer-skills
  claude plugin marketplace add utarn/engineer-skills
  claude plugin install utarn-skills@utarn

  # 2. Context7 — เอกสาร library แบบสด
  npx ctx7@latest setup

  # 3. Bright Data — CLI / MCP server (ต้องใช้ API token ดูด้านล่าง)
  claude mcp add brightdata -- npx -y @brightdata/mcp

  # 4. Bright Data — skill surface ภายใน Claude Code
  claude plugin install brightdata-plugin@claude-plugins-official --scope local
}
```

รันคำสั่ง:

```powershell
quicksetup
```
```

- [ ] **Step 4: Verify code blocks are untouched and structure is intact**

Run:

```bash
grep -n "claude --dangerously-skip-permissions" QUICKSETUP.md
grep -n "claude plugin install utarn-skills@utarn" QUICKSETUP.md
```

Expected: each pattern appears exactly twice (once in the bash block, once in the powershell block) with no edits.

Also confirm the section order by listing headings:

```bash
grep -n "^#" QUICKSETUP.md
```

Expected headings in order: `# การตั้งค่าด่วน (Quick Setup)`, `## Bash (Linux / macOS)`, `## PowerShell (Windows)`.

- [ ] **Step 5: Commit**

```bash
git add QUICKSETUP.md
git commit -m "docs: translate QUICKSETUP top half to Thai (primary)"
```

---

### Task 2: Translate the bottom half (Bright Data key section, steps table, footer)

**Files:**
- Modify: `QUICKSETUP.md:73-103` (from "Bright Data API key" through the final paragraph)

**Interfaces:**
- Consumes: the Thai-primary doc from Task 1 with intact code blocks
- Produces: fully Thai-primary doc; only the `## English version` appendix remains to be added in Task 3

- [ ] **Step 1: Replace the Bright Data API key section (lines 73-91)**

Replace the `## Bright Data API key (free tier)` section (heading through the final sentence before "What each step does") with:

```markdown
## Bright Data API key (แผนฟรี / free tier)

เซิร์ฟเวอร์ Bright Data MCP ต้องการ API token เพื่อเชื่อมต่อกับเครือข่าย scraping ของ Bright Data

1. ไปที่เว็บไซต์ Bright Data แล้วสมัครสมาชิก — มี **free tier** ที่ใช้งานได้โดยไม่ต้องมีแผนแบบชำระเงิน
2. สร้างโซน (Web Unlocker คือตัวทั่วไป) แล้วคัดลอก API token ของมัน
3. Export token ก่อนเปิด Claude เพื่อให้ MCP server อ่านได้:

   **Bash** — เพิ่มลงใน `~/.bashrc` / `~/.zshrc`:
   ```bash
   export BRIGHT_DATA_API_TOKEN="วาง-token-ของคุณ-ที่นี่"
   ```

   **PowerShell** — เพิ่มลงในโปรไฟล์ของคุณ:
   ```powershell
   $env:BRIGHT_DATA_API_TOKEN = "วาง-token-ของคุณ-ที่นี่"
   ```

เริ่ม shell ใหม่ (หรือโหลดโปรไฟล์ใหม่) หลังจาก export token แล้วรัน `ccc` / `cccc`
```

- [ ] **Step 2: Replace the "What each step does" section (lines 93-103)**

Replace from `## What each step does` through the final paragraph with:

```markdown
## แต่ละขั้นตอนทำอะไร

| ขั้นตอน | คำสั่ง | ผลลัพธ์ |
|---|---|---|
| 1 | `claude plugin marketplace add utarn/engineer-skills` | ลงทะเบียน repo นี้เป็น Claude Code plugin marketplace |
| 2 | `claude plugin install utarn-skills@utarn` | ติดตั้งแพ็กเกจ engineer-skills ทั้งหมดเป็นปลั๊กอินที่จัดการและอัปเดตอัตโนมัติ |
| 3 | `npx ctx7@latest setup` | ติดตั้ง Context7 ลงใน coding agent ของคุณเพื่อให้ดึงเอกสาร library แบบสดได้ |
| 4 | `claude mcp add brightdata -- npx -y @brightdata/mcp` | ลงทะเบียน Bright Data MCP server (CLI) ให้ Claude เรียกเครื่องมือ scraping ได้ ต้องใช้ API token ด้านบน |
| 5 | `claude plugin install brightdata-plugin@claude-plugins-official --scope local` | เพิ่ม Bright Data skill surface ให้โปรเจกต์นี้ |

หลังจาก `quicksetup` เสร็จ ให้รัน `/setup-utarn-skills` ครั้งเดียวต่อ repo เพื่อตั้งค่า issue tracker, triage labels และตำแหน่ง docs — ดู [Quickstart](./README.md#quickstart-30-second-setup) ใน README
```

- [ ] **Step 3: Verify the token placeholder and link survived**

Run:

```bash
grep -n "BRIGHT_DATA_API_TOKEN" QUICKSETUP.md
grep -n "README.md#quickstart-30-second-setup" QUICKSETUP.md
grep -n "/setup-utarn-skills" QUICKSETUP.md
```

Expected: `BRIGHT_DATA_API_TOKEN` appears twice (bash + powershell blocks, untranslated), the Quickstart link appears once, and `/setup-utarn-skills` appears once.

- [ ] **Step 4: Commit**

```bash
git add QUICKSETUP.md
git commit -m "docs: translate QUICKSETUP bottom half to Thai (primary)"
```

---

### Task 3: Add English secondary appendix + self-review

**Files:**
- Modify: `QUICKSETUP.md` — append a new `## English version` section at the very end

**Interfaces:**
- Consumes: the fully Thai-primary doc from Tasks 1-2
- Produces: a self-contained bilingual doc; primary = Thai, secondary = English appendix

- [ ] **Step 1: Append the English version section**

Append the following section to the end of `QUICKSETUP.md` (after the final Thai paragraph). This is the original English content, kept verbatim for the secondary audience.

```markdown
## English version

# Quick Setup

Get Claude Code working with all the tools you need in one shot: the engineer-skills plugin, Context7 for live docs, and Bright Data for web scraping (CLI + skill).

Pick your shell and run the **install** block once. That gives you a `ccc` / `cccc` pair to launch Claude Code, plus a `quicksetup` function that wires up the skills. Then just type `quicksetup` to run it.

> `ccc` and `cccc` are convenience wrappers around `claude` — they skip the per-command permission prompt and continue the last session, matching the `--dangerously-skip-permissions` flow the rest of this repo assumes. They call `claude` directly, so they work for anyone, not just the author's private aliases.

## Bash (Linux / macOS)

Add this to `~/.bashrc` (or `~/.zshrc` on macOS), then start a new shell:

```bash
# Convenience launchers for Claude Code
ccc()  { claude --dangerously-skip-permissions "$@"; }
cccc() { claude --dangerously-skip-permissions --continue "$@"; }

# One-shot setup: engineer-skills plugin + Context7 + Bright Data (CLI + skill)
quicksetup() {
  # 1. engineer-skills plugin
  claude plugin marketplace add utarn/engineer-skills
  claude plugin install utarn-skills@utarn

  # 2. Context7 — live library docs
  npx ctx7@latest setup

  # 3. Bright Data — CLI / MCP server (needs an API token, see below)
  claude mcp add brightdata -- npx -y @brightdata/mcp

  # 4. Bright Data — skill surface inside Claude Code
  claude plugin install brightdata-plugin@claude-plugins-official --scope local
}
```

Run it:

```bash
quicksetup
```

## PowerShell (Windows)

Add this to your PowerShell profile (`notepad $PROFILE`), then open a new terminal:

```powershell
# Convenience launchers for Claude Code
function ccc  { claude --dangerously-skip-permissions @args }
function cccc { claude --dangerously-skip-permissions --continue @args }

# One-shot setup: engineer-skills plugin + Context7 + Bright Data (CLI + skill)
function quicksetup {
  # 1. engineer-skills plugin
  claude plugin marketplace add utarn/engineer-skills
  claude plugin install utarn-skills@utarn

  # 2. Context7 — live library docs
  npx ctx7@latest setup

  # 3. Bright Data — CLI / MCP server (needs an API token, see below)
  claude mcp add brightdata -- npx -y @brightdata/mcp

  # 4. Bright Data — skill surface inside Claude Code
  claude plugin install brightdata-plugin@claude-plugins-official --scope local
}
```

Run it:

```powershell
quicksetup
```

## Bright Data API key (free tier)

The Bright Data MCP server needs an API token to talk to Bright Data's scraping network.

1. Go to the Bright Data website and sign up — there's a **free tier** you can use without a paid plan.
2. Create a zone (Web Unlocker is the general-purpose one) and copy its API token.
3. Export it before you launch Claude so the MCP server can read it:

   **Bash** — add to `~/.bashrc` / `~/.zshrc`:
   ```bash
   export BRIGHT_DATA_API_TOKEN="paste-your-token-here"
   ```

   **PowerShell** — add to your profile:
   ```powershell
   $env:BRIGHT_DATA_API_TOKEN = "paste-your-token-here"
   ```

Start a new shell (or reload your profile) after exporting the token, then run `ccc` / `cccc`.

## What each step does

| Step | Command | Effect |
|---|---|---|
| 1 | `claude plugin marketplace add utarn/engineer-skills` | Register this repo as a Claude Code plugin marketplace. |
| 2 | `claude plugin install utarn-skills@utarn` | Install the whole engineer-skills bundle as a managed, auto-updating plugin. |
| 3 | `npx ctx7@latest setup` | Install Context7 into your coding agent so it can fetch live library docs. |
| 4 | `claude mcp add brightdata -- npx -y @brightdata/mcp` | Register the Bright Data MCP server (CLI) so Claude can call its scraping tools. Needs the API token above. |
| 5 | `claude plugin install brightdata-plugin@claude-plugins-official --scope local` | Add the Bright Data skill surface to this project. |

After `quicksetup` finishes, run `/setup-utarn-skills` once per repo to configure issue tracker, triage labels, and docs location — see the [Quickstart](./README.md#quickstart-30-second-setup) in the README.
```

- [ ] **Step 2: Self-review — spec coverage and integrity**

Run each check and confirm the expected output:

```bash
# 1. No stray English prose left in the primary (Thai) sections
#    Expect: only matches are inside the ## English version appendix
grep -n "Convenience launchers" QUICKSETUP.md
# Expect: exactly one match, inside the appendix

# 2. Heading order: Thai primary first, English appendix last
grep -n "^#" QUICKSETUP.md
# Expect: # การตั้งค่าด่วน ... , ## Bash, ## PowerShell, ## Bright Data API key, ## แต่ละขั้นตอนทำอะไร, ## English version

# 3. All four command code blocks still present and identical
grep -c "claude plugin install utarn-skills@utarn" QUICKSETUP.md
# Expect: 4 (twice in Thai body, twice in English appendix)
```

- [ ] **Step 3: Commit**

```bash
git add QUICKSETUP.md
git commit -m "docs: add English secondary appendix to Thai QUICKSETUP"
```

---

## Self-Review (by plan author)

**1. Spec coverage:** The request was "add Thai information to quicksetting.md" → clarified as a full Thai translation with English as secondary. Task 1 covers the top half, Task 2 the bottom half, Task 3 the English appendix. Every original section (intro, note, Bash, PowerShell, Bright Data key, steps table, footer) has a Thai counterpart. ✔

**2. Placeholder scan:** No "TBD"/"TODO"/"implement later". All Thai prose is written out in full; code blocks are copied verbatim. ✔

**3. Type consistency:** Not a typed codebase — but structural consistency holds: the `BRIGHT_DATA_API_TOKEN` placeholder, the `/setup-utarn-skills` command, the `README.md#quickstart-30-second-setup` link, and all four code blocks are byte-identical across Tasks 1-3 and between the Thai body and English appendix. ✔
