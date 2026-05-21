# hermes-life - Env / Secret Map

This file records where secrets live, not their values.

## Container `.env`

- Inside container: `/opt/data/.env`
- On host: `/srv/hermes-life/data/.env`

## Keys

| Key | Purpose | Provider | Scope | Stored where | Last rotated |
|---|---|---|---|---|---|
| `OPENAI_API_KEY` | Main dialogue model | OpenAI | minimal required | `/srv/hermes-life/data/.env` | TBD |
| `GEMINI_API_KEY` | Auxiliary/support tasks | Google/Gemini | minimal required | `/srv/hermes-life/data/.env` | TBD |
| `ANTHROPIC_API_KEY` | High-stakes code verification | Anthropic | minimal required | `/srv/hermes-life/data/.env` | TBD |
| `TELEGRAM_BOT_TOKEN` | Optional messaging gateway | Telegram | bot-scoped | `/srv/hermes-life/data/.env` | TBD |

## Model Routing Notes

- Primary dialogue: OpenAI GPT-5.5 class
- Auxiliary/support: Gemini Flash class
- High-stakes verification: Anthropic Claude Opus class

## Rules

- Do not paste raw secret values in this file.
- Use per-agent key names in provider dashboards.
- Prefer least privilege.
- Rotate any key pasted into chat.
