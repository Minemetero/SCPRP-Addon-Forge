# Security Policy

## Reporting Issues

If you discover a security concern, please first determine whether it is:

- **A vulnerability in the SCP:RP game itself**  
  (e.g., engine exploits, core game logic flaws).  
  → This repository is **not responsible** for such issues. Please report them directly to the SCP:RP developers / MetaMethod.

- **A problem in an addon from this repository**  
  (e.g., unsafe HTTP usage, leaking data, excessive resource use).  
  → In this case, please open a private report to the maintainers (via GitHub Security Advisory if available, or by contacting a contributor).

We only take responsibility for issues that originate from the **addons in this repository**, not from the base game.

---

## Guidelines for Contributors

- Do **not** commit real secrets (webhooks, API keys). Always use placeholders.
- Be careful with `http(...)` usage — avoid exposing user data, and respect rate limits.
- Avoid infinite loops without `task.wait()` to prevent server lockups.
- Test addons privately before submitting them.

---

⚠️ **Disclaimer**  
This repository is community-run. While addons are reviewed by contributors, they are provided **as-is, without warranty**. You use them at your own risk.
