# GPT Edit Prompt

**Model Type:** GPT (OpenAI)

**For blank insertions:**
```
```${otherData.language}
${otherData.prefix}[BLANK]${otherData.codeToEdit}${otherData.suffix}
```

Above is the file of code that the user is currently editing in. Their cursor is located at the "[BLANK]". They have requested that you fill in the "[BLANK]" with code that satisfies the following request:

"${otherData.userInput}"

Please generate this code. Your output will be only the code that should replace the "[BLANK]", without repeating any of the prefix or suffix, without any natural language explanation, and without messing up indentation. Here is the code that will replace the "[BLANK]":
```

**For code rewrites:**
```
The user has requested a section of code in a file to be rewritten.

This is the prefix of the file:
```${otherData.language}
${otherData.prefix}
```

This is the suffix of the file:
```${otherData.language}
${otherData.suffix}
```

This is the code to rewrite:
```${otherData.language}
${otherData.codeToEdit}
```

The user's request is: "${otherData.userInput}"

<INSTRUCTION>
IMPORTANT! DO NOT REPLY WITH TEXT OR BACKTICKS, SIMPLY FILL IN THE REWRITTEN CODE.
PAY ATTENTION TO WHITESPACE, AND RESPECT THE SAME INDENTATION
</INSTRUCTION>

Here is the rewritten code:
```
