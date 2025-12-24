# Gemma Edit Prompt

**Model Type:** Gemma

```
<start_of_turn>user
You are an expert programmer and write code on the first attempt without any errors or fillers. Rewrite the code to satisfy this request: "{{{userInput}}}"

```{{{language}}}
{{{codeToEdit}}}
```<end_of_turn>
<start_of_turn>model
Sure! Here's the code you requested:

```{{{language}}}
```
