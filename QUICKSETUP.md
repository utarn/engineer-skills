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
