# 出典と根拠

このツールの思想が、どの研究・実務知見に基づいているかをまとめたもの。
各項目は「何が言われているか（要旨）」と「このツールのどこに効いているか」をセットで書く。

最終確認日: 2026-11-23

---

## 思想との対応表

| 思想 | 主な根拠 |
|---|---|
| 1. 理解とは、仮説を立てて検証すること（抽象→具体） | Brooks のトップダウンモデル / 統合モデル / Google のレビュー指針 |
| 2. 人間の頭の容量は小さい（情報は足すより削る） | 作業記憶とレビュー成績の研究 / 『プログラマー脳』 / tangled changes の研究 |
| 3. 読む軸は1本にする（同じコードを二度読ませない） | 読む順番の原則（Baum ら） / ファイル順序の調査 |
| 4. AIはコードか根拠資料から分かることだけを書く。分からないことは「要確認」 | レビュアーの情報ニーズ研究 / 理解負債の調査 |
| 5. 判断は人間が下す | Microsoft の調査 / Google のレビュー指針 |

---

## 1. プログラム理解のモデル

### Brooks のトップダウンモデル（1983）
- 要旨: 読み手はまず「このプログラムは何をするか」という上位の仮説を立て、それを支える下位の仮説を順に立てて、コードや文書で確かめていく。
- 効いている箇所: 抽象（仮説）を先に示し、具体（証拠）で確かめる、という全体構造。
- 参照:
  - von Mayrhauser & Vans による解説 <https://www.cs.colostate.edu/~somlo/pubs/ijhcs99.pdf>
  - Source Code Comprehension: A Contemporary Definition and Conceptual Model <https://arxiv.org/pdf/2310.11301>

### ボトムアップモデル（Pennington ほか）と統合モデル（von Mayrhauser & Vans）
- 要旨: 細部を読んで塊にまとめ、上位の意味を組み立てる読み方もある。大規模コードでは、実際には両方を状況に応じて切り替えている。
- 効いている箇所: 抽象だけで終わらせず、必ず具体（コード・値）まで降りられるようにする。
- 参照:
  - <https://www.cs.kent.edu/~jmaletic/cs69995-PC/papers/von_mayrhauser97.pdf>
  - O'Brien, Software Comprehension – A Review & Research Direction <https://www.st.cs.uni-saarland.de/edu/empirical-se/2006/PDFs/brien03.pdf>

---

## 2. コードレビューの実証研究

### Bacchelli & Bird, "Expectations, Outcomes, and Challenges of Modern Code Review"（ICSE 2013）
- 要旨: Microsoft での観察・インタビュー・調査。レビューの中心的な難しさは「変更を理解すること」であり、その必要は既存ツールでは十分に満たされていない。
- 効いている箇所: ツールの目的を「指摘の自動化」ではなく「理解の支援」に置く根拠。
- 参照:
  - <https://web.eecs.umich.edu/~weimerw/2018-481/readings/codereview.pdf>
  - DOI: <https://doi.org/10.1109/ICSE.2013.6606617>

### Pascarella ほか, "Information Needs in Contemporary Code Review"（CSCW 2018）
- 要旨: 900件のレビューコメントを分類し、レビュアーが必要とする情報を7種類に整理（代替案の妥当性、正しい理解、変更理由、コードの文脈、必要性、専門知識、分割可能性）。
- 効いている箇所: 「要確認」として出す問いの型。変更理由や必要性は、コードから読み取れなければ人に聞くべき情報。
- 参照:
  - <https://dibt.unimol.it/staff/fpalomba/documents/C41.pdf>
  - DOI: <https://doi.org/10.1145/3274404>

---

## 3. 認知負荷と読む順番

### Baum, Schneider & Bacchelli, "On the Optimal Order of Reading Source Code Changes for Review"（ICSME 2017）
- 要旨: 最適な順番とは主に「関連する変更をまとめること」。原則は、関連する部分を近くに置く／情報は必要になる前に出す／両者がぶつかればまとめる方を優先／並べ方のルールを読み手に分かる形にする。
- 効いている箇所: 「データの旅」1本を軸にし、駅ごとにまとめて見せる構造。
- 参照:
  - 原則の一覧 <https://tobiasbaum.github.io/orderingPrinciples.html>
  - 論文 <https://tobiasbaum.github.io/rp/optimalordering.pdf>

### Baum, Schneider & Bacchelli, "Associating Working Memory Capacity and Code Change Ordering with Code Review Performance"（EMSE 2019）
- 要旨: 作業記憶の容量・認知負荷と、レビューでの欠陥発見の関係を実験で検証。
- 効いている箇所: 「判断に使わない情報は出さない」という絞り込みの根拠。
- 参照: DOI <https://doi.org/10.1007/s10664-018-9676-8>

### ファイル順序に関する調査（"Breaking the Alphabet", ICSE 2026）
- 要旨: 1,355人の開発者への調査。アルファベット順を最適と考えるレビュアーは約1割にとどまる。
- 効いている箇所: diff のファイル順のまま読ませない理由。
- 参照: <https://arxiv.org/pdf/2609.04207>

### 混ざった変更（tangled changes）の研究
- 要旨: 無関係な複数の関心事が1つの変更に混ざると、レビューの理解が難しくなる。
- 効いている箇所: どの旅も通らない変更を「車庫」に分ける設計。
- 参照:
  - Barnett ほか, ClusterChanges（ICSE 2015）<https://www.microsoft.com/en-us/research/publication/helping-developers-help-themselves-automatic-decomposition-of-code-review-changesets/>
  - di Biase ほか, The effects of change decomposition on code review <https://peerj.com/articles/cs-193>

---

## 4. 量とペースの目安

### SmartBear / Cisco のレビュー調査（2006）
- 要旨: 2,500件・320万行のレビューを分析。一度に200〜400行まで、1時間に300〜500行まで、約60分までが効果的とされる。
- 注意: 調査主体はレビューツールのベンダー。測っているのは欠陥発見率で、理解の速さではない。AI普及前のデータ。
- 効いている箇所: 一度に見せる範囲を小さく区切る設計の参考値（厳密な基準としては使わない）。
- 参照:
  - <https://smartbear.com/learn/code-review/what-is-code-review/>
  - <https://agileconnection.com/article/largest-case-study-code-reviews-ever>

---

## 5. AI時代の変化（理解負債）

### "How Do Practitioners Build SE Agents?"（2026）
- 要旨: コーディングエージェントが、人が理解できる速度より速くコードを生み、理解が追いつく前に動くコードが入る状態を「理解負債」と整理。量だけでなく、生成コード自体の読みにくさも指摘。レビュー負担が下流に移っているという声も報告。
- 効いている箇所: ツールが解く問題そのものの定義。
- 参照: <https://arxiv.org/pdf/2607.10856>

### Addy Osmani, "Comprehension Debt"（2026）
- 要旨: 理解負債は技術的負債と違い、表面上はきれいに見えるため気づきにくい。
- 参照: <https://addyosmani.com/blog/comprehension-debt/>

---

## 6. シニアの実務知見

### Google Engineering Practices
- 要旨: レビューは「全体像をつかむ → 主要部分を見る → 残りを適切な順で見る」。行うべきでない変更は早く返す。設計が最重要。人が書いたコードは全行を理解する。ツールが見せる前後数行だけでなく広い文脈で見る。
- 効いている箇所: 抽象→具体の順／詳細を読む前に妥当性を判断できる作り／diffに写らない文脈を示す必要。
- 参照:
  - Navigating a CL in review <https://google.github.io/eng-practices/review/reviewer/navigate.html>
  - What to look for in a code review <https://google.github.io/eng-practices/review/reviewer/looking-for.html>

### Felienne Hermans『プログラマー脳（The Programmer's Brain）』
- 要旨: 短期記憶と作業記憶は長期記憶に依存する。ドメインの概念を知らないと、きれいなコードでも読みにくい。複雑なコードは状態の表や依存グラフで作業記憶を補う。
- 効いている箇所: 入出力の例（値の変化）の表示／新しいドメイン用語を先に定義する必要。
- 参照:
  - InfoQ の講演要約 <https://www.infoq.com/news/2021/12/reading-code>
  - 第4章 How to read complex code <https://livebook.manning.com/book/exploring-productivity-tools/chapter-1>

### 意見が割れている点（思想には採用しない）
- テストを先に読むべきか: 推奨する記事と、逆効果とする記事の両方がある。

---

## 7. 既存ツール（比較対象）

| ツール | 特徴 | 参照 |
|---|---|---|
| CodeRabbit（Change Stack） | 関連ファイルを層にまとめ、作った順に並べる。層ごとの要約と指摘 | <https://docs.coderabbit.ai/pr-reviews/change-stack.md> |
| Sourcegraph Diff Tour | 重要なファイルを先頭に、セクションごとに説明 | <https://sourcegraph.com/docs/diff-tour> |
| diff-tour（OSS） | AI CLI が書いたツアーを矢印キーで進む。シニア視点の問いを出す | <https://github.com/init-co-jp/diff-tour> |
| balade（OSS） | Markdown のウォークスルーをレビュー画面で表示。解説とコードの一致を検証 | <https://github.com/basaltbytes/balade> |
| prtour（OSS） | 読む順の章立てと行へのノート | <https://skillsmp.com/creators/2018kguo/prtour> |
| Graphite Code Tours | PR を案内付きのウォークスルーにする | <https://graphite.com/blog/code-tours> |

このツールとの違い: 既存ツールは「まとめる・並べる・要約する」が中心。具体的な値を流して変化を追うこと、コードより一段抽象度の高い日本語を並べること、情報を絞ることを主軸にしたものは、調べた範囲では見当たらなかった。
