---
description: Generate a complete solution file for a specific exercise by reading the instruction markdown and applying all code blocks to the starter code.
---

Read the exercise instruction file at `Instructions/${input:exerciseFile:Exercise markdown filename (e.g., 02-build-ai-agent.md)}`.

Then read the corresponding starter code in the `Labfiles/` directory.

Apply every code block from the instructions into the starter code at the matching comment placeholder. Preserve all comments. Maintain correct Python indentation.

Save the result to the `solution/` subfolder next to the starter code.

Verify the solution compiles with `python -m py_compile`.

Report:
1. How many code blocks you found and applied
2. The output file path
3. Any ambiguities or issues encountered
