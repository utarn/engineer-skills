# การตั้งค่าด่วน (Quick Setup)

เริ่มใช้งาน Claude Code พร้อมเครื่องมือทั้งหมดที่คุณต้องการในขั้นตอนเดียว: ปลั๊กอิน engineer-skills, Context7 สำหรับดึงเอกสารสด, และ Bright Data สำหรับ scraping เว็บ (CLI + skill)

เลือก shell ของคุณแล้วรันบล็อก **install** ครั้งเดียว สิ่งนี้จะให้คู่คำสั่ง `ccc` / `cccc` สำหรับเปิด Claude Code พร้อมฟังก์ชัน `quicksetup` ที่เชื่อมต่อ skills ให้ จากนั้นเพียงพิมพ์ `quicksetup` เพื่อรันได้เลย

> `ccc` และ `cccc` คือ wrapper สะดวกสำหรับ `claude` — ข้ามการขออนุญาตต่อคำสั่งและต่อเซสชันล่าสุด สอดคล้องกับ flow `--dangerously-skip-permissions` ที่เหลือของ repo นี้สันนิษฐานไว้ พวกมันเรียก `claude` โดยตรง จึงทำงานได้กับทุกคน ไม่ใช่แค่ alias ส่วนตัวของผู้เขียน

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

## แต่ละขั้นตอนทำอะไร

| ขั้นตอน | คำสั่ง | ผลลัพธ์ |
|---|---|---|
| 1 | `claude plugin marketplace add utarn/engineer-skills` | ลงทะเบียน repo นี้เป็น Claude Code plugin marketplace |
| 2 | `claude plugin install utarn-skills@utarn` | ติดตั้งแพ็กเกจ engineer-skills ทั้งหมดเป็นปลั๊กอินที่จัดการและอัปเดตอัตโนมัติ |
| 3 | `npx ctx7@latest setup` | ติดตั้ง Context7 ลงใน coding agent ของคุณเพื่อให้ดึงเอกสาร library แบบสดได้ |
| 4 | `claude mcp add brightdata -- npx -y @brightdata/mcp` | ลงทะเบียน Bright Data MCP server (CLI) ให้ Claude เรียกเครื่องมือ scraping ได้ ต้องใช้ API token ด้านบน |
| 5 | `claude plugin install brightdata-plugin@claude-plugins-official --scope local` | เพิ่ม Bright Data skill surface ให้โปรเจกต์นี้ |

หลังจาก `quicksetup` เสร็จ ให้รัน `/setup-utarn-skills` ครั้งเดียวต่อ repo เพื่อตั้งค่า issue tracker, triage labels และตำแหน่ง docs — ดู [Quickstart](./README.md#quickstart-30-second-setup) ใน README

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
