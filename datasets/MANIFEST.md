# Dataset manifest

Every dataset referenced by the training, baseline, and evaluation scripts, with
its role, the script(s) that consume it, and its source.

**Source of truth.** All curated files live in the Zenodo data archive
(DOI [10.5281/zenodo.20603331](https://doi.org/10.5281/zenodo.20603331)). Download
and extract it into the repository root so the paths below resolve (see the main
[README → Download the data](../README.md#3-download-the-data)):

```bash
wget -O datasets.zip "https://zenodo.org/records/20603331/files/datasets.zip?download=1"
unzip datasets.zip && mv datasets1/ datasets/
```

Every curated file can also be **regenerated from scratch** with the pipeline in
[`data_generation/`](../data_generation/README.md) (needs an `OPENAI_API_KEY`).

---

## Training / baseline DPO datasets

| File | Consumed by (launcher) | Role | Regenerate with |
|---|---|---|---|
| `sep/sep_data_cleaned_dpo_gpt.json` | `{llama8b,mistral7b}/sep/drip_sep.sh`, `llama8b/sep/drip_{nofusion,concatfusion,embeddingshift}.sh` | **DRIP** main SEP DPO pairs (3-role, cleaned, GPT-authored chosen) | `data_generation/SEP_to_DPO.py` + `data_curation_drip.py` |
| `alpaca_data_cleaned_dpo_gpt.json` | `{llama8b,mistral7b}/alpaca/drip_alpaca.sh` | DRIP Alpaca DPO pairs (3-role) | `data_generation/CleanAlpaca_to_DPO.py` + `data_curation_drip.py` |
| `alpaca_injecagent_dpo_combined.json` | `llama8b/alpaca/drip_alpaca_4roles.sh`, `llama8b/agentdojo/drip_4roles.sh` | 4-role tool-calling DPO (~20K Alpaca + ~1K InjecAgent) | `data_generation/data_curation_drip_toolcall.py` |
| `alpaca_data_dpo_ablate_no_judge.json` | `llama8b/alpaca/drip_nojudge.sh` | Ablation: Alpaca DPO **without** the judge filter | `data_curation_drip.py --no_judge` |
| `sep/sep_data_cleaned.json` | `{llama8b,mistral7b}/sep/{struq,pft,ise}_sep.sh` | Baselines (StruQ / PFT / ISE) — cleaned SEP data | `data_generation/SEP_to_DPO.py` |
| `sep/sep_data_dpo.json` | `{llama8b,mistral7b}/sep/secalign_sep.sh` | Baseline (SecAlign) — SEP DPO pairs | `data_generation/SEP_to_DPO.py` |
| `sep/sep_data_origdata_dpo.json` | `{llama8b,mistral7b}/sep/air_sep_dpo.sh` | Baseline (AIR) — SEP DPO on original data | `data_generation/data_curation_orig.py` |

## Evaluation datasets

| File | Used by | Role |
|---|---|---|
| `SEP_dataset.json` | `testing/sep/test_sep.py` | SEP role-separation benchmark (9,160 examples) |
| `alpaca_data_cleaned.json` | `testing/test.py` (Alpaca injection / utility) | Cleaned AlpacaFarm instructions |
| `ifeval/input_data.jsonl` | `testing/ifeval/` | IFEval prompts (541) |
| `mtbench.jsonl` | `testing/mt_bench/` | MT-Bench questions |
| `judge_prompts.jsonl` | `testing/mt_bench/gen_judgment.py` | MT-Bench LLM-judge prompts |
| `davinci_003_outputs.json` | AlpacaEval 2.0 | Reference outputs (davinci-003) |
| `gpt4o_outputs.json` | AlpacaEval 2.0 | Reference outputs (GPT-4o) |
| `injecagent/tools.json` | `testing/injecagent/` | InjecAgent tool specifications |
| `injecagent/attacker_param_cache.json` | `testing/injecagent/`, tool-call curation | Cached attacker tool arguments |
| `injecagent/attacker_simulated_responses.json` | `testing/injecagent/` | Simulated attacker tool responses |

## Curation source / intermediate files

Produced and consumed inside [`data_generation/`](../data_generation/README.md);
listed for completeness (also shipped in the Zenodo archive):

`sep/train_dataset.json` (raw SEP training split), `alpaca_data.json`,
`alpaca_data_injected_diff_output.json`, `sep/sep_data_full_withanswer.json`,
`sep/sep_data_injected_diff_output.json`, `sep/sep_data_origdata_sft.json`,
`sep/sep_data_air_dpo.json`, `sep/sep_dpo_retrieved.jsonl`,
`sep/sep_dpo_submit.jsonl`, `injecagent_dpo.json`, `injecagent_ds_dpo.json`.

---

*Counts and field schemas for the SEP splits are documented in
[`testing/sep/README.md`](../testing/sep/README.md); the 4-role tool-calling mix is
documented in [`testing/agentdojo/README.md`](../testing/agentdojo/README.md).*
