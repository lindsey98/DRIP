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

SHA-256 of the weights `.safetensors` file in each repo. On the Hub, open the file
under *Files and versions → `<file>.safetensors`*; the **`SHA256:`** line on that
blob page is the value below (this equals `sha256sum` of the downloaded file — the
separate "Xet hash" is Hugging Face's internal dedup hash, not used for
verification).

| # | Repo (`Kelsey98/…`) | Revision (commit SHA) | Weights SHA-256 | Size |
|---|---|---|---|---|
| 1 | `Llama-3.1-8B-Instruct-TextTextText-4roles-toolcall-drip` | `d97febc67553b2d5bd2e14bd6ea15d2294837b67` | `5abaaed207cb2f8eed129852a77d583203feca27108dfada7c084ff52b8a3d95` | 4.44 GB |
| 2 | `Llama-3.1-8B-Instruct-TextTextText-drip` | `314c5930d141da2c9d2e2b2a907f830e07e519fc` | `4a0b7e9e228b042537661d541437c081eb9f88139c380bb066e68b2a9531ad53` | 4.44 GB |
| 3 | `Meta-Llama-3-8B-Instruct-TextTextText-drip` | `1497185b5c93333dddf3892117af9828516dc37b` | `e7b0b5f25960d80a08b163cf48151dc89988b68637bef65f0bb4fdc1004bc7a4` | 4.44 GB |
| 4 | `Mistral-7B-Instruct-v0.3-TextTextTextMistral-drip` | `ef717b36c82284fea93cfe6434cf13a6eb8aebab` | `f57d83a7edafe9afeab2d7d0fa7b5eec821b06e6691738f175554cbaf6ad8c21` | 1.31 GB |

Each revision is the archived commit on the Hub (`HfApi().model_info(repo).sha`);
download with `--revision <sha>` (Section 1) to fetch that exact snapshot, then
verify the weights against the SHA-256 above. This lets evaluators confirm they are
running the exact artifact evaluated in the paper.
