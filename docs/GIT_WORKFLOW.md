# Git Conventions

> These are guidelines — not enforced rules. Developers are encouraged to follow this structure to keep the repository history readable and consistent, but are not blocked from working if they do not.

---

## Branches

Branch names follow this pattern:

```
EXP-{ticket-number}
```

The ticket number ties the branch directly to the Jira ticket.

```
EXP-1
EXP-2
EXP-3
```

Rules:
- Always start with the Jira ticket number
- One branch per ticket — do not combine multiple tickets in one branch

---

## Commit Messages

Commit messages follow the Conventional Commits standard:

```
type: short description
```

**Types:**

| Type | When to use |
|---|---|
| `feat` | A new feature or visible behaviour change |
| `fix` | A bug fix |
| `refactor` | Code restructuring with no behaviour change |
| `chore` | Dependency updates, config changes, build changes |
| `docs` | Documentation changes only |
| `style` | Formatting, whitespace — no logic change |
| `test` | Adding or updating tests |

**Examples:**

```
feat: add pagination to user list endpoint
fix: resolve 401 redirect loop on token expiry
refactor: pack event sync into separate service method
chore: update tanstack query to v5
docs: add SERVICES.md frontend implementation guide
test: add feature tests for pack create endpoint
style: format UserController methods
```

Rules:
- Use present tense — `add` not `added` or `adding`
- Keep the description under 72 characters
- No full stop at the end
- If the commit is tied to a Jira ticket, reference it at the end:

```
feat: add pagination to user list endpoint EXP-150
```

---

## Pull Requests

### Title

PR titles follow this pattern:

```
EXP-{ticket-number}: {description}
```

The description completes the sentence "This PR will..." — use present tense, plain English:

```
EXP-150: Add user pagination to admin dashboard
EXP-203: Fix session timeout on facilitator login
EXP-87: Refactor pack service sync logic
EXP-312: Add file extension validation to media upload
```

Rules:
- Always start with the Jira ticket number
- Colon after the ticket number
- Description in sentence case — capitalise the first word only
- Present tense — `Add` not `Added` or `Adding`
- Keep it concise — one clear sentence describing what the PR does

### Description

PR descriptions are handled by the repository PR template — no additional description is required beyond what the template provides.

---

## Summary

| Element | Pattern | Example |
|---|---|---|
| Branch | `EXP-{number}` | `EXP-150` |
| Commit | `type: short description` | `feat: add pagination to user list` |
| PR title | `EXP-{number}: Description` | `EXP-150: Add user pagination to admin dashboard` |


just store this git.md fiel for now