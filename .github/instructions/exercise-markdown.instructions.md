---
applyTo: "Instructions/**/*.md"
---

# Exercise Markdown Guidelines

## Voice and Tone
- Second person: "you'll create", "enter the following command"
- Active voice: "Add the following code" not "The following code should be added"
- Concise: This is a hands-on lab, not a lecture

## Formatting
- Use `> **Tip**: ...` for helpful hints
- Use `> **Note**: ...` for important caveats
- Use `> **Important**: ...` for critical warnings
- Bold UI elements: **Create**, **Deploy**, **Settings**
- Bold comment references: **Find the comment "Add references"**
- Code fences with language: ```python, ```powershell, ```bash

## Code Block Rules
- Each code block must be self-contained and paste-able
- Comment placeholders in starter code must exactly match bold text in instructions
- Include the comment line itself so students know where to paste
- Show proper indentation relative to the surrounding code context

## Section Structure
1. Exercise title and overview
2. Azure resource setup (Foundry project, model deployment)
3. Clone repo and configure
4. Write code (numbered steps with code blocks)
5. Run and test
6. Clean up resources

## Estimated time: always include "approximately **30** minutes"
