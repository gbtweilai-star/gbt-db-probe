# db_probe

**One capability bit from GBT V8, packaged standalone.** No. 69 of 341,
`data` domain (Data).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> 本地只读查询台（dbx 蒸馏）：**SQLite 概览 + JSONL 行统计**——`sources` 列可查本地源 · `tables` 静态 SQL 列表/视图 · `schema` 参数化取 DDL + Python 解析列 · `counts` 每表行数（iterdump 文本计数）· `jsonl` 行统计/筛选（纯 Python 可自由筛）。🔴 **零动态 SQL**（两版被安全钩子按"SQL 注入"拦下 ⇒ 静态字面量 + 参数取值 + Python 层解析；连接 mode=ro）；结果不落盘；不提供按条件查行（要就说，请主人给门加分支）。op=sources/tables/schema/counts/jsonl/where

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-db-probe.git
cd gbt-db-probe
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_db_probe info                  # capability card
python -m gbt_db_probe spec --json           # machine-readable contract
python -m gbt_db_probe check --payload '{}'
python -m gbt_db_probe run   --payload '{}'
```

Real `info` output from this machine:

```text
db_probe  (data)  v1.0.0
----------------------------------------
本地只读查询台（dbx 蒸馏）：**SQLite 概览 + JSONL 行统计**——`sources` 列可查本地源 · `tables` 静态 SQL 列表/视图 · `schema` 参数化取 DDL + Python 解析列 · `counts` 每表行数（iterdump 文本计数）· `jsonl` 行统计/筛选（纯 Python 可自由筛）。🔴 **零动态 SQL**（两版被安全钩子按"SQL 注入"拦下 ⇒ 静态字面量 + 参数取值 + Python 层解析；连接 mode=ro）；结果不落盘；不提供按条件查行（要就说，请主人给门加分支）。op=sources/tables/schema/counts/jsonl/where

gated      : False
external   : False
multi-op   : True
params     : (none)
values     : sources, tables, schema, counts, jsonl, where
```

Wire a real implementation:

```python
from gbt_db_probe import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| — | no | the registry declares no required parameters |

Registry hint (`params_hint`): (empty)

**注册表登记的取值 / 子动作（6 个）**：`sources`、`tables`、`schema`、`counts`、`jsonl`、`where`

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Not gated: the registry marks this bit `safe: true`.
- No external service dependency declared.
- Multi-op (`multi_op: true`): several sub-actions share one name — read `op` before calling.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
20 passed, 3 skipped in 0.10s
```

## Provenance

| field | value |
|---|---|
| capability | `db_probe` |
| domain | `data` |
| handler | `db_probe` |
| safe | `True` (gated = `False`) |
| external | `False` |
| atlas page | [data/db_probe](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/data/db_probe.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.
