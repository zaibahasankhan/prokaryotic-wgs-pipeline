
![Conda](https://img.shields.io/badge/Conda-Bioinformatics-green)
![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20macOS-blue)
![License](https://img.shields.io/badge/License-MIT-yellow)
![Pipeline](https://img.shields.io/badge/Workflow-Prokaryotic%20WGS-purple)
![GitHub last commit](https://img.shields.io/github/last-commit/zaibahasankhan/prokaryotic-wgs-pipeline)
![GitHub repo size](https://img.shields.io/github/repo-size/zaibahasankhan/prokaryotic-wgs-pipeline)

=======
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
