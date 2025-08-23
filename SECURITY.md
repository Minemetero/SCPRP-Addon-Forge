# Security Policy

If you discover a security concern (e.g., SSRF via `http(...)`, abusive message patterns, or resource leaks):

- **Do not** open a public issue with details.
- Email a maintainer or open a private security advisory (GitHub Security tab) if available.
- We will coordinate a fix and responsible disclosure.

Guidelines for contributors:
- Never hard-code secrets or production webhooks.
- Avoid sending unbounded user input to the network; sanitize or truncate where appropriate.
- Avoid tight infinite loops; always include a `task.wait()` in periodic tasks.
