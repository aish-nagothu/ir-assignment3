# Information Retrieval - Assignment 3: Retrieval Evaluation

Implementation of fundamental retrieval evaluation metrics (precision, recall,
interpolated precision at the 11 standard recall levels, P@k and the F-measure),
used to compare the cached results of four search engines: **Google, Bing,
DuckDuckGo and Yahoo**.

Google's top 7 results are used as the relevance baseline, so the relevant set
contains 7 documents per query. Documents are identified by their URL.

## Project layout

```
main.py             # all metrics + the evaluation driver
query1_cache/       # cached results for "Modern Information Retrieval"
query2_cache/       # cached results for "information retrieval evaluation"
  google.json  bing.json  duckduckgo.json  yahoo.json
requirements.txt
Dockerfile
docker-compose.yml
plots/              # generated: one precision-recall plot per engine per query
results.txt         # generated: the printed output
```

## How to run

Tested with Python 3.10.

### Docker

```bash
docker compose up --build
```

This writes the output to `results.txt` and the plots to `plots/`. No plot
windows are shown.

### virtualenv

```bash
virtualenv venv
source venv/bin/activate        # Windows: venv\Scripts\activate
pip install -r requirements.txt
python main.py
```

### Without virtualenv

```bash
pip install -r requirements.txt
python main.py
```

To save the output instead of reading it in the terminal:

```bash
python main.py > results.txt
```

The plots are always written to `plots/`, whether or not the output is
redirected.

## What is implemented

| Function | Description |
|---|---|
| `precision_recall(retrieved, relevant)` | Precision = relevant ∩ retrieved / retrieved; recall = relevant ∩ retrieved / relevant |
| `precision_at_11_standard_recall_levels(retrieved, relevant)` | Interpolated precision at recall 0.0, 0.1, … 1.0 |
| `f_metric(retrieved, relevant)` | F-measure, the harmonic mean `2PR / (P + R)` |
| `p_at_5(retrieved, relevant)` | Precision at rank 5 |
| `p_at_10(retrieved, relevant)` | Precision at rank 10 |

### Implementation notes

- **Interpolation.** Precision at a recall level is the highest precision
  reached at that recall or beyond: `P(r_j) = max{P(r) : r >= r_j}`.
- **Boundary cases.** A recall level an engine never reaches gets precision 0,
  so every curve falls to 0 on the right. Recall level 0 takes the best
  precision seen anywhere, or 0 if nothing relevant was retrieved. A small
  epsilon is used in the recall comparison to avoid floating-point issues.
- **P@k divides by k**, not by the number of results returned, so an engine
  that returns fewer than k results is penalised. This matters for Yahoo,
  whose cache holds only 5 results.
- **Plot filenames** include the cache directory, so query 2's plots do not
  overwrite query 1's.

## Output

For each of the two queries, `main.py` prints:

1. The retrieved ranking of each engine.
2. Precision and recall per engine.
3. Interpolated precision at the 11 standard recall levels per engine, and a
   plot saved to `plots/`.
4. The single-valued summaries: F, P@5 and P@10 per engine.

## Results summary

| Query | Engine | P | R | F | P@5 | P@10 |
|---|---|---|---|---|---|---|
| Q1 | Google | 1.00 | 1.00 | 1.00 | 1.0 | 0.7 |
| Q1 | Bing | 0.15 | 0.43 | 0.22 | 0.2 | 0.3 |
| Q1 | DuckDuckGo | 0.10 | 0.29 | 0.15 | 0.4 | 0.2 |
| Q1 | Yahoo | 0.20 | 0.14 | 0.17 | 0.2 | 0.1 |
| Q2 | Google | 1.00 | 1.00 | 1.00 | 1.0 | 0.7 |
| Q2 | Bing | 0.20 | 0.57 | 0.30 | 0.2 | 0.2 |
| Q2 | DuckDuckGo | 0.20 | 0.57 | 0.30 | 0.2 | 0.2 |
| Q2 | Yahoo | 0.20 | 0.14 | 0.17 | 0.2 | 0.1 |

Google scores 1.0 on every metric because it is the baseline; its P@10 is 0.7
only because the baseline contains 7 documents. These metrics measure agreement
with Google rather than true relevance.
