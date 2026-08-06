# Pretrained checkpoints — pinned revisions & checksums

The four DRIP LoRA adapters are hosted on the Hugging Face Hub. For reproducible
evaluation, **pin an exact revision** (a commit SHA, not a moving branch) and
**verify the downloaded files against the checksums** below.

| # | Repo (`Kelsey98/…`) | Base model | Template |
|---|---|---|---|
| 1 | `Llama-3.1-8B-Instruct-TextTextText-4roles-toolcall-drip` | `meta-llama/Llama-3.1-8B-Instruct` | 4-role |
| 2 | `Llama-3.1-8B-Instruct-TextTextText-drip` | `meta-llama/Llama-3.1-8B-Instruct` | 3-role |
| 3 | `Meta-Llama-3-8B-Instruct-TextTextText-drip` | `meta-llama/Meta-Llama-3-8B-Instruct` | 3-role |
| 4 | `Mistral-7B-Instruct-v0.3-TextTextTextMistral-drip` | `mistralai/Mistral-7B-Instruct-v0.3` | 3-role |

## 1. Download a pinned revision

```bash
REPO=Llama-3.1-8B-Instruct-TextTextText-4roles-toolcall-drip
REV=<commit-sha>          # the exact revision from the table below
huggingface-cli download "Kelsey98/$REPO" --revision "$REV" --local-dir "$REPO"
```

Find a repo's revisions with `huggingface-cli scan-cache` after download, or on the
Hub under *Files and versions → History* (each commit has a full SHA).

## 2. Verify checksums

After downloading, recompute SHA-256 over the adapter files and compare to the
manifest:

```bash
# from inside the downloaded adapter directory
find . -type f \( -name '*.safetensors' -o -name '*.json' -o -name '*.model' \) \
  | sort | xargs sha256sum
```

## 3. Checksum manifest

> ⚠️ **To be filled by the maintainer.** Pin each repo to the exact revision you
> archived for the paper, then paste the SHA-256 of `adapter_model.safetensors`
> (and `adapter_config.json`) produced by the command above. Fill these in from a
> machine with Hub access — they cannot be generated in the sandboxed CI.

| # | Repo | Revision (commit SHA) | `adapter_model.safetensors` SHA-256 | `adapter_config.json` SHA-256 |
|---|---|---|---|---|
| 1 | `…-4roles-toolcall-drip` | `<pin>` | `<sha256>` | `<sha256>` |
| 2 | `…-TextTextText-drip` (Llama-3.1) | `<pin>` | `<sha256>` | `<sha256>` |
| 3 | `Meta-Llama-3-…-TextTextText-drip` | `<pin>` | `<sha256>` | `<sha256>` |
| 4 | `Mistral-7B-…-TextTextTextMistral-drip` | `<pin>` | `<sha256>` | `<sha256>` |

Once filled, evaluators can confirm they are running the exact artifact evaluated
in the paper.
