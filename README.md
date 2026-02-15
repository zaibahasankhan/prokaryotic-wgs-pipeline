# 🧬 Prokaryotic Whole Genome Sequencing (WGS) Pipeline

A reproducible and modular bioinformatics pipeline for prokaryotic whole genome sequencing (WGS) analysis including quality control, genome assembly, annotation, antimicrobial resistance (AMR) detection, and comparative genomics.

---

## 📌 Overview

This pipeline is designed for bacterial genome analysis from raw Illumina paired-end reads to annotated genome and AMR profiling.

It is suitable for:

- Microbial genomics research
- Antimicrobial resistance (AMR) studies
- Comparative genomics

---

## 🔬 Pipeline Workflow

Raw FASTQ  
→ Quality Control (FastQC)  
→ Trimming (fastp)  
→ Genome Assembly (SPAdes)  
→ Assembly Evaluation (QUAST)  
→ Genome Completeness (BUSCO)  
→ Genome Annotation (Prokka)  
→ AMR Detection (Abricate)  
→ Average Nucleotide  Identity (FastANI)

---

## 🛠 Tools Used

| Step | Tool | Purpose |
|------|------|----------|
| QC | FastQC | Read quality assessment |
| Trimming | fastp | Adapter removal & filtering |
| Assembly | SPAdes | Genome assembly |
| Assembly QC | QUAST | Assembly statistics |
| Completeness | BUSCO | Genome completeness |
| Annotation | Prokka | Gene annotation |
| AMR Detection | Abricate | Resistance gene detection |
| Comparative Genomics | FastANI | Genome similarity |
